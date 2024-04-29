RaneLab's CUDA Documentations
===================================

**CUDA** (Compute Unified Device Architecture) is a parallel computing platform and application programming interface (API) model created by NVIDIA. It allows software developers to use a CUDA-enabled graphics processing unit (GPU) for general purpose processing, an approach known as GPGPU (General-Purpose computing on Graphics Processing Units). The CUDA platform is designed to work with programming languages like C, C++, and Fortran.


Before you begin CUDA programming,
--------
CUDA is bad at

1. Being fast in serial applications
Standard desktop CPU speeds are on the order of several GHz. High-end GPUs are barely over 1 GHz. If you have one task that needs to be computed in serial, you won't get a raw speed benefit from a GPU. A GPU only shines when it computes things in parallel.

2. Multiple instructions
If your GPU code contains numerous instances where different threads perform different tasks (for example, "even threads execute task A while odd threads execute task B"), this can lead to inefficiencies in GPU performance. This is due to the SIMD (Single Instruction, Multiple Data) architecture of GPUs. In a situation where even threads are instructed to perform one task while odd threads are instructed to perform another, the GPU will execute the instructions for each group of threads sequentially rather than concurrently. This is because all threads in a warp (a group of threads) execute the same instruction at a time. If threads within a warp follow different execution paths, the warp executes each path sequentially, disabling threads that are not on that path. This is known as warp divergence and can lead to underutilization of the GPU's computational resources.

3. Tasks requiring large RAMs
While high-end GPUs can possess substantial amounts of RAM, they still fall short when compared to the memory access capabilities of CPUs. For instance, Nvidia's top-tier A100 GPU Chip comes with 40GB of RAM, whereas a high-end desktop computer can have 64, 128, or even 512 GB of RAM. Unlike CPUs, GPUs lack the ability to utilize hard drive space as additional RAM when required.

This difference becomes significant when running code that necessitates each GPU thread to have access to large quantities of RAM, leading to a rapid accumulation of memory usage

4. Tasks requring lots of inter-thread communication
The most recent CUDA Compute Capability introduces interthread communication, enabling thread A to fetch data from thread B, and so forth. In extensive simulations, threads often need to communicate regularly with certain other threads. This process involves substantial branching, which, as previously stated, can significantly reduce GPU performance.

5. Tasks involving File I/O
For loading or writing data to/from a file, it's more efficient to use the CPU. Given that GPUs create millions of "threads", they are not ideal for tasks requiring serial I/O. In fact, CUDA only provides the printf statement for writing operations.

Contents
--------

.. toctree::
   usage
   api
