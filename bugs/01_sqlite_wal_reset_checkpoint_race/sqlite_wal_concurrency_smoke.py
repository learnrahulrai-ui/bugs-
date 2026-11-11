#!/usr/bin/env python3
"""Concurrency prerequisite test only. Not a guaranteed WAL-reset race reproducer."""
import sqlite3
import tempfile
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor

db = Path(tempfile.mkdtemp(prefix="swarm_sqlite_")) / "wal.db"
con = sqlite3.connect(db)
print("journal_mode =", con.execute("PRAGMA journal_mode=WAL").fetchone()[0])
con.execute("CREATE TABLE writes(id INTEGER PRIMARY KEY)")
con.commit()
con.close()

def writer():
    w = sqlite3.connect(db, timeout=10)
    for i in range(600):
        w.execute("INSERT INTO writes VALUES (?)", (i,))
        w.commit()
    w.close()

def checkpointer():
    c = sqlite3.connect(db, timeout=10)
    for _ in range(600):
        c.execute("PRAGMA wal_checkpoint(PASSIVE)").fetchone()
    c.close()

with ThreadPoolExecutor(max_workers=2) as pool:
    tasks = [pool.submit(writer), pool.submit(checkpointer)]
    for task in tasks:
        task.result()

end = sqlite3.connect(db)
n = end.execute("SELECT COUNT(*) FROM writes").fetchone()[0]
integrity = end.execute("PRAGMA integrity_check").fetchone()[0]
print("sqlite_version =", sqlite3.sqlite_version)
print("committed_rows =", n)
print("integrity_check =", integrity)
assert n == 600 and integrity == "ok"
print("NORMAL PATH PASSED; CORRUPTION NOT REPRODUCED")
end.close()
