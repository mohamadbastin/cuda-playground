//
// Created by mohamadbastin on 7/7/22.
//

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


