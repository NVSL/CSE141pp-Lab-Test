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
    [ -e out.png ]
    cmp in.png out.png
    grep -q WallTime code-stats.csv
}


@test "runlab solution" {
    archlab_check --engine papi || skip
    runlab --no-validate --solution solution
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -q winning results.json
    grep -q inst_count code-stats.csv
}

@test "runlab json solution" {
    runlab --no-validate --json --devel --nop > job.json
    runlab --run-json job.json
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -vq inst_count code-stats.csv
}


@test "runlab docker solution" {
    runlab --no-validate  --devel --solution solution --docker --pristine
    [ "$(cat opt_val.out)" = '1' ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'correct answer' ]
    [ "$(cat 1.out)" = 'a' ]
    grep -vq inst_count code-stats.csv
}


@test "runlab devel solution" {
    make clean
    runlab --no-validate --devel --solution .
    [ "$(cat message.out)" = "yes devel" ]
    [ "$(cat protected.out)" = 'safe!' ]
    [ "$(cat answer.out)" = 'student answer' ]
    [ "$(cat 1.out)" = '1' ]
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
    grep -q inst_count code-stats.csv
}

@test "cloud running" {
    pushd $CONFIG_REPO_ROOT
    . config.sh
    popd
    for CLOUD_MODE in EMULATION CLOUD; do
	reconfig
	runlab.d --just-once -v  &
	sleep 1
	runlab --devel --solution . --remote  
	[ "$(cat message.out)" = "yes devel" ]
	[ "$(cat protected.out)" = 'safe!' ]
	[ "$(cat answer.out)" = 'student answer' ]
	[ "$(cat 1.out)" = '1' ]
	[ -e out.png ]
	cmp in.png out.png
	grep -q WallTime code-stats.csv
    done
}
