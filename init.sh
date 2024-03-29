#!/bin/bash

# PyCUDA uses pyopencl which in turn requires this:
sudo apt-get install ocl-icd-opencl-dev

sudo apt-get install libboost-all-dev

python3.6 -m venv venv

source venv/bin/activate
pip install --upgrade pip==21.2.4 setuptools==57.4.0 wheel==0.37.0

pip install 'https://github.com/jetson-nano-wheels/python3.6-numpy-1.19.4/releases/download/v0.0.1/numpy-1.19.4-cp36-cp36m-linux_aarch64.whl'
pip install mako==1.1.4 pybind11==2.7.1

# Note, ensure this uses the Numpy installed in the previous steps.
pip install --verbose pyopencl==2021.2.6

# Don't fetch the zip file for pycuda, instead fetch the git repo
# specifying the appropriate branch/tag. When followed by updating the
# submodules, this ensures all the necessary files are fetched, i.e.
# those in bpl-subset and pycuda/compyte.
mv pycuda-2021.1 pycuda-2021.1-$(date +'%Y-%m-%d-%H:%M:%S') 2>/dev/null
git clone --depth 1 --branch v2021.1 https://github.com/inducer/pycuda pycuda-2021.1

pushd pycuda-2021.1

git submodule update --init --recursive

# Remove all lines from pyproject.toml that specify python versions for
# Numpy since they appear to be incorrect and cause the build to fail.
cp -f pyproject.toml pyproject.toml.original
cp -f pyproject.toml pyproject.toml.bak
grep -v numpy pyproject.toml.original > pyproject.toml
# Or use my alternative:
# cp ../pycuda-pyproject.toml ./pyproject.toml

python configure.py --no-use-shipped-boost
# This shouldn't be necessary, but seems to be.
sed -i'.bak' 's/"USE_SHIPPED_BOOST", True/"USE_SHIPPED_BOOST", False/' setup.py

popd
