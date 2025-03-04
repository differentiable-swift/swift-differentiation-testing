#!/usr/bin/env bash
swift build -v 2>&1 | ../check.py expected-6.0.3.txt
RETURN_CODE=$?
