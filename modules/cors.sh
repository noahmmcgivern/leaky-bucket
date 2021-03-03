#!/bin/bash

. ./modules/utils/aws_s3api.sh
. ./modules/utils/color.sh

test_cors ()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    RESULT_CORS=`aws_s3api "get-bucket-cors" $1`

    if test $? -eq 0
    then
        echo "$RESULT_CORS"
        export RESULT_CORS=true
        err "200 - Bucket CORS is Public"
    else
        isAccessDenied=`grep AccessDenied <<< $RESULT_CORS`

        if test -n "$isAccessDenied"
        then
            export RESULT_CORS=false
            yay "AccessDenied - Bucket CORS"
        fi
    fi
}
