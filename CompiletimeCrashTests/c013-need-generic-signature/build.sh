#!/usr/bin/env bash
swift -swift-version 6 build -v 2>&1 | ../check.py
