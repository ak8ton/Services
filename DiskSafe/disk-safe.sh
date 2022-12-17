#!/bin/bash

args=($@)
regex=$(IFS="|"; echo "${args[*]}")

function  getStat {
  grep -E -w "$regex" /proc/diskstats
}

before=$(getStat)
echo before
echo "$before"

sleep 20s

after=$(getStat)
echo
echo after
echo "$after"

unused=$(echo "$after" | grep -F -e "$before" | awk '{print $3}')

echo
echo unused $unused

for disk in $unused
do
  command="hdparm -y \"/dev/$disk\""
  echo
  echo ">" $command
  eval $command
done
