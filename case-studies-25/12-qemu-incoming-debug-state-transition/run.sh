#!/usr/bin/env bash
set -euo pipefail
printf '%s\n' 'Upstream test requires a project-specific VM/device/guest.'
printf '%s\n' 'https://gitlab.com/qemu-project/qemu/-/issues/1231'
printf '%s\n' 'Follow 02-REPRODUCE.txt; no safe automatic host run exists.'
exit 3
