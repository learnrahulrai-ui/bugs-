#!/usr/bin/env bash
set -euo pipefail
# Independent, temporary Redis process. Requires redis-server and redis-cli.
command -v redis-server >/dev/null; command -v redis-cli >/dev/null
D="$(mktemp -d)"; P=26151
trap 'redis-cli -p "$P" shutdown nosave >/dev/null 2>&1 || true' EXIT
redis-server --port "$P" --dir "$D" --save '' --appendonly yes --daemonize yes
redis-cli -p "$P" HSET session:1 token t1
redis-cli -p "$P" HPEXPIRE session:1 2000 FIELDS 1 token
redis-cli -p "$P" HPERSIST session:1 FIELDS 1 token
sleep 2.5
printf 'BEFORE='; redis-cli -p "$P" HGET session:1 token
redis-cli -p "$P" SHUTDOWN
redis-server --port "$P" --dir "$D" --save '' --appendonly yes --daemonize yes
printf 'AFTER='; redis-cli -p "$P" HGET session:1 token
printf 'AOF_DIR=%s\n' "$D"
