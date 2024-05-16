How To
=====

CUDA code must be in '.cu' extension.

Compile
------------
Let's say you want to compile a cuda code named 'example.cu'
Create a bash script called `compile.sh`

.. code-block:: bash
    #!/bin/bash
    module load cuda # Comment this if you are compiling on a local machine
    nvcc example.cu -o run_example

The script above will compile 'example.cu' into a binary file called `run_example`

Run
------------
To execute the compiled cuda code, run as if you were running a bash script

.. code-block:: bash
    #!/bin/bash
    ./run_example

or simply ./run_example from the command line will execute the file. 
