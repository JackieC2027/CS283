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

@test "Testing built-in echo command with spaces between the quotes" {
    run ./dsh <<EOF
echo "jackie,   cheng"
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"jackie,   cheng"* ]]
}

@test "Testing built-in echo command with spaces between arguments and command" {
    run ./dsh <<EOF
echo            "jackie,   cheng"
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"jackie,   cheng"* ]]
}

@test "Testing built-in cd command with blank directory" {
    baseDirectory=$(pwd)
    run ./dsh <<EOF
cd
pwd
EOF
    endingDirectory=$(pwd)
    [ "$status" -eq 0 ]
    [ "$baseDirectory" = "$endingDirectory" ]
}

@test "Testing built-in cd command with created test directory" {
    initialDirectory=$(pwd)
    mkdir -p tmp/valid-dir
    run ./dsh <<EOF
cd tmp/valid-dir
pwd
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"/tmp/valid-dir"* ]]
}

@test "Testing built-in cd command with directory that hasn't been created" {
    baseDirectory=$(pwd)
    run ./dsh <<EOF
cd jackieFakeDirectory
EOF
    endingDirectory=$(pwd)
    echo "$status"
    [ "$status" -eq 0 ]
    [ "$baseDirectory" = "$endingDirectory" ]
}

@test "Testing built-in ls command with additional flag" {
    run ./dsh <<EOF
ls -a
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"$(ls -a)"* ]]
}

@test "Testing built-in ls command with no additional flag" {
    run ./dsh <<EOF
ls
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"$(ls)"* ]]
}

@test "Testing built-in echo command with no extra whitespace" {
    run ./dsh <<EOF
echo "hello, Jackie"
EOF
    strippedOutput=$(echo "$output" | tr -d '[:space:]')
    expectedOutput="hello,Jackiedsh2>dsh2>cmdloopreturned0"
    [ "$status" -eq 0 ]
    [ "$strippedOutput" = "$expectedOutput" ]
}

@test "Testing external command with irrelevant flags" {
    run ./dsh <<EOF
external -a
EOF
    [ "$status" -eq 0 ]
}

@test "Testing external command with no additional flags" {
    run ./dsh <<EOF
external
EOF
    [ "$status" -eq 0 ]
}

@test "Testing the built-in dragon command with no changes" {
    run ./dsh <<EOF
dragon
EOF
    [ "$status" -eq 0 ]
}

@test "Testing the built-in dragon command with irrelevant flags" {
    run ./dsh <<EOF
dragon -a
EOF
    [ "$status" -eq 0 ]
}

@test "Testing built-in exit command with no flags" {
    run ./dsh <<EOF
exit
EOF
    [ "$status" -ne 0 ]
}

@test "Testing built-in exit command with irrelevant flags" {
    run ./dsh <<EOF
exit -a
EOF
    [ "$status" -ne 0 ]
}

@test "Testing built-in ls command with whitespace between the arguments" {
    run ./dsh <<EOF
ls             -a
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"$(ls -a)"* ]]
}

@test "Testing built-in ls command with trailing spaces" {
    run ./dsh <<EOF
ls                     
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"$(ls)"* ]]
}

@test "Testing built-in ls command with leading spaces" {
    run ./dsh <<EOF
           ls
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"$(ls)"* ]]
}

@test "Testing spaces between the ls command" {
    run ./dsh <<EOF
l s
EOF
    [ "$status" -eq 0 ]
}

@test "Testing user entering no command" {
    run ./dsh <<EOF

EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"warning: no commands provided"* ]]
}

@test "Testing built-in cd command with additionally forward slash directory" {
    mkdir -p /tmp/valid-dir
    run ./dsh <<EOF
cd /tmp/valid-dir
pwd
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"/tmp/valid-dir"* ]]
}