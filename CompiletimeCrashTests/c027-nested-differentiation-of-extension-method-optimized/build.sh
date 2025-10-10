#!/usr/bin/env bash
# NB: must be optimized build
swiftc -swift-version 6 -O main.swift -o main 2>&1 | ../check.py
