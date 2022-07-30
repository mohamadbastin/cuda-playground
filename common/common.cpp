//
// Created by mohamadbastin on 7/7/22.
//
#include <sys/time.h>

int checkResult(float *A, float *B, int n) {
    for (int i = 0; i < n; i++) {
        if (A[i] != B[i]) {
            return 0;
        }
    }
    return 1;
}


void initialize(float *A, int n) {
    for (int i = 0; i < n; i++) {
        A[i] = i;
    }
}

inline double seconds() {
    struct timeval tp;
    struct timezone tzp;
    int i = gettimeofday(&tp, &tzp);
    return ((double) tp.tv_sec + (double) tp.tv_usec * 1.e-6);
}

int recursiveReduce(int *data, int const size) {
    // terminate check
    if (size == 1) return data[0];

    // renew the stride
    int const stride = size / 2;

    // in-place reduction
    for (int i = 0; i < stride; i++) {
        data[i] += data[i + stride];
    }

    // call recursively
    return recursiveReduce(data, stride);
}


