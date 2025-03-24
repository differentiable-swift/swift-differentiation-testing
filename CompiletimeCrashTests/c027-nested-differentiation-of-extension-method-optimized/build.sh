#!/usr/bin/env bash
# NB: must be optimized build
swiftc main.swift -o main 2>&1 | ../check.py
RETURN_CODE=$?
