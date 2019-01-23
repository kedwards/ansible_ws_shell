#!/usr/bin/env bash
DISTRIB_DESCRIPTION=`awk -F"[=\"]+" '/VERSION=/ {print $2}' /etc/os-release`

[[ -r /etc/lsb-release ]] && . /etc/lsb-release

if [[ -z $DISTRIB_DESCRIPTION ]] && [[ -x /usr/bin/lsb_release ]]; then
    # Fall back to using the very slow lsb_release utility
    DISTRIB_DESCRIPTION=$(lsb_release -s -d)
fi

figlet `hostname -f | cut -d '.' -f1`
printf "\n"

printf "Welcome to Debian %s.\n" "$DISTRIB_DESCRIPTION" $(uname -r)
printf "%s\n\n" "$(uname -snrvm)"
