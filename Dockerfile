FROM lvguangai-gpu-cn-beijing.cr.volces.com/lvguangai/python:3.10

# 更新 apt 源，将来有需要时可以重新启用
RUN sed -i s@/deb.debian.org/@/mirrors.cloud.tencent.com/@g /etc/apt/sources.list.d/debian.sources

# 设置工作目录
WORKDIR /workspace

# 更新 APT 并安装 Python 和依赖项
RUN apt-get update && apt-get install -y \
    git curl wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 安装 Python 依赖
COPY requirements.txt /workspace/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple -r requirements.txt

# 设置 vLLM 服务端口
EXPOSE 8000
