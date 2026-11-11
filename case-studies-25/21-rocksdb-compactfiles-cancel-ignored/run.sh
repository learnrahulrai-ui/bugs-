#!/usr/bin/env bash
set -euo pipefail
# 21 rocksdb-compactfiles-cancel-ignored
# Executes only in a disposable working directory; do not point it to production.
printf '%s\n' 'This case needs an upstream-specific race harness or special environment.' 'https://github.com/meta/rocksdb/issues/15536' 'Follow 02-REPRODUCE.txt and use upstream regression material.'
exit 3
