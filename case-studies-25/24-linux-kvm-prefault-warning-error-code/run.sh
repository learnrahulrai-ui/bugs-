#!/usr/bin/env bash
set -euo pipefail
# 24 linux-kvm-prefault-warning-error-code
# Executes only in a disposable working directory; do not point it to production.
printf '%s\n' 'Do not execute syzkaller reproducer on host.' 'Open https://syzkaller.appspot.com/bug?extid=db7bd0f41c2a7e82d4ba; use C repro from the reported crash row.' 'Build exact kernel SHA and supplied config in a disposable nested VM.'
exit 3
