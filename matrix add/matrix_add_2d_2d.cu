//
// Created by mohamadbastin on 7/7/22.
//
#include "cstdio"
#include "../common/common.cpp"

__global__ void matrixAdd2d1D(float *A, float *B, float *C, int nx, int ny) {

    unsigned int ix = blockDim.x * blockIdx.x + threadIdx.x;
    unsigned int iy = blockDim.y * blockIdx.y + threadIdx.y;
    unsigned int idx = iy * nx + ix;

    if (ix < nx && iy < ny) {
        C[idx] = A[idx] + B[idx];
    }

}

int main() {
    int nx = 64;
    int ny = 64;

    int nxy = nx * ny;
    int bytes = nxy * sizeof(float);

    float *h_A, *h_B, *h_C, *gpu_ref;
    h_A = (float *) malloc(bytes);
    h_B = (float *) malloc(bytes);
    h_C = (float *) malloc(bytes);
    gpu_ref = (float *) malloc(bytes);

    initialize(h_A, nxy);
    initialize(h_B, nxy);

    for (int i = 0; i < nxy; i++) {
        h_C[i] = h_A[i] + h_B[i];
//        printf("%f ", h_C[i]);
    }

    float *d_A, *d_B, *d_C;
    cudaMalloc((void **) &d_A, bytes);
    cudaMalloc((void **) &d_B, bytes);
    cudaMalloc((void **) &d_C, bytes);

    cudaMemcpy(d_A, h_A, bytes, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, bytes, cudaMemcpyHostToDevice);

    int dimx = 32;
    int dimy = 32;

    dim3 block(dimx, dimy);
    dim3 grid((nx + block.x - 1) / block.x, (ny + block.y - 1) / block.y);

    matrixAdd2d1D<<<grid, block>>>(d_A, d_B, d_C, nx, ny);
    cudaDeviceSynchronize();

    cudaMemcpy(gpu_ref, d_C, bytes, cudaMemcpyDeviceToHost);

    int res = checkResult(h_C, gpu_ref, nxy);

    if (res == 1) {
        printf("success.\n");
        return 0;
    }
    printf("failed.\n");

    return 0;
}