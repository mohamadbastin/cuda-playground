#include <cstdio>

__global__ void helloFromGPU() {
    int x = threadIdx.x;
    printf("hello from gpu thread %d.\n", x);
}

int main() {
    printf("hello world from cpu.\n");

    helloFromGPU<<<1, 10>>>();
    cudaDeviceReset();
//    cudaDeviceSynchronize();

    return 0;
}

