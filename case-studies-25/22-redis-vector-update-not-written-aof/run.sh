#!/usr/bin/env bash
set -euo pipefail
# 22 redis-vector-update-not-written-aof
# Executes only in a disposable working directory; do not point it to production.
command -v redis-server >/dev/null; command -v redis-cli >/dev/null
D="$(mktemp -d)"; P=26153
trap 'redis-cli -p "$P" shutdown nosave >/dev/null 2>&1 || true' EXIT
redis-server --port "$P" --save '' --dir "$D" --appendonly yes --daemonize yes
r(){ redis-cli -p "$P" "$@"; }
r VADD lesson:jobs VALUES 3 0.9 0.1 0 platform_job
r VADD lesson:jobs VALUES 3 0 1 0 platform_job
r VEMB lesson:jobs platform_job
r INFO persistence | grep aof_current_size
r SHUTDOWN
redis-server --port "$P" --save '' --dir "$D" --appendonly yes --daemonize yes
r VEMB lesson:jobs platform_job
printf 'Local AOF directory: %s\n' "$D"
