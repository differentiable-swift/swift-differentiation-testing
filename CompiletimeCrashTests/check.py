#!/usr/bin/env python

import re
import subprocess

from bisect import bisect_left
from sys import argv, stdin, stderr
from enum import Enum
from os import environ as env
from os import listdir as ls
from result import Ok, Err, Result, is_ok, is_err
from typing import Self, TypeVar, Generic, Optional
from typeguard import typechecked

HEADER_REGEX = r"^#\s*(OK|ERROR|CRASH|XERROR)\b"

class ReproducerType(Enum):
    OK = 0      # should build successfully
    XERROR = 1  # expected to throw compilation error with proper diagnostics
    CRASH = 2   # crashes
    ERROR = 3   # should build successfully, but throws compilation error

    @staticmethod
    def parse(header: str) -> Optional[Self]:
        match = re.match(HEADER_REGEX, header)
        if match:
            return ReproducerType[match.group(1)]
        return None


class CheckError(Exception):
    pass

class MissingHeader(CheckError):
    def __init__(self):
        super().__init__(f"Expected a reproducer type header of the form {HEADER_REGEX}.")

class TestFailure(CheckError):
    def __init__(self, found: str, expected: [str]):
        message = f"FAIL: \"{expected_line} not found in \"{"".join(found)}\"\""
        super().__init__(message)
        self.missing_line = expected
        self.found = found


def errprint(*args, **kwargs):
    print(*args, **kwargs, file=stderr)


@typechecked
def run_cmd(cmd: list[str]) -> str:
    result = subprocess.run(cmd, capture_output=True)
    err = result.returncode
    if err:
        raise EnvironmentError(f'Command {' '.join(cmd)} failed with error code {retcode}')
    return result.stdout.decode().rstrip()


@typechecked
def get_env(variable: str, description: str) -> str:
    result = env.get(variable)
    if not result:
        raise EnvironmentError(f"Expected {description} to be in {variable}.")
    return result


@typechecked
def available_ground_truth_versions(kernel_name: str) -> list[str]:
    ground_truths = sorted([
        f for f in ls()
        if f.startswith("expected") and f.endswith(f"{kernel_name}.txt")
    ])
    return [f[len("expected")+1:(len(f) - len(f"{kernel_name}.txt"))-1] for f in ground_truths]


@typechecked
def greatest_lower_bound(needle: str, haystack: list[str]) -> str:
    if not haystack:
        raise ValueError("`haystack` cannot be empty")
    idx = bisect_left(haystack, needle)
    retval = haystack[idx-1] if (idx == len(haystack) or haystack[idx] > needle) else haystack[idx]
    if retval > needle:
        raise ValueError(f"No effective ground truth available for {needle}: earliest available version is {retval}")
    return retval


@typechecked
def effective_swift_version(swift_version: str, available_versions: list[str]) -> str:
    """Swift version whose ground truth is to be used.
    If `swift_version` is a release version (e.g. "6.0.3", "6.1.0" etc), and an exact match is not found in `available_versions`,
    then the latest prior release is used.

    >>> effective_swift_version("6.1.2", ["6.0.3", "6.1.0"])
    "6.1.0"

    If `swift_version` is a nightly (e.g. "nightly-main", "nightly-6.2-noble" etc), then the latest available release version is used.

    >>> effective_swift_version("nightly-6.2-noble", ["6.0.3", "6.1.0"])
    "6.1.0"
    """
    release_versions = [v for v in available_versions if "nightly" not in v]
    if "nightly" in swift_version:
        return sorted(release_versions)[-1]
    return greatest_lower_bound(swift_version, available_versions)


@typechecked
def maybe_crash(compiler_output: list[str]) -> bool:
    """Could the compiler output denote a crash?
    We expect "Stack dump" to be in the output of a crash.
    """
    return next(filter(lambda line: "Stack dump" in line, compiler_output), None) is not None


def check(expected: list[str], found: list[str]) -> Result[ReproducerType, CheckError]:
    reproducer_type = ReproducerType.parse(expected[0])
    match reproducer_type:
        case None:
            return Err(f"Expected a reproducer type header of the form {HEADER_REGEX}.")
        case ReproducerType.OK as ok:
            return Ok(ok)
    expected = expected[1:]
    idx = 0
    expected_line = expected[idx]
    for line in found:
        if expected_line.rstrip() in line.rstrip():
            idx += 1
            if idx == len(expected):
                return Ok(reproducer_type)
            expected_line = expected[idx]
        if idx == len(expected):
            return Ok(reproducer_type)
    return Err(TestFailure(expected_line, found))


def main():
    swift_version = get_env("SWIFT_VERSION", "Swift version")
    kernel_name = run_cmd(['uname', '-s'])
    available_versions = available_ground_truth_versions(kernel_name)
    ground_truth_version = effective_swift_version(swift_version, available_versions)
    # read ground truth file into list of lines
    ground_truth_filename = f"expected-{ground_truth_version}-{kernel_name}.txt"
    compiler_output = stdin.readlines()
    expected_output = []
    with open(ground_truth_filename) as file:
        while line := file.readline():
            expected_output.append(line.rstrip())

    match check(expected_output, compiler_output)):
        case Ok(reproducer_type):
            print(reproducer_type)
            exit(0)
        case Err(err):
            match err:
                case TestFailure(found, expected):
                    # TODO: handle nightlies here
                    raise err
                case _:
                    raise err



if __name__ == '__main__':
    main()
