#!/usr/bin/env bash
set -euo pipefail
# Requires cloned fsnotify source and Go. Compare the fix with its parent.
: "${FSNOTIFY_SRC:?Set FSNOTIFY_SRC to a local clone of fsnotify/fsnotify}"
cd "$FSNOTIFY_SRC"
git show 162b4216ab8f92ecd26425530bee198972c9b3cb -- backend_inotify.go backend_inotify_test.go
go test ./... -run TestRenameRecursiveDoesNotRenameSiblingPrefixWatch -count=1
# Test the same input at the parent revision with the regression test transplanted before comparing.
