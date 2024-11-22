#!/usr/bin/env bash
swiftc main.swift -o main
RETURN_CODE=$?
EXPECTED_RETURN_CODE=1
