#!/usr/bin/env bash
echo -e "Running Compiletime Crash tests\n"

echo -e "Compiletime Crash tests\n"

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
        echo `echo $first_line | sed 's/^[[:space:]]*# *//;s/[[:space:]]*$//'`
    else
        echo "ERROR: No header match"
        exit 1
    fi
}

total_count=0
fail_count=0

for folder in $(find . -type d -mindepth 1 -maxdepth 1); do
    let total_count+=1
    cd "$folder" # navigate to current testing folder
    echo "Building and checking output of $folder"
    source ./build.sh # is expected to set RETURN_CODE variable
    echo "Finished building $folder"
    reproducer_type=$(get_reproducer_type "expected-6.0.3.txt")
    cd - > /dev/null # navigate back to previous folder

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

echo $total_count
echo $fail_count

echo "Finished running all Compiletime Crash tests"

