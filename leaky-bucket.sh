#!/bin/bash

ascii ()
{
    cat << "LEAKY"
    __           __
   / /__  ____ _/ /____  __
  / / _ \/ __ `/ //_/ / / /_____
 / /  __/ /_/ / ,< / /_/ /_____/
/_/\___/\__,_/_/|_|\__, /
        __        /____/ __        __
       / /_  __  _______/ /_____  / /_
      / __ \/ / / / ___/ //_/ _ \/ __/
     / /_/ / /_/ / /__/ ,< /  __/ /_
    /_.___/\__,_/\___/_/|_|\___/\__/

LEAKY
}

show_help ()
{
    LEAKY="Leaky Bucket"
    echo "$LEAKY :: Test for AWS S3 Bucket Misconfiguration"
    echo
    echo "$LEAKY [options] <bucket name>"
    echo
    echo "-h, --help            Print this message"
    echo "-a, --no-ascii        Do not print ascii"
    echo "-c, --no-color        Do not print with color"
    exit 0
}

check_aws ()
{
    &>/dev/null command -v aws

    if test $? -ne 0
    then
        >&2 echo "AWS CLI is not installed"
        >&2 echo "run: apt install awscli"
        exit 1
    fi
}

check_jq ()
{
    &>/dev/null command -v jq

    if test $? -ne 0
    then
        >&2 echo "jq is not installed"
        >&2 echo "run: apt install jq"
        exit 1
    fi
}

configure ()
{
    if ! test -f $HOME/.aws/credentials
    then
        >&2 echo "AWS CLI is not configured"
        >&2 echo "run: aws configure"
        exit 1
    fi
}

declare_flags ()
{
    export ARGV=()
    export PRINT_ASCII=true
    export PRINT_COLOR=true
}

check_flags ()
{
    while test $# -gt 0
    do
        case $1 in
            -h|--help)
                show_help
                ;;
            -a|--no-ascii)
                shift
                export PRINT_ASCII=false
                ;;
            -c|--no-color)
                shift
                export PRINT_COLOR=false
                ;;
            -*)
                >&2 echo "Unexpected flag: $1"
                exit 1
                ;;
            *)
                break
                ;;
        esac
    done

    export ARGV=$@
}

read_argv ()
{
    if test -z "$ARGV"
    then
        show_help
    fi

    IFS=" " read -a ARGS <<< $ARGV
    export ARGS=$ARGS
}

test_args ()
{
    ARGC=1
    ARGS_COUNT=${#ARGS[@]}

    if test $ARGC -ne $ARGS_COUNT
    then
        >&2 echo "Expected $ARGC argument, but got $ARGS_COUNT"
        exit 1
    fi
}

set_color ()
{
    export GREEN="\033[0;32m"
    export YELLOW="\033[1;33m"
    export RED="\033[0;31m"
}

check_aws
# configure

declare_flags
check_flags $@

read_argv
test_args

if test $PRINT_ASCII = true
then
    ascii
fi

if test $PRINT_COLOR = true
then
    set_color
fi

source_modules ()
{
    sources=("acl" "cors" "list")

    for module in ${sources[@]}
    do
        . ./modules/$module.sh
    done
}

run_tests_anon ()
{
    ANON="--no-sign-request"

    echo "Testing anonymous access..."

    test_head "$1"

    if ! test RESULT_HEAD
    then
        echo "Exiting..."
        exit 0
    fi

    test_list "$1"
    test_acl "$1"
    test_cors "$1"
}

BUCKET="${ARGS[0]}"

echo "Testing $BUCKET..."

source_modules
run_tests_anon "$BUCKET"
