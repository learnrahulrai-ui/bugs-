#!/bin/sh
set -eu
cd "$(dirname "$0")"
clang --version | head -1
clang -O2 -S repro.c -o result.s
printf 'Temporary form:\n'
sed -n '/^with_temp:/,/^\\.Lfunc_end0:/p' result.s | grep -E 'memmove|memcpy|mov'
printf 'Direct form:\n'
sed -n '/^direct:/,/^\\.Lfunc_end1:/p' result.s | grep -E 'memmove|memcpy|mov'
