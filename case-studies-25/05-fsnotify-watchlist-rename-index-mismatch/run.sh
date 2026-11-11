#!/usr/bin/env bash
set -euo pipefail
# Requires cloned fsnotify source and Go. Compare the fix with its parent.
: "${FSNOTIFY_SRC:?Set FSNOTIFY_SRC to a local clone of fsnotify/fsnotify}"
cd "$FSNOTIFY_SRC"
git show 853adeb28b4e7b01cf719f12619fcdeea8c06d48 -- backend_inotify.go backend_inotify_test.go
go test ./... -run 'TestScript|WatchList' -count=1
# Test the same input at the parent revision with the regression test transplanted before comparing.
