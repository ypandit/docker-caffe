FROM ubuntu:16.04
MAINTAINER Yogesh Pandit

WORKDIR /tmp

RUN apt-get update; apt-get install -y apt-utils git wget vim tree htop unzip python-dev python-setuptools python-pip;

# Install Caffe pre-requisites
RUN apt-get install -y libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev libhdf5-serial-dev protobuf-compiler libhdf5-dev; apt-get install -y --no-install-recommends libboost-all-dev; apt-get install -y libopenblas-base libopenblas-dev libgflags-dev libgoogle-glog-dev liblmdb-dev;

COPY scripts/install.sh /tmp/install.sh
RUN sh /tmp/install.sh; rm -rf /tmp/*
ENV PYTHONPATH=/usr/local/lib/caffe/python:$PYTHONPATH

WORKDIR /root

CMD ["/bin/bash"]
