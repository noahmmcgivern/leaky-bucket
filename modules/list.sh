#!/bin/bash

. ./modules/utils/aws_s3api.sh
. ./modules/utils/color.sh

test_head ()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    RESULT_HEAD=`aws_s3api "head-bucket" $1`

    if test $? -eq 0
    then
        export RESULT_HEAD=true
        err "200 - Bucket Access is Public"
    else
        is403=`grep 403 <<< $RESULT_HEAD`

        if test -n "$is403"
        then
            export RESULT_HEAD=true
            warn "403 - Bucket Access is Forbidden"
        fi

        is404=`grep 404 <<< $RESULT_HEAD`

        if test -n "$is404"
        then
            export RESULT_HEAD=false
            yay "404 - Bucket Not Found"
            exit 0
        fi
    fi
}

test_list ()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    RESULT_LIST=`aws_s3api "list-objects-v2" $1`

    if test $? -eq 0
    then
        export RESULT_LIST=`echo $RESULT_LIST | jq '."Contents"[]."Key"'`
        err "200 - Bucket List"
    else
        isAccessDenied=`grep AccessDenied <<< $RESULT_LIST`

        if test -n "$isAccessDenied"
        then
            export RESULT_LIST=false
            yay "AccessDenied - Bucket List"
        fi
    fi
}
