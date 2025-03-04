#!/usr/bin/env bash
echo -e "Running Compiletime Crash tests\n"

cd Passing
echo -e "Running Passing Compiletime Crash tests\n"
for folder in $(find . -type d -mindepth 1 -maxdepth 1); do
    cd "$folder" # navigate to current testing folder
    echo "Building $folder"
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

cd ../Failing
echo -e "Running Failing Compiletime Crash tests\n"
for folder in $(find . -type d -mindepth 1 -maxdepth 1); do
    cd "$folder" # navigate to current testing folder
    echo "Building $folder"
    if [[ $OSTYPE == 'darwin'* ]]; then
        export SDKROOT=$(xcrun --sdk macosx --show-sdk-path)
    fi
    source ./build.sh # is expected to set RETURN_CODE variable
    echo "Finished building $folder"
    cd - > /dev/null # navigate back to previous folder
    
    # script expected to fail
    if [ $RETURN_CODE -eq 0 ]; then
        # script passed unexpectedly
        echo -e "$folder passed unexpectedly\n"
        exit 1
    else
        # script failed as expected
        echo -e "$folder failed as expected\n"
    fi
done
cd ..

echo "Finished running all Compiletime Crash tests"

