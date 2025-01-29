#!/usr/bin/env bash
swiftc mainA.swift -o mainA
RETCODE_A=$?
swiftc mainB.swift -o mainB
RETCODE_B=$?
if [[ ($RETCODE_A -eq 0) || ($RETCODE_B -eq 0) ]]; then
	RETURN_CODE=0
else
	RETURN_CODE=$RETCODE_A
fi
