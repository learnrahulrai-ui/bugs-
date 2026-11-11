#!/usr/bin/env bash
set -euo pipefail
# Download original reporter's C++ proof-of-concept on user machine; do not copy it into this archive.
: "${ROCKSDB_SRC:?Set ROCKSDB_SRC to a checked-out RocksDB source tree with librocksdb.a built}"
command -v python3 >/dev/null; command -v g++ >/dev/null
mkdir -p work
python3 - <<'PY'
import json,re,urllib.request,pathlib
url="https://api.github.com/repos/meta/rocksdb/issues/15440"
req=urllib.request.Request(url,headers={"User-Agent":"bug-study-archive"})
body=json.load(urllib.request.urlopen(req))["body"] or ""
blocks=re.findall(r"\x60\x60\x60[^\n]*\n(.*?)\n\x60\x60\x60",body,re.S)
code=next((x for x in blocks if "#include" in x and "int main" in x),None)
if code is None: raise SystemExit("No standalone C++ block found; use original issue URL")
p=pathlib.Path("work/repro.cc");p.write_text(code)
print("Fetched C++ proof of concept from",url,"into",p)
PY
cd "$ROCKSDB_SRC"
make -j2 static_lib DISABLE_WARNING_AS_ERROR=1
cd - >/dev/null
LIBS="${ROCKSDB_LIBS:--pthread -ldl -lz -lbz2 -lsnappy -llz4 -lzstd -lgflags}"
g++ -std=c++20 -g -O1 -I"$ROCKSDB_SRC/include" work/repro.cc "$ROCKSDB_SRC/librocksdb.a" $LIBS -o work/repro
printf 'Built work/repro. Read issue commands for required arguments and safe path.\n'
