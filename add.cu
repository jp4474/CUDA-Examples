#include <stdio.h>
#include <chrono>
#include <cuda.h>
#include <assert.h>
#include <iostream>

#define N 102400

void add_1d(int *a, int *b, int *c) {
    int n = sizeof(a) / sizeof(int);
    for(int i = 0; i < n; i++){
        c[i] = a[i] + b[i];
    }
}

__global__ void add_1d_kernel(int *a, int *b, int *c, int n) {
    int index = threadIdx.x + blockIdx.x * blockDim.x;
    // If the index is within the range of the array, add the corresponding elements from arrays 'a' and 'b' and store the result in array 'c'.
    if (index < n){
        c[index] = a[index] + b[index];
    }
}

void add_2d(int *a, int *b, int *c, int width, int height) {
    for(int i = 0; i < height; i++){
        for(int j = 0; j < width; j++){
            c[i*width + j] = a[i*width + j] + b[i*width + j];
        }
    }
}

__global__ void add_2d_kernel(int *a, int *b, int *c, int width, int height) {
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;
    if (x < width && y < height) {
        int index = y * width + x;
        c[index] = a[index] + b[index];
    }
}

void add_3d(int *a, int *b, int *c, int width, int height, int depth) {
    for(int i = 0; i < depth; i++){
        for(int j = 0; j < height; j++){
            for(int k = 0; k < width; k++){
                c[i*width*height + j*width + k] = a[i*width*height + j*width + k] + b[i*width*height + j*width + k];
            }
        }
    }
}


__global__ void add_3d_kernel(int *a, int *b, int *c, int width, int height, int depth) {
    int x = threadIdx.x + blockIdx.x * blockDim.x;
    int y = threadIdx.y + blockIdx.y * blockDim.y;
    int z = threadIdx.z + blockIdx.z * blockDim.z;
    if (x < width && y < height && z < depth) {
        int index = z * width * height + y * width + x;
        c[index] = a[index] + b[index];
    }
}

int main() {

    // 1D
    // initialize matrices a and b 
    int *a = new int[N];
    int *b = new int[N];
    int *c = new int[N];
    
    for(int i = 0; i < N; i++) {
        a[i] = i;
        b[i] = i+1;
    }
    auto cpu_start = std::chrono::high_resolution_clock::now();

    add_1d(a, b, c);

    auto cpu_end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> cpu_elapsed = cpu_end - cpu_start;

    std::cout << "Elapsed time: " << cpu_elapsed.count() << " seconds.\n";

    auto gpu_start = std::chrono::high_resolution_clock::now();
    // Allocate memory on the GPU
    int *d_a, *d_b, *d_c;
    cudaMalloc(&d_a, N * sizeof(int));
    cudaMalloc(&d_b, N * sizeof(int));
    cudaMalloc(&d_c, N * sizeof(int));

    // Copy data from the host to the device
    cudaMemcpy(d_a, a, N * sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(d_b, b, N * sizeof(int), cudaMemcpyHostToDevice);

    // Call the kernel function
    dim3 threadsPerBlock(1024);
    dim3 numBlocks((N + threadsPerBlock.x - 1) / threadsPerBlock.x);

    add_1d_kernel<<<numBlocks, threadsPerBlock>>>(d_a, d_b, d_c, N);

    int *result = new int[N];

    // Copy data from the device to the host
    cudaMemcpy(result, d_c, N * sizeof(int), cudaMemcpyDeviceToHost);

    auto gpu_end = std::chrono::high_resolution_clock::now();
    std::chrono::duration<double> gpu_elapsed = gpu_end - gpu_start;

    std::cout << "Elapsed time: " << gpu_elapsed.count() << " seconds.\n";

    for(int i = 0; i < N; i++) {
        std::cout << c[i] << " " << result[i] << "\n";
        assert(c[i]==result[i]);
    }

    std::cout << "1D test passed.\n";
}