#!/usr/bin/env bash
set -euo pipefail
# 17 rocksdb-shared-lock-upgrade-overwrites-write
# Executes only in a disposable working directory; do not point it to production.
: "${ROCKSDB_SRC:?Set ROCKSDB_SRC to a local RocksDB checkout at the revision named in 02-REPRODUCE.txt}"
command -v python3 >/dev/null; command -v g++ >/dev/null
mkdir -p work
python3 - <<'PY'
import json,re,urllib.request,pathlib
url="https://api.github.com/repos/meta/rocksdb/issues/15510"
req=urllib.request.Request(url,headers={"User-Agent":"axiomatic-25-bug-study"})
body=json.load(urllib.request.urlopen(req))["body"] or ""
blocks=re.findall(r"\x60\x60\x60[^\n]*\n(.*?)\n\x60\x60\x60",body,re.S)
candidates=[x for x in blocks if "#include" in x and "int main" in x]
if not candidates: raise SystemExit("Upstream issue has no complete embedded C++ program; open the source report")
p=pathlib.Path("work/repro.cc"); p.write_text(candidates[0]); print("Upstream reporter C++ example saved in",p)
PY
make -C "$ROCKSDB_SRC" -j2 static_lib DISABLE_WARNING_AS_ERROR=1
LIBS="${ROCKSDB_LIBS:--pthread -ldl -lz -lbz2 -lsnappy -llz4 -lzstd -lgflags}"
g++ -std=c++20 -g -O1 -I"$ROCKSDB_SRC/include" work/repro.cc "$ROCKSDB_SRC/librocksdb.a" $LIBS -o work/repro
printf 'Built work/repro. Pass unique temporary DB path exactly as described by the reporter.\n'
