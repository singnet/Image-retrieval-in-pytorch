FROM ubuntu:18.04

RUN apt-get update && apt-get install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa -y
RUN apt-get update && apt-get install -y --no-install-recommends \
        git \
        build-essential \
        python3.6 \
        python3.6-dev \
        python3-pip \
        python-setuptools \
        cmake \
        wget \
        curl \
        libsm6 \
        libxext6 \ 
        libxrender-dev \
        ffmpeg


# RUN python3.6 -m pip install -U pip
# RUN python3.6 -m pip install --upgrade setuptools
RUN curl https://bootstrap.pypa.io/pip/3.6/get-pip.py | python3.6
COPY requirements.txt /tmp

WORKDIR /tmp

RUN python3.6 -m pip install -r requirements.txt

COPY . /image-retrieval-in-pytorch

WORKDIR /image-retrieval-in-pytorch

VOLUME /image-retrieval-in-pytorch/data/classed_data

EXPOSE 8014
EXPOSE 8004
EXPOSE 8003
EXPOSE 8030

RUN mkdir -p /root/.torch/models/ && wget "https://download.pytorch.org/models/resnet50-19c8e357.pth" -O /root/.torch/models/resnet50-19c8e357.pth

RUN cd Service && python3.6 -m grpc_tools.protoc -I. --python_out=. --grpc_python_out=. image_retrival.proto

RUN chmod +x install.sh && ./install.sh

# CMD ["python3.6", "run-snet-service.py","--daemon-config-path-mainnet","snet.config.example.mainnet.json","--daemon-config-path-mainnet-2","snet.config.example.mainnet-2.json","--daemon-config-path-ropsten","snet.config.example.ropsten.json"]
CMD ["python3.6", "run-snet-service.py","--daemon-config-path-mainnet_3", "snet.config.example.mainnet_3.json"]
