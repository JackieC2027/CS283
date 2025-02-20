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

@test "Test echo command with my name" {
    run ./dsh <<EOF
echo "jackie,   cheng"
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"jackie,   cheng"* ]]
}

@test "Test cd command without no directory" {
    baseDirectory=$(pwd)
    run ./dsh <<EOF
cd
pwd
EOF
    endingDirectory=$(pwd)
    [ "$status" -eq 0 ]
    [ "$baseDirectory" = "$endingDirectory" ]
}

@test "Test cd command with created test directory" {
    initialDirectory=$(pwd)
    mkdir -p /tmp/valid-dir
    run ./dsh <<EOF
cd /tmp/valid-dir
pwd
EOF
    [ "$status" -eq 0 ]
    [[ "$output" = *"/tmp/valid-dir"* ]]
}

@test "Test cd command with directory that hasn't been created" {
    baseDirectory=$(pwd)
    run ./dsh <<EOF
cd jackieFakeDirectory
EOF
    endingDirectory=$(pwd)
    echo "$status"
    [ "$status" -eq 0 ]
    [ "$baseDirectory" = "$endingDirectory" ]
}

@test "Test ls command with -a flag" {
    run ./dsh <<EOF
ls -a
EOF
    [ "$status" -eq 0 ]
}

@test "Test ls command with no flag" {
    run ./dsh <<EOF
ls
EOF
    [ "$status" -eq 0 ]
}

@test "Test basic echo command with no extra spaces" {
    run ./dsh <<EOF
echo "hello, Jackie"
EOF
    strippedOutput=$(echo "$output" | tr -d '[:space:]')
    expectedOutput="hello,Jackiedsh2>dsh2>cmdloopreturned0"
    [ "$status" -eq 0 ]
    [ "$strippedOutput" = "$expectedOutput" ]
}

@test "Test external command with flags" {
    run ./dsh <<EOF
external -a
EOF
    [ "$status" -eq 0 ]
}

@test "Test external command with no flags" {
    run ./dsh <<EOF
external
EOF
    [ "$status" -eq 0 ]
}

@test "Test the dragon command" {
    run ./dsh <<EOF
dragon
EOF
    [ "$status" -eq 0 ]
}

@test "Test the dragon command with flags" {
    run ./dsh <<EOF
dragon -a
EOF
    [ "$status" -eq 0 ]
}

@test "Test exit with no flags" {
    run ./dsh <<EOF
exit
EOF
    [ "$status" -ne 0 ]
}

@test "Test exit with some flags" {
    run ./dsh <<EOF
exit -a
EOF
    [ "$status" -ne 0 ]
}

