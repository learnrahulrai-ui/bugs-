#include <cuda_runtime.h>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#define CHECK(call) do { cudaError_t error=(call); if (error!=cudaSuccess) { std::fprintf(stderr,"%s:%d: %s: %s\n",__FILE__,__LINE__,#call,cudaGetErrorString(error)); std::exit(2); } } while (0)
__global__ void add(double* x, int n) {
    if (blockIdx.x * blockDim.x + threadIdx.x < n) atomicAdd(x, 1.0);
}
int main(int argc, char** argv) {
    bool upload=true, sync_warmup=false;
    for (int i=1;i<argc;++i) {
        if (std::strcmp(argv[i],"--no-upload")==0) upload=false;
        else if (std::strcmp(argv[i],"--sync-warmup")==0) sync_warmup=true;
        else { std::fprintf(stderr,"Usage: %s [--no-upload] [--sync-warmup]\n",argv[0]); return 2; }
    }
    constexpr int n=1000000;
    cudaStream_t stream;
    double* x;
    CHECK(cudaSetDevice(0));
    int runtime_version,driver_version;
    cudaDeviceProp properties;
    CHECK(cudaRuntimeGetVersion(&runtime_version));
    CHECK(cudaDriverGetVersion(&driver_version));
    CHECK(cudaGetDeviceProperties(&properties,0));
    std::printf("GPU: %s; runtime: %d; driver API: %d; upload: %d; sync warmup: %d\n",properties.name,runtime_version,driver_version,int(upload),int(sync_warmup));
    CHECK(cudaStreamCreateWithFlags(&stream,cudaStreamNonBlocking));
    CHECK(cudaMalloc(&x,sizeof(double)));
    auto apply=[&]() {
        CHECK(cudaMemsetAsync(x,0,sizeof(double),stream));
        add<<<(n+255)/256,256,0,stream>>>(x,n);
        CHECK(cudaGetLastError());
    };
    apply();
    CHECK(cudaStreamSynchronize(stream));
    for (int i=0;i<8;++i) apply();
    if (sync_warmup) CHECK(cudaStreamSynchronize(stream));
    cudaGraph_t graph;
    cudaGraphExec_t executable;
    CHECK(cudaStreamBeginCapture(stream,cudaStreamCaptureModeGlobal));
    apply();
    CHECK(cudaStreamEndCapture(stream,&graph));
    CHECK(cudaGraphInstantiateWithFlags(&executable,graph,0));
    if (upload) CHECK(cudaGraphUpload(executable,stream));
    bool passed=true;
    for (int replay=0;replay<3;++replay) {
        CHECK(cudaGraphLaunch(executable,stream));
        CHECK(cudaDeviceSynchronize());
        double value;
        CHECK(cudaMemcpy(&value,x,sizeof(double),cudaMemcpyDeviceToHost));
        std::printf("replay %d: %.0f (expected %d)\n",replay,value,n);
        passed=passed&&value==double(n);
    }
    CHECK(cudaGraphExecDestroy(executable));
    CHECK(cudaGraphDestroy(graph));
    CHECK(cudaFree(x));
    CHECK(cudaStreamDestroy(stream));
    return passed?0:1;
}
