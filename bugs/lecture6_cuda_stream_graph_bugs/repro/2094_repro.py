import argparse
import numpy as np
import warp as wp

parser = argparse.ArgumentParser()
parser.add_argument("--stream", choices=("null", "warp", "torch"), required=True)
parser.add_argument("--iterations", type=int, default=2)
args = parser.parse_args()
wp.init()
device = wp.get_device("cuda:0")
wp.set_mempool_enabled(device, False)
if args.stream == "null":
    stream = wp.Stream(device, cuda_stream=None)
elif args.stream == "warp":
    stream = wp.Stream(device)
else:
    import torch
    stream = wp.stream_from_torch(torch.cuda.Stream(device=0))
print(f"warp {wp.__version__}, stream={args.stream}, blocking={stream.is_blocking}")
source_np = np.arange(1, 65, dtype=np.int32)
source = wp.array(source_np, device=device)
outputs = [wp.empty(64, dtype=wp.int32, device=device) for _ in range(args.iterations)]
wp.synchronize_device(device)
for out in outputs:
    with wp.ScopedStream(stream):
        wp.utils.array_scan(source, out, inclusive=True)
wp.synchronize_device(device)
expected = np.cumsum(source_np, dtype=np.int32)
mismatches = sum(not np.array_equal(out.numpy(), expected) for out in outputs)
print(f"numerical mismatches: {mismatches} of {len(outputs)}")
