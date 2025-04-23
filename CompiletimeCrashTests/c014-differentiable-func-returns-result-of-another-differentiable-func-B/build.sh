#!/usr/bin/env bash
swiftc main.swift -o main 2>&1 | ../check.py "expected-${SWIFT_VERSION}-`uname -s`.txt"
RETURN_CODE=$?
