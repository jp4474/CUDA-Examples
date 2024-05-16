Usage
=====


1.1 1D Array Addition
------------


.. include:: examples/add.cu
   :language: c

Keep in mind that CUDA operates tasks in a thread bundle known as warps. For a single addition operation on a matrix, CUDA will initiate 32 threads.

Be aware that you cannot use sizeof() or A.size() for a std::vector A within CUDA functions. CUDA lacks the ability to determine the length of an array, meaning it doesn't know the number of computations to parallelize. Therefore, you must supply the number of operations or the size of the input arrays required for the computation as a parameter. In the add_1d_kernel example above, the size of the arrays is provided as a parameter n. 

1.2 1D Array Addition Benchmarks
------------

.. image:: examples/1d_addition_benchmarks.png

The GPU has high latency, so for operations with array sizes smaller than 1,024,000, the CPU is much faster. However, the GPU compensates for its high latency with large throughput. For example, the GPU shines when working with an array size of 1,024,000,000 or greater.













