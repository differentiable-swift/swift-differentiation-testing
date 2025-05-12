#!/usr/bin/env bash
swift build -v 2>&1 | ../check.py
