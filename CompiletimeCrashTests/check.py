#!/usr/bin/env python
from sys import argv, stdin, stderr

def errprint(*args, **kwargs):
    print(*args, **kwargs, file=stderr)

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
    idx = 0
    expected_line = expected_output[idx]
    for line in output:
        if expected_line in line:
            idx += 1
            if idx == len(expected_output):
                exit(0)
            expected_line = expected_output[idx]
        if idx == len(expected_output):
            exit(0)
    errprint(f"FAIL: \"{expected_output[idx]}\" not found in the output") 
    exit(2)

if __name__ == '__main__':
    main()
