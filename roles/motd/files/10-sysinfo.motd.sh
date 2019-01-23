#!/usr/bin/env bash
date=`date`
load=`cat /proc/loadavg | awk '{print $1}'`
root_usage=`df -h / | awk '/\// {print $(NF-1)}'`
memory_usage=`free -m | awk '/Mem:/ { total=$2 } /buffers\/cache/ { used=$3 } END { printf("%3.1f%%", used/total*100)}'`
swap_usage=`free -m | awk '/Swap/ { printf("%3.1f%%", "exit !$2;$3/$2*100") }'`
users=`users | wc -w`
time=`uptime | grep -ohe 'up .*' | sed 's/,/\ hours/g' | awk '{ printf $2" "$3 }'`
cpu=Xen
processes=`ps aux | wc -l`
ipv4=`ifconfig $(route | grep default | awk '{ print $8 }') | grep "inet" - m 1 | awk -F: '{print $1}' | awk '{print $2}'`
ip=`ifconfig $(route | grep eth1 | awk '{ print $8 }') | grep "inet" -m 1 | awk -F: '{print $1}' | awk '{print $2}'`
# ipv4=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

printf "System info as of: %s\n" "$date"
printf "\n"
printf "System load:\t%s\tPublic IP:\t%s\n" $load $ip
printf "Platform:\t%s\tPrivate IP:\t%s\n" $cpu $ipv4
printf "Memory usage:\t%s\tSystem uptime:\t%s\n" $memory_usage "$time"
printf "Usage on /:\t%s\tSwap usage:\t%s\n" $root_usage $swap_usage
printf "Local Users:\t%s\tProcesses:\t%s\n" $users $processes
printf "\n"
