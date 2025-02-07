#!/usr/bin/env bash
# NB: must be optimized build
swiftc -O main.swift -o main
RETURN_CODE=$?
