# Multi-arch Dockerfile — supports amd64 (Windows/Linux) and arm64 (鲲鹏/ARM)
FROM python:3.11-slim

LABEL maintainer="chengdu-metro"
LABEL description="成都地铁智能线路规划系统"
LABEL arch.support="amd64 arm64"

WORKDIR /app

# 安装依赖
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

# 复制应用代码
COPY metro_app.py .
COPY templates/ ./templates/
COPY static/ ./static/
COPY station_coords_new.json .

# 创建非root用户运行（安全）
RUN useradd -m -s /bin/bash metro && chown -R metro:metro /app
USER metro

EXPOSE 5000

# 生产环境用 waitress，支持 Windows/Linux/ARM
CMD ["python", "-c", "from waitress import serve; from metro_app import app; serve(app, host='0.0.0.0', port=5000)"]
