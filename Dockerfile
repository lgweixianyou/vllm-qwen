# 使用官方 x86_64 优化镜像，内置了 CUDA 12.x 和 vLLM 核心算子
FROM vllm/vllm-openai:v0.15.1-x86_64

# 1. 切换至 root 权限进行系统安装（vLLM 镜像默认通常也是 root）
USER root

# 2. 替换腾讯云 Ubuntu 源 + 安装多模态必需的系统库 (ffmpeg 等)
# 基础镜像是 Ubuntu，这里处理了多模态模型常见的动态库依赖
RUN sed -i 's/archive.ubuntu.com/mirrors.cloud.tencent.com/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.cloud.tencent.com/g' /etc/apt/sources.list && \
    apt-get update && apt-get install -y --no-install-recommends \
    git curl wget tzdata ffmpeg libsm6 libxext6 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# 3. 设置时区为北京时间
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 4. 直接安装并升级关键库
# 强制升级 transformers 和 accelerate 以支持最新的 Qwen2.5-VL 等模型
# 同时安装 qwen-vl-utils 处理多模态输入
RUN pip install --no-cache-dir -i https://mirrors.tencentyun.com/pypi/simple/ --upgrade pip && \
    pip install --no-cache-dir -i https://mirrors.tencentyun.com/pypi/simple/ \
    qwen-vl-utils \
    transformers \
    accelerate

