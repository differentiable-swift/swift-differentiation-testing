#!/usr/bin/env bash
swiftc main.swift -o main 2>&1 | ../check.py expected-6.0.3.txt
RETURN_CODE=$?
