#!/usr/bin/env bats
#-*- shell-script -*-



@test "command filter" {
    archlab_check --engine papi || skip
    ! run.py --no-validate --solution solution -- make a\$
    run.py --no-validate --solution solution -- make opt_val.out
    ! run.py --no-validate --solution solution -- ls
    run.py  --no-validate --solution solution -- special1
    run.py  --no-validate --solution solution -- special1
    ! run.py  --no-validate --solution solution -- maek foo a=b
    
}

@test "run.py devel gprof" {
    make clean
    DEVEL_MODE=yes GPROF=yes run.py --no-validate --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e code.gprof ]
    grep -q WallTime code-stats.csv
}

@test "run.py solution" {
    archlab_check --engine papi || skip
    run.py --no-validate --solution solution
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q magic results.json
    grep -q inst_count code-stats.csv
}

@test "run.py json solution" {
    archlab_check --engine papi || skip
    run.py --no-validate --json --nop > job.json
    run.py --run-json job.json
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}


@test "run.py docker solution" {
    archlab_check --engine papi || skip
    run.py --no-validate --solution solution --docker --docker-image cse141pp/submission-runner:0.10 --pristine
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}

@test "run.py docker starter" {
    archlab_check --engine papi || skip
    run.py --no-validate --solution solution --docker --docker-image cse141pp/submission-runner:0.10 --pristine
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q inst_count code-stats.csv
}


@test "run.py pipe starter code" {
    archlab_check --engine papi || skip
    run.py --no-validate --json --nop --solution . | run.py --run-json 
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    grep -q inst_count code-stats.csv
}

@test "run.py devel cmdline" {
    make clean
    run.py --no-validate --devel --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    grep -q WallTime code-stats.csv
}

@test "vanilla config" {
    archlab_check --engine papi || skip
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
    archlab_check --engine papi || skip
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
    archlab_check --engine papi || skip
    make clean;
    make code.exe
    ./code.exe --calc double=magic*2
    [ -e stats.csv ]
    grep WallTime stats.csv
}
