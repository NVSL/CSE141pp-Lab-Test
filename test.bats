#!/usr/bin/env bats
#-*- shell-script -*-

@test "basic config" {
    [ "$CANELA_ROOT." != "." ]
    [ "$ARCHLAB_ROOT." != "." ]
    runlab --help
}

@test "command filter" {

    ! runlab --no-validate --solution solution -- make a\$
    runlab --no-validate --solution solution -- make opt_val.out
    ! runlab --no-validate --solution solution -- ls
    runlab  --no-validate --solution solution -- special1
    runlab  --no-validate --solution solution -- special1
    ! runlab  --no-validate --solution solution -- maek foo a=b
}

@test "runlab json solution" {
    runlab --no-validate --json job.json --devel --nop 
    runlab --run-json job.json
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -vq inst_count code-stats.csv
}

