#!/usr/bin/env python

import re
import subprocess

from bisect import bisect_left
from sys import argv, stdin, stderr
from enum import Enum
from os import environ as env
from os import listdir as ls
from typing import Self

HEADER_REGEX = r"^#\s*(OK|ERROR|CRASH|XERROR)\b"

class ReproducerType(Enum):
    OK = 0      # should build successfully
    XERROR = 1  # expected to throw compilation error with proper diagnostics
    CRASH = 2   # crashes
    ERROR = 3   # should build successfully, but throws compilation error

    @staticmethod
    def parse(header: str) -> type[Self | None]:
        match = re.match(HEADER_REGEX, header)
        if match:
            return ReproducerType[match.group(1)]
        return None


def errprint(*args, **kwargs):
    print(*args, **kwargs, file=stderr)


def run_cmd(cmd: [str]) -> str:
    result = subprocess.run(cmd, capture_output=True)
    err = result.returncode
    if err:
        raise EnvironmentError(f'Command {' '.join(cmd)} failed with error code {retcode}')
    return result.stdout.decode().rstrip()


def get_env(variable: str, description: str) -> str:
    result = env.get(variable)
    if not result:
        raise EnvironmentError(f"Expected {description} to be in {variable}.")
    return result


def available_ground_truth_versions(kernel_name: str) -> [str]:
    ground_truths = [
        f for f in ls()
        if f.startswith("expected") and f.endswith(f"{kernel_name}.txt")
    ]
    return [f[len("expected")+1:(len(f) - len(f"{kernel_name}.txt"))-1] for f in ground_truths]


def greatest_lower_bound(needle: str, haystack: [str]) -> str:
    if not haystack:
        raise ValueError("`haystack` cannot be empty")
    idx = bisect_left(haystack, needle)
    if idx == len(haystack) or haystack[idx] > needle:
        return haystack[idx-1]
    return haystack[idx]


def check(expected: [str], found: [str]) -> ReproducerType:
    reproducer_type = ReproducerType.parse(expected[0])
    match reproducer_type:
        case None:
            raise ValueError(f"Expected a reproducer type header of the form {HEADER_REGEX}.")
        case ReproducerType.OK as ok:
            if found:
                raise ValueError(f"Reproducer type is {ok}, but compiler produced this output: {"".join(found)}")
            elif len(expected) > 1:
                raise ValueError(f"Reproducer type is {ok}, i.e. compiler should not output anything, but there is some output specified in the ground truth file: {"".join(expected[1:])}")
            elif not found:
                return ok
    expected = expected[1:]
    idx = 0
    expected_line = expected[idx]
    for line in found:
        if expected_line.rstrip() in line.rstrip():
            idx += 1
            if idx == len(expected):
                return reproducer_type
            expected_line = expected[idx]
        if idx == len(expected):
            return reproducer_type
    errprint(f"FAIL: \"{expected_line} not found in \"{"".join(found)}\"\"")
    exit(2)


def main():
    swift_version = get_env("SWIFT_VERSION", "Swift version")
    kernel_name = run_cmd(['uname', '-s'])
    available_versions = available_ground_truth_versions(kernel_name)
    ground_truth_version = greatest_lower_bound(swift_version, available_versions)
    compiler_output = stdin.readlines()
    # read ground truth file into list of lines
    ground_truth_filename = f"expected-{ground_truth_version}-{kernel_name}.txt"
    expected_output = []
    with open(ground_truth_filename) as file:
        while line := file.readline():
            expected_output.append(line.rstrip())
    
    print(check(expected_output, compiler_output))


if __name__ == '__main__':
    main()
