#!/usr/bin/env bash
set -euo pipefail
# 25 rocksdb-windows-unsigned-long-width
# Executes only in a disposable working directory; do not point it to production.
cat > width_model.c <<'C'
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>
int main(void){
  uint64_t n=UINT64_C(0xffffffff00000000);
  unsigned long parsed=0;
  sscanf("1","%lu",&parsed);
  memcpy(&n,&parsed,sizeof(parsed));
  printf("sizeof(unsigned long)=%zu, simulated destination=0x%016" PRIx64 "\n",sizeof(parsed),n);
  return 0;
}
C
cc width_model.c -o width_model
./width_model
# This tests the numeric width mechanism, not the complete sst_dump bug on Linux.
