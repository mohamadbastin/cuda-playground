//
// Created by mohamadbastin on 7/27/22.
//
#include "cstdio"
#include "../common/common.cpp"


__global__ void reduceNeighboredLess(int *g_inputData, int *g_outputData, unsigned int n) {
    unsigned int tid = threadIdx.x;
    unsigned int idx = blockDim.x * blockIdx.x + tid;

    if (idx > n) return;

    for (int stride = 1; stride < blockDim.x; stride *= 2) {
        int index = tid * stride * 2;
        if (index < blockDim.x) {
            g_inputData[idx] += g_inputData[idx + stride];
        }
        __syncthreads();
    }
    if (tid == 0) {
        g_outputData[blockIdx.x] = g_inputData[idx];
    }
}

int main() {
    int size = 1073741824;

    dim3 block(64);
    dim3 grid((size + block.x - 1) / block.x, 1);

    size_t bytes = size * sizeof(int);
    int *h_inputData = (int *) malloc(bytes);
    int *tmp = (int *) malloc(bytes);
    int *h_outputData = (int *) malloc(grid.x * sizeof(int));

    for (int i = 0; i < size; i++) {
        h_inputData[i] = 1;
        tmp[i] = 1;
    }

    double iStart, iElapsed;
    int gpuSum;

    int *d_inputData;
    int *d_outputData;
    cudaMalloc((void **) &d_inputData, bytes);
    cudaMalloc((void **) &d_outputData, grid.x * sizeof(int));

    iStart = seconds();
    int cpu_sum = recursiveReduce(tmp, size);
    iElapsed = seconds() - iStart;
    printf("cpu reduce   elapsed time: %f ms   cpu sum: %d\n", iElapsed * 1000, cpu_sum);

    cudaMemcpy(d_inputData, h_inputData, bytes, cudaMemcpyHostToDevice);
    cudaDeviceSynchronize();

    iStart = seconds();
    reduceNeighboredLess<<<grid, block>>>(d_inputData, d_outputData, size);
    cudaDeviceSynchronize();
    iElapsed = seconds() - iStart;
    cudaMemcpy(h_outputData, d_outputData, grid.x * sizeof(int), cudaMemcpyDeviceToHost);
    gpuSum = 0;
    for (int i = 0; i < grid.x; i++) gpuSum += h_outputData[i];
    printf("gpu reduce   elapsed time: %f ms   gpu sum: %d\n", iElapsed * 1000, gpuSum);

    free(h_inputData);
    free(h_outputData);
    free(tmp);
    cudaFree(d_inputData);
    cudaFree(d_outputData);
    cudaDeviceReset();

    return 0;


}