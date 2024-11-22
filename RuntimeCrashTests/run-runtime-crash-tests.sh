#!/usr/bin/env bash
echo -e "Running Runtime Crash tests\n"

for folder in $(find . -type d -mindepth 1); do
    cd "$folder" # navigate to current testing folder
    
    echo "Building $folder"
    ./build.sh || exit 1 # This is not supposed to fail and therefore should fail this test
    echo "Finished building $folder"
    
    echo "Running $folder"
    source ./run.sh # is expected to set EXPECTED_RETURN_CODE and RETURN_CODE variables
    echo "Finished running $folder"
    
    cd - > /dev/null # navigate back to previous folder

    # Check if results match expected results, if not, exit with error
    if [ $EXPECTED_RETURN_CODE -eq 0 ]; then
        # script expected to succeed
        if [ $RETURN_CODE -eq $EXPECTED_RETURN_CODE ]; then
            # script succeeded
            echo "$folder succeeded"
        else
            # script failed unexpectedly
            echo "$folder failed unexpectedly with error code: $RETURN_CODE"
            exit 1
        fi
    else
        # script expected to fail
        if [ $RETURN_CODE -eq $EXPECTED_RETURN_CODE ]; then
            # script failed with expected error code
            echo "$folder failed with expected error code: $RETURN_CODE"
        elif [ $RETURN_CODE -eq 0 ]; then
            # script passed unexpectedly
            echo "$folder passed unexpectedly"
            exit 1
        else
            # script failed with unexpected error code
            echo "$folder failed with unexpected error code: $RETURN_CODE, expected: $EXPECTED_RETURN_CODE"
            exit 1
        fi
    fi
    
    echo -e "\n"
done

echo "Finished running all Runtime Crash tests"