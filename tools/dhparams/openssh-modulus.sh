#!/bin/sh

rfc3526_file="$1"

modulus=$(sed -ne "s/[\t ]*\\([0-9A-F]\{8\}\\)/\\1/gip" $rfc3526_file | paste -s -d '')
generator=$(sed -ne "s/.*The generator is:[\t ]*\\([0-9]*\\).*/\\1/gp" $rfc3526_file)
size=$((${#modulus} * 4 - 1))

printf "20030301000000 2 6 500 $size $generator $modulus\n"
