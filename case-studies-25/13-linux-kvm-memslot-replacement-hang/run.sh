#!/usr/bin/env bash
set -euo pipefail
# Never run kernel fuzzers on the host. Download the C reproducer from the SOURCE page.
printf '%s\n' 'VM ONLY: https://syzkaller.appspot.com/bug?extid=5c566b850d6ab6f0427a'
printf '%s\n' '1. Open report; click C in Crashes table.'
printf '%s\n' '2. Pin exact kernel commit and .config from same crash row.'
printf '%s\n' '3. Run the downloaded C source inside a disposable nested VM.'
printf '%s\n' '4. Compare dmesg trace with original report.'
exit 3
