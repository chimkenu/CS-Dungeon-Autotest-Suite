#!/usr/bin/env bash

# Credits to Shrey's post for the general outline

# Declare the file paths
MY_FILE_PATH='./cs_dungeon'
SOLUTION_PATH='1511 cs_dungeon'

# Declare our colour codes
red="\e[0;31m"
green="\e[0;32m"
reset="\e[0m"

# Show that command is running
echo -e $reset"Running autotests for cs_dungeon.c"

# First compile the file
echo 'dcc --valgrind --leak-check cs_dungeon.c main.c -o cs_dungeon'
dcc --valgrind --leak-check cs_dungeon.c main.c -o cs_dungeon

# Keep track of number of tests passed and failed
let num_passed=0
let num_failed=0

# Run through autotests
for test_file in ./tests/*; do
    my_output=$($MY_FILE_PATH < $test_file)
    reference_output=$($SOLUTION_PATH < $test_file)

    if [ "$my_output" = "$reference_output" ]; then
        echo -e "Test $test_file ($MY_FILE_PATH) -$green passed$reset"
        let num_passed++
    else
        echo -e "Test $test_file ($MY_FILE_PATH) -$red failed$reset"
        # Show diff
        echo "Diff: (Left is your output, right is reference output)"
        # diff --new-line-format='+%L' --old-line-format='-%L' --unchanged-line-format=' %L' <(echo "$my_output") <(echo "$reference_output")
        diff -y <(echo "$my_output") <(echo "$reference_output")

        # Show test input
        echo "The inputs for this test were:"
        echo -e "$red$test_file$reset"
        let num_failed++
    fi
done

if [ $num_failed = 0 ]; then
    echo -e "$green$num_passed tests passed $num_failed tests failed$reset"
elif [ $num_passed = 0 ]; then
    echo -e "$red$num_passed tests passed $num_failed tests failed$reset"
else
    echo -e "$green$num_passed tests passed $red$num_failed tests failed$reset"
fi
