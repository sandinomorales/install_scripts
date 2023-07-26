#!/bin/bash
set -ex

ROOT_DIR=/opt
CLEAN_UP=false
OPEN3D_VERSION=0.17.0
WITH_OPENMP=ON
WITH_CUDA=ON

curl --location https://github.com/isl-org/Open3D/archive/refs/tags/v${OPEN3D_VERSION}.tar.gz | tar xzf - -C ${ROOT_DIR}
cd ${ROOT_DIR}/Open3D-${OPEN3D_VERSION}
# Install dependencies.
./util/install_deps_ubuntu.sh
# Build and install.
mkdir build && cd build cmake \
-DBUILD_SHARED_LIBS=ON \
-DBUILD_CUDA_MODULE=${WITH_CUDA} \
-DGLIBCXX_USE_CXX11_ABI=ON \
-DWITH_OPENMP=${WITH_OPENMP} \
..

make -j`nproc --all`
make install
make python-package

if [ "$CLEAN_UP" = true ]; then
  rm -r ${ROOT_DIR}/cmake-${CMAKE_TAG}-${CMAKE_ARCH}
  rm -r ${ROOT_DIR}/Open3D
fi