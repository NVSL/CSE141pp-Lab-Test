#!/usr/bin/env bats
#-*- shell-script -*-

@test "run.py solution" {
    run2.py --no-validate --solution solution
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}

@test "run.py pipe solution" {
    run2.py --no-validate --json --nop | run2.py --run-json 
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}

@test "run.py pipe starter code" {
    run2.py --no-validate --json --nop --solution . | run2.py --run-json 
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    grep -q inst_count code-stats.csv
}

@test "run.py devel" {
    make clean
    DEVEL_MODE=yes run2.py --no-validate --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    grep -q WallTime code-stats.csv
}

@test "run.py devel cmdline" {
    make clean
    run2.py --no-validate --devel --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    grep -q WallTime code-stats.csv
}

@test "vanilla config" {
    make clean;
    make
    [ "$(cat opt_val.out)" = '0' ]
    [ "$(cat message.out)" = "no devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    grep -q inst_count code-stats.csv
}

@test "solution config" {
    make clean;
    LAB_SUBMISSION_DIR=solution make
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat message.out)" = "no devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}

@test "devel config" {
    make clean;
    DEVEL_MODE=yes make
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    grep -q WallTime code-stats.csv
}

@test "just code" {
    make clean;
    make code.exe
    ./code.exe --calc double=magic*2
    [ -e stats.csv ]
    grep WallTime stats.csv
}
