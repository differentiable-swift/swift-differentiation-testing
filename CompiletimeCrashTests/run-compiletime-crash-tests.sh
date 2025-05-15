#!/usr/bin/env bash
echo "$(bash --version)"

echo -e "Running Compiletime Crash tests\n"
echo -e "Compiletime Crash tests\n"

if [[ $OSTYPE == 'darwin'* ]]; then
    export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi

# Use indexed arrays instead of associative arrays
test_keys=()
test_values=()

total_count=0
fail_count=0

for folder in $(find . -type d -mindepth 1 -maxdepth 1 | sed 's|^\./||'); do
    total_count=$((total_count + 1))
    cd "$folder" || exit 1
    echo "Building and checking output of $folder"
    reproducer_type=$(source ./build.sh)
    RETURN_CODE=$?
    echo "Finished building $folder"
    cd - > /dev/null || exit 1

    # Simulate associative array with parallel arrays
    test_keys+=("$folder")
    test_values+=("$reproducer_type")

    if [ $RETURN_CODE -eq 0 ]; then
        echo -e "$folder: $reproducer_type\n"
        if [[ "$reproducer_type" == "ERROR" || "$reproducer_type" == "CRASH" ]]; then
            fail_count=$((fail_count + 1))
        fi
    else
        echo -e "$folder: unexpected output\n"
        exit 1
    fi
done

# Format JSON output manually
json="{"
for i in "${!test_keys[@]}"; do
    key=${test_keys[$i]}
    value=${test_values[$i]}
    if [ $i -ne 0 ]; then
        json+=", "
    fi
    json+="\"$key\": \"$value\""
done
json+="}"

echo "$json" > compiletime-crash-test-results.json

echo "Finished running all Compiletime Crash tests"
exit 0
