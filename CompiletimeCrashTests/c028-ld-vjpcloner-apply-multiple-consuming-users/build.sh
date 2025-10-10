#!/usr/bin/env bash
swiftc -swift-version 6 main.swift -o main 2>&1 | ../check.py
