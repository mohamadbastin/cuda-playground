//
// Created by mohamadbastin on 6/29/22.
//

#include "cstdio"

void naiveVectorAdd(int *a, int *b, int *c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

void initializeData(int *a, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = i;
    }
}

__global__ void vectorAdd(int *a, int *b, int *c) {
    int x = threadIdx.x;
    c[x] = a[x] + b[x];

}

int main() {
    int n = 10;
    int *h_a, *h_b, *h_c;
    h_a = (int *) malloc(n * sizeof(int));
    h_b = (int *) malloc(n * sizeof(int));
    h_c = (int *) malloc(n * sizeof(int));

    initializeData(h_a, n);
    initializeData(h_b, n);

    int *d_a, *d_b, *d_c;
    cudaMalloc((int **) &d_a, n * sizeof(int));
    cudaMalloc((int **) &d_b, n * sizeof(int));
    cudaMalloc((int **) &d_c, n * sizeof(int));

    cudaMemcpy(d_a, h_a, n * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, h_b, n * sizeof(int), cudaMemcpyHostToDevice);


//    naiveVectorAdd(h_a, h_b, h_c, n);
    vectorAdd<<<1, 10>>>(d_a, d_b, d_c);

    cudaDeviceSynchronize();

    cudaMemcpy(h_c, d_c, n * sizeof(int), cudaMemcpyDeviceToHost);

    for (int i = 0; i < n; i++) {
        printf("%d ", h_c[i]);
    }

    free(h_a);
    free(h_b);
    free(h_c);
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_c);

    return 0;
}
