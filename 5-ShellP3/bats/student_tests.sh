#!/usr/bin/env bats

# File: student_tests.sh
# 
# Create your unit tests suit in this file

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF                
ls
EOF
    # Assertions
    [ "$status" -eq 0 ]
}

@test "Testing a basic echo with a piped grep pattern" {
    run ./dsh <<EOF
echo "jackie cheng" | grep "jackie"
EOF
    [[ "$output" == *"jackie cheng"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing built-in cd command with piped ls" {
    run ./dsh <<EOF
cd .. | ls
EOF
    [ "$status" -eq 0 ]
}

@test "Testing external echo command with piped invalid command" {
    run ./dsh <<EOF
echo "jackie test" | jackie
EOF
    [ "$status" -eq 0 ]
}

@test "Testing a piped command with no provided command" {
    run ./dsh <<EOF
ls | | grep .c
EOF
    [[ "$output" == *"warning: no commands provided"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing extraneous whitespace between piped commands" {
    run ./dsh <<EOF
echo "jackie cheng"         |           grep "jackie"
EOF
    [[ "$output" == *"jackie cheng"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing external echo and piped word count" {
    run ./dsh <<EOF
echo "jackie cheng" | wc -l
EOF
    [[ "$output" == *"3"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing external echo command with piped rev" {
    run ./dsh <<EOF
echo "jackie cheng" | rev
EOF
    [[ "$output" == *"gnehg eikcaj"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing external echo command with piped awk" {
    run ./dsh <<EOF
echo "jackie cheng" | awk '{print $1}'
EOF
    [[ "$output" == *"jackie cheng"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing piped commands that exceeds fixed limit" {
    run ./dsh <<EOF
echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie" | echo "jackie"
EOF
    [[ "$output" == *"error: piping limited to"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing several piped commands in a row with no designated commands" {
    run ./dsh <<EOF
echo "jackie cheng" ||| grep "jackie
EOF
    [[ "$output" == *"warning: no commands provided"* ]]
    [ "$status" -eq 0 ]
}

@test "Testing external echo command with no ending command" {
    run ./dsh <<EOF
echo "jackie cheng" |
EOF
    [[ "$output" == *"warning: no commands provided"* ]]
    [ "$status" -eq 0 ]
}