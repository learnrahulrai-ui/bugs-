#!/usr/bin/env bash
set -euo pipefail
# The regression is in upstream PR 14709; use a dedicated clone.
: "${ROCKSDB_SRC:?Set ROCKSDB_SRC to clone with PR 14709 test available}"
cd "$ROCKSDB_SRC"
make -j2 log_test DISABLE_WARNING_AS_ERROR=1
./log_test --gtest_filter='*/LogTest.BadRecordInFragmentedRecordResetsRecordChecksum*'
