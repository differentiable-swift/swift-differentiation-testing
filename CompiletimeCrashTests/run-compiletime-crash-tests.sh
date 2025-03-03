#!/usr/bin/env bash
echo -e "Running Compiletime Crash tests\n"

echo -e "Compiletime Crash tests\n"
for folder in $(find . -type d -mindepth 1 -maxdepth 1); do
    cd "$folder" # navigate to current testing folder
    echo "Building and checking output of $folder"
    source ./build.sh # is expected to set RETURN_CODE variable
    echo "Finished building $folder"
    cd - > /dev/null # navigate back to previous folder

    # script expected to succeed
    if [ $RETURN_CODE -eq 0 ]; then
        # script succeeded
        echo -e "$folder passed as expected\n"
    else
        # script failed unexpectedly
        echo -e "$folder failed unexpectedly\n"
        exit 1
    fi
done

echo "Finished running all Compiletime Crash tests"

