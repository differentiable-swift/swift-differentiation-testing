#!/usr/bin/env bash
swiftc main.swift -o main 2>&1 | ../check.py check
RETURN_CODE=$?
