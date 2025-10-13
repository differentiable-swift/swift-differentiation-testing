#!/usr/bin/env bash
swift build -Xswiftc -swift-version -Xswiftc 6 -v 2>&1 | ../check.py
