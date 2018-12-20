#! /usr/bin/env bash
# Copyright (C) 2018 Sebastian Pipping <sebastian@pipping.org>
# Licensed under CC-BY-SA 3.0
# https://creativecommons.org/licenses/by-sa/3.0/

set -e
set -u

files_to_copy=(
    src/applied-crypto-hardening.html
    src/applied-crypto-hardening.pdf

    src/assets/
)
target_directory="$1"

PS4='# '
set -x

mkdir -p "${target_directory}"
cp -R "${files_to_copy[@]}" "${target_directory}"/
