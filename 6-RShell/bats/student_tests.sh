#!/usr/bin/env bats

# File: student_tests.sh
# 
# Create your unit tests suit in this file

start_server() {
    ./dsh -s -i 1.23.456.789 -p 7320 & 
    SERVER=$!
}

close_server() {
    kill -9 $SERVER
    wait $SERVER 2>/dev/null
}

@test "Example: check ls runs without errors" {
    run ./dsh <<EOF                
ls
EOF
    close_server
    # Assertions
    [ "$status" -eq 0 ]
}

@test "Testing default interface and port for starting server" {
    run ./dsh -s <<EOF                
exit
EOF
    close_server
    [ "$status" -eq 0 ]
}

@test "Testing custom interface and default port for starting server" {
    run ./dsh -s -i 1.23.456.789 <<EOF                
exit
EOF
    close_server
    [ "$status" -eq 0 ]
}

@test "Testing custom interface and custom port for starting server" {
    run ./dsh -s -i 1.23.456.789 -p 7320 <<EOF                
exit
EOF
    close_server
    [ "$status" -eq 0 ]
}

@test "Testing default interface and custom port for starting server" {
    run ./dsh -s -p 7320 <<EOF                
exit
EOF
    close_server
    [ "$status" -eq 0 ]
}

@test "Testing default interface and port for starting client" {
    run ./dsh -c <<EOF                
exit
EOF
    close_server
    [ "$status" -eq 0 ]
}