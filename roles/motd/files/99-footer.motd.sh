#!/usr/bin/env bash
[ ! -f /etc/motd.tail ] && exit 0
cat /etc/motd.tail
