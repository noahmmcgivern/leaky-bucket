#!/bin/bash

. ./modules/utils/aws_s3api.sh
. ./modules/utils/color.sh

test_acl ()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    RESULT_ACL=`aws_s3api "get-bucket-acl" $1`

    if test $? -eq 0
    then
        echo "$RESULT_ACL"
        export RESULT_ACL=true
        err "200 - Bucket ACL is Public"
    else
        isAccessDenied=`grep AccessDenied <<< $RESULT_ACL`

        if test -n "$isAccessDenied"
        then
            export RESULT_ACL=false
            yay "AccessDenied - Bucket ACL"
        fi
    fi
}
