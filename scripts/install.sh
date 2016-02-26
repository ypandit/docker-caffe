#!/usr/bin/env bash

install_opencv() {
  echo "Installing OpenCV"
}

install_caffe() {
  echo "Installing BLVC Caffe"

  # Necessary symlinks for Caffe to build
  ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial.so /usr/lib/x86_64-linux-gnu/libhdf5.so
  ln -s /usr/lib/x86_64-linux-gnu/libhdf5_serial_hl.so /usr/lib/x86_64-linux-gnu/libhdf5_hl.so

  wget -c -O caffe.zip https://github.com/BVLC/caffe/archive/master.zip; unzip caffe.zip; cd caffe*

  # Install PyCaffe prerequisites
  pip install --upgrade pip
  for req in $(cat python/requirements.txt); do pip install $req; done

  cp Makefile.config.example Makefile.config
  # Enabling CPU only mode; no GPU
  sed -i 's/# CPU_ONLY := 1/CPU_ONLY := 1/' Makefile.config
  # using OpenBLAS instead of Atlas
  sed -i 's/BLAS := atlas/BLAS := open/' Makefile.config
  sed -i "s#INCLUDE_DIRS := \$(PYTHON_INCLUDE) /usr/local/include#INCLUDE_DIRS := \$(PYTHON_INCLUDE) /usr/local/include /usr/include/hdf5/serial#" Makefile.config
  sed -i "s#LIBRARY_DIRS := \$(PYTHON_LIB) /usr/local/lib /usr/lib#LIBRARY_DIRS := \$(PYTHON_LIB) /usr/local/lib /usr/lib /usr/lib/x86_64-linux-gnu#" Makefile.config
  # Disabling Cuda
  sed -i "s#CUDA_DIR := /usr/local/cuda#\# CUDA_DIR := /usr/local/cuda#" Makefile.config
  # Using latest g++
  sed -i "s/# CUSTOM_CXX := g++/CUSTOM_CXX := g++-5/" Makefile.config
  # PyCaffe build required libs
  sed -i "s#	/usr/lib/python2.7/dist-packages/numpy/core/include#	/usr/local/lib/python2.7/dist-packages/numpy/core/include#" Makefile.config
  make all -j6
  # Make PyCaffe
  make pycaffe
  # Create a Caffe distribution
  make distribute
  mv distribute /usr/local/lib/caffe
}

cowabunga() {
  # install_opencv
  install_caffe
}

cowabunga
