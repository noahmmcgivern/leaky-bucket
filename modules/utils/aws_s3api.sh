#!/bin/bash

aws_s3api ()
{
    if test $# -ne 2
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    2>&1 aws s3api $1 --bucket $2 $ANON
}
