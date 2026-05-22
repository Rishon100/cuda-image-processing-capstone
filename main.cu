#include <stdio.h>
#include <cuda_runtime.h>

__global__ void brightenImage(unsigned char *image, int width, int height)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < width * height)
    {
        image[idx] = min(255, image[idx] + 50);
    }
}

int main()
{
    int width = 256;
    int height = 256;

    int size = width * height * sizeof(unsigned char);

    unsigned char *h_image = (unsigned char*)malloc(size);

    for (int i = 0; i < width * height; i++)
    {
        h_image[i] = 100;
    }

    unsigned char *d_image;

    cudaMalloc((void**)&d_image, size);

    cudaMemcpy(d_image, h_image, size, cudaMemcpyHostToDevice);

    brightenImage<<<256, 256>>>(d_image, width, height);

    cudaMemcpy(h_image, d_image, size, cudaMemcpyDeviceToHost);

    FILE *fp = fopen("output.txt", "w");

    for (int i = 0; i < 20; i++)
    {
        fprintf(fp, "Pixel %d brightness: %d\n", i, h_image[i]);
    }

    fclose(fp);

    printf("CUDA image processing completed.\n");

    cudaFree(d_image);

    free(h_image);

    return 0;
}