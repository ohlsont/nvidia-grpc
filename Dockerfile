FROM nvidia/cuda:9.2-base-ubuntu16.04

### GRPC CPP ###
RUN apt-get update && apt-get install -y \
  build-essential \
  autoconf \
  libtool \
  git \
  pkg-config \
  curl \
  automake \
  libtool \
  curl \
  make \
  g++ \
  unzip \
  && apt-get clean

# install protobuf first, then grpc
ENV GRPC_RELEASE_TAG v1.12.x
RUN git clone -b ${GRPC_RELEASE_TAG} https://github.com/grpc/grpc /var/local/git/grpc && \
		cd /var/local/git/grpc && \
    git submodule update --init && \
    echo "--- installing protobuf ---" && \
    cd third_party/protobuf && \
    ./autogen.sh && ./configure --enable-shared && \
    make -j$(nproc) && make -j$(nproc) check && make install && make clean && ldconfig && \
    echo "--- installing grpc ---" && \
    cd /var/local/git/grpc && \
    make -j$(nproc) && make install && make clean && ldconfig
### END GRPC CPP ###
