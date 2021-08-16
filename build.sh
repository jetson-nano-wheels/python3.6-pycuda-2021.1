#!/bin/bash

./init.sh

source venv/bin/activate
pushd pycuda-2021.1
mv dist dist-$(date +'%Y-%m-%d-%H:%M:%S') 2>/dev/null
pip wheel --no-use-pep517 --only-binary 'numpy,pyopencl' -w dist .
popd
