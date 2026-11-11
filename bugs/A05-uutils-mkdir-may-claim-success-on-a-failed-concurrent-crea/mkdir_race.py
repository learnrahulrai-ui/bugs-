#!/usr/bin/env python3
import argparse
import concurrent.futures
import os
import shlex
import subprocess
import tempfile
import threading
parser = argparse.ArgumentParser()
parser.add_argument('--cmd', default='/bin/mkdir')
parser.add_argument('--rounds', type=int, default=200)
parser.add_argument('--workers', type=int, default=12)
args = parser.parse_args()
if args.workers < 2 or args.rounds < 1:
    parser.error('workers >= 2 and rounds >= 1 required')
command = shlex.split(args.cmd)
if not command:
    parser.error('empty command')
violations = 0
with tempfile.TemporaryDirectory(prefix='mkdir-race-') as root:
    for i in range(args.rounds):
        path = os.path.join(root, f'entry-{i}')
        barrier = threading.Barrier(args.workers)
        def attempt(_):
            barrier.wait()
            return subprocess.run(command + [path], capture_output=True, text=True)
        with concurrent.futures.ThreadPoolExecutor(max_workers=args.workers) as pool:
            results = list(pool.map(attempt, range(args.workers)))
        successes = sum(r.returncode == 0 for r in results)
        if successes != 1:
            violations += 1
            print(f'round={i} successes={successes} codes={[r.returncode for r in results]}')
print(f'rounds={args.rounds} workers={args.workers} violations={violations}')
