#!/bin/bash

color_text ()
{
    if test $# -ne 2
    then
        echo "${FUNCNAME[0]} requires 2 arguments, got $#"
        return 1
    fi

    NO_COLOR="\033[0m"
    printf "${1}${2}${NO_COLOR}\n"
}

yay()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    color_text "$GREEN" "$1"
}

warn()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    color_text "$YELLOW" "$1"
}

err ()
{
    if test $# -ne 1
    then
        echo "${FUNCNAME[0]} requires 1 argument, got $#"
        return 1
    fi

    color_text "$RED" "$1"
}
