#!/usr/bin/env bash
set -euo pipefail
# Destructive Redis assertion on a dedicated server; never target shared instances.
command -v redis-server >/dev/null; command -v redis-cli >/dev/null
D="$(mktemp -d)"; P=26152
trap 'redis-cli -p "$P" shutdown nosave >/dev/null 2>&1 || true' EXIT
redis-server --port "$P" --dir "$D" --save '' --enable-debug-command yes --key-memory-histograms yes --daemonize yes
r() { redis-cli -p "$P" "$@"; }
r DEBUG ALLOCSIZE-SLOTS-ASSERT 1
for b in 0 100 200 300 400; do r SADD ss $(seq -f 'n%g' "$b" "$((b+99))") >/dev/null; done
r SADD ss $(seq -f 'n%g' 500 539) >/dev/null
for i in $(seq 0 249); do r ZADD zt 2 "n$i" >/dev/null; done
r ZINTERSTORE zdst 3 zt ss ss
r PING
printf 'Check server output for expected allocation assertion. DIR=%s\n' "$D"
