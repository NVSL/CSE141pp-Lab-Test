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


@test "runlab devel gprof" {
    make clean
    DEVEL_MODE=yes GPROF=yes runlab --no-validate --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e code.gprof ]
    [ -e regression.out ]
    [ -e regression.json ]
    [ -e out.png ]
    cmp in.png out.png
    #grep -vq FAILED regression.out # gprof makes run_tests.exe segfault...
    grep -q WallTime code-stats.csv
}


@test "runlab solution" {
    archlab_check --engine papi || skip
    runlab --no-validate --solution solution
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    [ -e regression.out ]
    [ -e regression.json ]
    grep -vq FAILED regression.out
    grep -q magic results.json
    grep -q inst_count code-stats.csv
}

@test "runlab json solution" {
    runlab --no-validate --json --devel --nop > job.json
    runlab --run-json job.json
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    [ -e regression.out ]
    grep -vq inst_count code-stats.csv
}


@test "runlab docker solution" {
    runlab --no-validate  --devel --solution solution --docker --pristine
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    [ -e regression.out ]
    grep -vq inst_count code-stats.csv
}

@test "runlab docker starter" {
    runlab --no-validate  --devel --solution solution --docker --pristine
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    [ -e regression.out ]
    grep -qv inst_count code-stats.csv
}


@test "runlab pipe starter code" {
    runlab --no-validate  --devel --json --nop --solution . | runlab --run-json 
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ -e regression.out ]
    grep -qv inst_count code-stats.csv
}

@test "runlab devel solution" {
    make clean
    runlab --no-validate --devel --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e regression.out ]
    grep -vq FAILED regression.out
    grep -q WallTime code-stats.csv
}

@test "make" {
    archlab_check --engine papi || skip
    make clean;
    make
    [ "$(cat opt_val.out)" = '0' ]
    [ "$(cat message.out)" = "no devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e regression.out ]
    grep -q inst_count code-stats.csv
}

@test "make solution" {
    archlab_check --engine papi || skip
    make clean;
    LAB_SUBMISSION_DIR=solution make
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat message.out)" = "no devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    [ -e regression.out ]
    grep -q inst_count code-stats.csv
}

@test "make regression failure" {
    make clean;
    DEVEL_MODE=yes REGRESSION_FAIL=y make
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    grep -q FAILED regression.out
    grep -q WallTime code-stats.csv
}


@test "pubsub emulation" {
    pushd $CONFIG_REPO_ROOT
    export DEPLOYMENT_MODE=EMULATION
    . config.sh
    popd

    runlab.d --just-once -v  &
    runlab --devel --solution . --remote  

    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e regression.out ]
    [ -e regression.json ]
    [ -e out.png ]
    cmp in.png out.png
    grep -q WallTime code-stats.csv
}

@test "pubsub testing" {
    pushd $CONFIG_REPO_ROOT
    export DEPLOYMENT_MODE=TESTING
    . config.sh
    popd

    runlab.d --just-once &
    runlab --devel --solution . --remote 

    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e regression.out ]
    [ -e regression.json ]
    [ -e out.png ]
    cmp in.png out.png
    grep -q WallTime code-stats.csv
}

@test "pubsub deployed" {
    [ -v TEST_DEPLOYMENT ] || skip Testing deployment can interfere with running real jobs.
    pushd $CONFIG_REPO_ROOT
    export DEPLOYMENT_MODE=DEPLOYED
    . config.sh
    popd
    runlab.d --just-once &
    runlab --devel --solution .  --remote 

    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
    [ -e regression.out ]
    [ -e regression.json ]
    [ -e out.png ]
    cmp in.png out.png
    grep -q WallTime code-stats.csv
}

