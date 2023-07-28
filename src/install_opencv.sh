#!/bin/bash

#
# @file: install_opencv.sh
#
# @Author: Sandino Morales.
# @Date: August 21, 2020.
#
# @brief This script installs OpenCV and the contrib modules.
# 
# To uninstall. From the build folder:
#
# sudo make uninstall

# Stop on error
set -e

# Install OpenCV.
TARGET_LIB=opencv
VERSION="4.1.0"
DEFAULT_SRC_DIR="/opt"

# Command line parser. It expects a single parameter for defining the working
# folder.
if [[ $1 && $1 == "help" ]]; then
  EXE_NAME=$(basename $0)
  cat <<EOF
Script to install the ${TARGET_LIB} lib

Usage: $EXE_NAME [SRC_DIR]
       $EXE_NAME help
       to display this message

SRC_DIR - Parent directory to save the ${TARGET_LIB} source directory and build files.
         Default is "${DEFAULT_SRC_DIR}"
EOF
  exit 2
fi

# First argument if present, else a default value
SRC_DIR=${1:-${DEFAULT_SRC_DIR}}

IMAGE_DEPS="
libjpeg8-dev
libopenjp2-7-dev
libpng-dev
libtiff-dev
yasm
"

VIDEO_DEPS="libavresample-dev
libswresample-dev
libavcodec-dev
libavformat-dev
libswscale-dev
libdc1394-22-dev
libxine2-dev
libv4l-dev
libtheora-dev
libxvidcore-dev
x264
v4l-utils
"

AUDIO_DEPS="
libvorbis-dev
libmp3lame-dev
libopencore-amrnb-dev
libopencore-amrwb-dev
"

DEV_DEPS="libeigen3-dev
libhdf5-dev
doxygen
libgstreamer1.0-dev
libgstreamer-plugins-base1.0-dev
libgtk2.0-dev libtbb-dev
qt5-default
libatlas-base-dev
libgoogle-glog-dev
"

# Compile with GDAL support, so that OpenCV can read bigtiff's.
GEO_DEPS="
libgdal-dev
gdal-bin
"
 
## Install dependencies
apt install -y ${IMAGE_DEPS} ${DEV_DEPS} ${GEO_DEPS}
#${AUDIO_DEPS} \
#${VIDEO_DEPS} \

# Download sources (regular and contrib) and decompress.
curl -sL https://github.com/Itseez/opencv/archive/${VERSION}.tar.gz | tar xvz -C ${SRC_DIR}
curl -sL https://github.com/opencv/opencv_contrib/archive/${VERSION}.tar.gz \
| tar xvz -C ${SRC_DIR}
# Configure and build.
mkdir ${SRC_DIR}/opencv-$VERSION/build
cd ${SRC_DIR}/opencv-$VERSION/build
cmake -DCMAKE_BUILD_TYPE=RELEASE -DENABLE_CXX11=ON \
-DBUILD_EXAMPLES=OFF -DINSTALL_C_EXAMPLES=OFF -DINSTALL_PYTHON_EXAMPLES=OFF \
-DWITH_TBB=OFF -DWITH_OPENMP=ON \
-DWITH_GDAL=ON \
-DWITH_CUDA=OFF -DWITH_NVCUVID=OFF -DWITH_CUFFT=OFF -DWITH_CUBLAS=OFF -DCUDA_FAST_MATH=OFF \
-DOPENCV_EXTRA_MODULES_PATH=${SRC_DIR}/opencv_contrib-${VERSION}/modules \
-DBUILD_opencv_ximgproc=ON \
-DBUILD_opencv_aruco=OFF -DBUILD_opencv_bgsegm=OFF -DBUILD_opencv_bioinspired=OFF \
-DBUILD_opencv_datasets=OFF -DBUILD_opencv_dnn=OFF -DBUILD_opencv_dnn_objdetect=OFF \
-DBUILD_opencv_dpm=OFF -DBUILD_opencv_face=OFF -DBUILD_opencv_fuzzy=OFF \
-DBUILD_opencv_hdf=OFF -DBUILD_opencv_hfs=OFF -DBUILD_opencv_img_hash=OFF \
-DBUILD_opencv_line_descriptor=OFF -DBUILD_opencv_ml=OFF -DBUILD_opencv_objdetect=OFF \
-DBUILD_opencv_phase_unwrapping=OFF -DBUILD_opencv_plot=OFF -DBUILD_opencv_saliency=OFF \
-DBUILD_opencv_shape=OFF -DBUILD_opencv_stereo=OFF -DBUILD_opencv_stitching=OFF \
-DBUILD_opencv_structured_light=OFF -DBUILD_opencv_surface_matching=OFF \
-DBUILD_opencv_text=OFF -DBUILD_opencv_tracking=OFF -DBUILD_opencv_ts=OFF \
-DBUILD_opencv_video=OFF -DBUILD_opencv_videoio=OFF -DBUILD_opencv_videostab=OFF \
-DBUILD_opencv_xfeatures2d=OFF -DBUILD_opencv_xobjdetect=OFF -DBUILD_opencv_xphoto=OFF \
${SRC_DIR}/opencv-$VERSION
make -j8 install && ldconfig

 
