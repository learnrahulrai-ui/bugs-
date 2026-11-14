import warp as wp

device = wp.get_device("cuda:0")
wp.load_module(device=device)

@wp.kernel
def touch(x: wp.array(dtype=wp.float32)):
    i = wp.tid()
    if i < x.shape[0]:
        x[i] = x[i] + 1.0

main_stream = wp.get_stream(device)
sub_stream = wp.Stream(device)

wp.capture_begin(device=device, stream=main_stream, force_module_load=False)
try:
    sub_stream.wait_stream(main_stream)
    with wp.ScopedStream(sub_stream, sync_enter=False):
        for _ in range(4):
            t = wp.empty(4096, dtype=wp.float32, device=device)
            wp.launch(touch, dim=4096, inputs=[t], stream=sub_stream)
            del t
    main_stream.wait_stream(sub_stream)
finally:
    g = wp.capture_end(device=device, stream=main_stream)

replay = wp.Stream(device)
for _ in range(64):
    wp.capture_launch(g, stream=replay)
wp.synchronize_stream(replay)
