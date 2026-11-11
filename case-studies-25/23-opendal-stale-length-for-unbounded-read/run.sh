#!/usr/bin/env bash
set -euo pipefail
# 23 opendal-stale-length-for-unbounded-read
# Executes only in a disposable working directory; do not point it to production.
printf '%s\n' 'This case needs an upstream-specific race harness or special environment.' 'https://github.com/apache/opendal/issues/6995' 'Follow 02-REPRODUCE.txt and use upstream regression material.'
exit 3
