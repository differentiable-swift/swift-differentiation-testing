#!/usr/bin/env python
from sys import argv, stdin, stderr
from enum import Enum
from typing import Self
import re

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


def check(expected: [str], found: [str]):
    idx = 0
    expected_line = expected[idx]
    for line in found:
        if expected_line in line:
            idx += 1
            if idx == len(expected):
                exit(0)
            expected_line = expected[idx]
        if idx == len(expected):
            exit(0)
    errprint(f"FAIL: \"{expected_line} not found in {found}\"")
    exit(2)


def main():
    compiler_output = stdin.readlines()
    if not compiler_output and len(argv) == 1:
        # no ground truth file => OK
        exit(0)

    # read ground truth file into list of lines
    expected_output = []
    ground_truth_filename = argv[1]
    with open(ground_truth_filename) as file:
        while line := file.readline():
            expected_output.append(line.rstrip())

    match ReproducerType.parse(expected_output[0]):
        case None:
            raise ValueError(f"Expected a reproducer type header of the form {HEADER_REGEX}.")
        case ReproducerType.OK as ok:
            if len(expected_output) > 1:
                raise ValueError(f'Reproducer type is {ok}, but found expected output {expected[1:]}')
            elif not compiler_output:
                exit(0)

    # minus the header from `expected_output`
    check(expected_output[1:], compiler_output)


if __name__ == '__main__':
    main()
