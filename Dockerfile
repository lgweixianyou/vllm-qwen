# 选择官方 PyTorch + CUDA 镜像作为基础
FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04

# 更新 apt 源，将来有需要时可以重新启用
RUN sed -i 's|archive.ubuntu.com|mirrors.cloud.tencent.com|g' /etc/apt/sources.list && \
    sed -i 's|security.ubuntu.com|mirrors.cloud.tencent.com|g' /etc/apt/sources.list

# 设置工作目录
WORKDIR /workspace

# 更新 APT 并安装 Python 和依赖项
RUN apt-get update && apt-get install -y \
    python3 python3-pip git curl wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 创建 Python3 的符号链接
RUN ln -s /usr/bin/python3 /usr/bin/python

# 安装 Python 依赖
COPY requirements.txt /workspace/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -i https://mirrors.cloud.tencent.com/pypi/simple --extra-index-url https://pypi.org/simple -r requirements.txt


# 设置 vLLM 服务端口
EXPOSE 8000