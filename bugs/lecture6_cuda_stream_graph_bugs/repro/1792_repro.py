# SPDX-License-Identifier: Apache-2.0
import time
import warp as wp
from warp.sparse import bsr_zeros

REPS = 20
SPIN_ITERS = 50_000_000
NNZ_TARGET = 3
NROW = 4

@wp.kernel
def spin_then_bump_offsets(offsets: wp.array[int], mult: wp.array[float], nrow: int, nnz: int, iters: int):
    acc = mult[0]
    for i in range(iters):
        acc = acc * mult[0] + 1.0e-7
    offsets[nrow] = wp.where(acc >= 0.0, nnz, nnz - 1)

def main():
    wp.init()
    device = wp.get_device("cuda:0")
    try:
        from warp._src.context import runtime
        env = f"driver: {runtime.driver_version} | toolkit: {runtime.toolkit_version}"
    except Exception:
        env = "driver/toolkit: see nvidia-smi"
    print(f"device: {device.name} | {env}")
    failures = 0
    for rep in range(REPS):
        A = bsr_zeros(NROW, NROW, wp.float32, device=device)
        mult = wp.array([1.0000001], dtype=float, device=device)
        assert A.nnz_sync() == 0
        with wp.ScopedCapture(device=device, force_module_load=False) as capture:
            wp.launch(spin_then_bump_offsets, dim=1, inputs=[A.offsets, mult, NROW, NNZ_TARGET, SPIN_ITERS], device=device)
            A.copy_nnz_async()
        t0 = time.perf_counter()
        wp.capture_launch(capture.graph)
        t_launch = time.perf_counter() - t0
        t0 = time.perf_counter()
        nnz = A.nnz_sync()
        t_sync = time.perf_counter() - t0
        ok = nnz == NNZ_TARGET
        failures += not ok
        print(f"rep {rep:2d}: launch {1e3 * t_launch:6.1f} ms | nnz_sync {1e3 * t_sync:6.1f} ms | nnz={nnz} {'ok' if ok else 'STALE READ'}")
        wp.synchronize_device(device)
    print(f"\n{REPS - failures}/{REPS} correct" + (" -- BUG REPRODUCED" if failures else " -- not reproduced on this stack (event armed at launch)"))
    return 1 if failures else 0

if __name__ == "__main__":
    raise SystemExit(main())
