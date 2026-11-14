import warp as wp

@wp.kernel
def add(x: wp.array[wp.float64]):
    wp.atomic_add(x, 0, wp.float64(1.0))

wp.init()
n = 1_000_000
x = wp.zeros(1, dtype=wp.float64, device='cuda:0')

def apply():
    x.zero_()
    wp.launch(add, n, [x], device='cuda:0')

for _ in range(8):
    apply()
# wp.synchronize()
with wp.ScopedCapture(device='cuda:0') as capture:
    apply()
for _ in range(3):
    wp.capture_launch(capture.graph)
    wp.synchronize()
    print(x.numpy())
