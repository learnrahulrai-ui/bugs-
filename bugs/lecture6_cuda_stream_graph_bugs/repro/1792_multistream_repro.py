# Condensed from the primary issue's multi-stream follow-up reproducer (scenario 3 only).
import warp as wp
from warp.sparse import bsr_zeros

wp.init()

@wp.kernel
def spin_then_set_offsets_tail(offsets: wp.array(dtype=int), mult: wp.array(dtype=float), nrow: int, val: int, iters: int):
    acc = mult[0]
    for _i in range(iters):
        acc = acc * mult[0] + 1.0e-7
    offsets[nrow] = wp.where(acc >= 0.0, val, val - 1)

def main():
    device = wp.get_device('cuda:0')
    wp.load_module(device=device)
    stream_a = wp.Stream(device)
    stream_b = wp.Stream(device)
    matrix = bsr_zeros(4, 4, wp.float32, device=device)
    matrix.nnz_sync()
    multiplier = wp.array([1.0000001], dtype=float, device=device)

    milestone = wp.Event(device)
    stream_a.record_event(milestone)
    wp.launch(spin_then_set_offsets_tail, dim=1, inputs=[matrix.offsets, multiplier, 4, 3, 100_000_000], stream=stream_a)
    with wp.ScopedStream(stream_a, sync_enter=False):
        matrix.notify_nnz_changed(nnz=3)

    stream_b.wait_event(milestone)
    with wp.ScopedStream(stream_b, sync_enter=False):
        matrix.notify_nnz_changed(nnz=3)
        consumed = matrix.nnz_sync()

    wp.synchronize_device(device)
    buf, _event = matrix._nnz_transfer
    after = int(buf.numpy()[0])
    print(f'consumer nnz={consumed}; after device sync buffer={after}; expected=3')

if __name__ == '__main__':
    main()
