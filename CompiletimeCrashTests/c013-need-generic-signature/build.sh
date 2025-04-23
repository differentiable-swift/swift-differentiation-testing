#!/usr/bin/env bash
swift build -v 2>&1 | ../check.py "expected-${SWIFT_VERSION}-`uname -s`.txt"
RETURN_CODE=$?
