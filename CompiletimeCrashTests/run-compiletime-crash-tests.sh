#!/usr/bin/env bash
echo -e "Running Compiletime Crash tests\n"

echo -e "Compiletime Crash tests\n"

if [[ $OSTYPE == 'darwin'* ]]; then
        export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
fi


declare -A test_results

for folder in $(find . -type d -mindepth 1 -maxdepth 1 | sed 's|^\./||'); do
    let total_count+=1
    cd "$folder" # navigate to current testing folder
    echo "Building and checking output of $folder"
    reproducer_type=`source ./build.sh`
    RETURN_CODE=$?
    echo "Finished building $folder"
    cd - > /dev/null # navigate back to previous folder
    test_results[$folder]=$reproducer_type
    # script expected to succeed
    if [ $RETURN_CODE -eq 0 ]; then
        # script succeeded
        echo -e "$folder: $reproducer_type\n"
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
