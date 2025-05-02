#!/usr/bin/env bash
echo -e "Running Compiletime Crash tests\n"

echo -e "Compiletime Crash tests\n"

if [[ $OSTYPE == 'darwin'* ]]; then
        export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi

# `get_reproduce_type(file)`
# Reads the first line of `file` and tries to parse it as a reproducer type header.
# A header is expected to be of the PCRE form ^#\s*(OK|ERROR|CRASH|XERROR)
# - OK: compiles successfully
# - ERROR: expected to compile successfully, but throws a compilation error with some diagnostic --OR-- expected to throw a compilation error, but compiler presents a different diagnostic
# - XERROR: expected to throw compilation error with correct diagnostic
# - CRASH: crashes the compiler
get_reproducer_type() {
    local file="$1"
    local first_line
    if [[ ! -e $file ]]; then
        echo "OK"
        return 0
    fi
    first_line=$(head -n 1 "$file" 2>/dev/null)
    if [[ $first_line =~ ^#[[:space:]]*(OK|ERROR|CRASH|XERROR) ]]; then
        # capture groups not working?
        # echo ="${BASH_REMATCH[1]}"
        # strips "#\s*" from the left, and spaces and newlines from the right
        echo `echo $first_line | sed 's/^[[:space:]]*# *//;s/[[:space:]]*$//'`
    else
        echo "ERROR: No header match"
        exit 1
    fi
}

declare -A test_results

for folder in $(find . -type d -mindepth 1 -maxdepth 1 | sed 's|^\./||'); do
    let total_count+=1
    cd "$folder" # navigate to current testing folder
    echo "Building and checking output of $folder"
    source ./build.sh # is expected to set RETURN_CODE variable
    echo "Finished building $folder"
    reproducer_type=$(get_reproducer_type "expected-${SWIFT_VERSION}-`uname -s`.txt")
    cd - > /dev/null # navigate back to previous folder
    test_results[$folder]=$reproducer_type
    # script expected to succeed
    if [ $RETURN_CODE -eq 0 ]; then
        # script succeeded
        echo -e "$folder: $reproducer_type (expected)\n"
        if [[ "$reproducer_type" = "ERROR" || "$reproducer_type" = "CRASH" ]]; then
            fail_count=$((fail_count + 1))
        fi
    else
        # script failed unexpectedly
        echo -e "$folder: unexpected output\n"
        exit 1
    fi
done

# format JSON
json="{"
first=1
for test in "${!test_results[@]}"; do
    value=${test_results[$test]}
    if [[ $first -eq 0 ]]; then
        json+=", "
    fi
    json+="\"$test\": \"$value\" "
    first=0
done
json+="}"

echo $json > compiletime-crash-test-results.json

echo "Finished running all Compiletime Crash tests"
exit 0
