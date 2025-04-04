#!/usr/bin/env python
from sys import argv, stdin, stderr
from enum import Enum
from typing import Self
import re

class ReproducerType(Enum):
    OK = 0      # should build successfully
    XERROR = 1  # expected to throw compilation error with proper diagnostics
    CRASH = 2   # crashes
    ERROR = 3   # should build successfully, but throws compilation error

    @staticmethod
    def parse(header: str) -> type[Self | None]:
        match = re.match(r"^#\s*(OK|ERROR|CRASH|XERROR)\b", header)
        if match:
            return ReproducerType[match.group(1)]
        return None


def errprint(*args, **kwargs):
    print(*args, **kwargs, file=stderr)

def check(expected: [str], found: [str]):
    reproducer_type = ReproducerType.parse(expected[0])
    if reproducer_type:
        expected = expected[1:]
    if not expected:
        if not found:
            exit(0)
        errprint(f"FAIL: expected no output, found {found}")
        exit(1)
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
    expected_output = []
    if len(argv) == 2:
        ground_truth_filename = argv[1]
        with open(ground_truth_filename) as file:
            while line := file.readline():
                expected_output.append(line.rstrip())
        assert(len(expected_output) > 0)
    output = stdin.readlines()
    if not expected_output:
        if not output:
            exit(0)
        errprint(f"FAIL: expected no output, found {output}")
        exit(1)
    check(expected_output, output)

if __name__ == '__main__':
    main()
