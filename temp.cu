//
// Created by mohamadbastin on 6/30/22.
//
#include "cstdio"

int main(int argc, char **argv) {
    int n = 1024;

    dim3 block(1024);
    dim3 grid((n + block.x - 1) / block.x);
    printf("grid.x %d block.x %d \n", grid.x, block.x);

    block.x = 512;
    grid.x = (n + block.x - 1) / block.x;
    printf("grid.x %d block.x %d \n", grid.x, block.x);

    block.x = 256;
    grid.x = (n + block.x - 1) / block.x;
    printf("grid.x %d block.x %d \n", grid.x, block.x);

    block.x = 128;
    grid.x = (n + block.x - 1) / block.x;
    printf("grid.x %d block.x %d \n", grid.x, block.x);


    return 0;
}