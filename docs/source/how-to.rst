How To
=====

Compile
------------
Let's say I want to compile a cuda code named 'example.cu'

```bash

# module load cuda # <-- Uncomment this if you are compiling on HPC
nvcc example.cu -o run_example

```

Run
------------
To execute the compiled cuda code, run as if you were running a shell script

```bash

./run_example

```
