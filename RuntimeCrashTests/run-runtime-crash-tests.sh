#!/usr/bin/env bash
echo -e "Running Runtime Crash tests\n"

cd Passing
echo -e "Running Passing Runtime Crash tests\n"
for folder in $(find . -type d -depth 1); do
    cd "$folder" # navigate to current testing folder
    
    echo "Building $folder"
    ./build.sh || exit 1 # This is not supposed to fail and therefore should fail this test
    echo "Finished building $folder"
    
    echo "Running $folder"
    source ./run.sh # is expected to set RETURN_CODE variable
    echo "Finished running $folder"
    
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
echo -e "Running Failing Runtime Crash tests\n"
for folder in $(find . -type d -depth 1); do
    cd "$folder" # navigate to current testing folder
    
    echo "Building $folder"
    ./build.sh || exit 1 # This is not supposed to fail and therefore should fail this test
    echo "Finished building $folder"
    
    echo "Running $folder"
    source ./run.sh # is expected to set RETURN_CODE variable
    echo "Finished running $folder"
    
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

echo "Finished running all Runtime Crash tests"
