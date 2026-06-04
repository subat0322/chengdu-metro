#!/bin/bash
# ==============================================
# 成都地铁 — 华为云一键部署脚本
# 支持: x86 ECS / 鲲鹏ARM ECS / CCE
# ==============================================
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${CYAN}============================================"
echo "  🚇 成都地铁智能规划 — 华为云部署"
echo "============================================${NC}"

ARCH=$(uname -m)
echo "架构: $ARCH"

MODE=${1:-docker}  # docker 或 direct

if [ "$MODE" = "docker" ]; then
    # ============ Docker 方式 ============
    echo ""
    echo "📦 Docker 部署模式"

    # 检查 Docker
    if ! command -v docker &>/dev/null; then
        echo -e "${RED}Docker 未安装，正在安装...${NC}"
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            case $ID in
                ubuntu|debian)
                    sudo apt update && sudo apt install -y docker.io docker-compose
                    ;;
                centos|rhel|fedora|openEuler|kylin)
                    sudo dnf install -y docker docker-compose || sudo yum install -y docker docker-compose
                    ;;
            esac
        fi
        sudo systemctl enable docker && sudo systemctl start docker
    fi

    echo "🐳 构建并启动容器..."
    if [ "$ARCH" = "aarch64" ] || [ "$ARCH" = "arm64" ]; then
        echo "   检测到鲲鹏ARM架构，自动适配"
    fi

    # 构建
    docker compose build
    docker compose up -d

    echo ""
    echo -e "${GREEN}✅ 部署完成！${NC}"
    echo "   健康检查: http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP'):5000/health"
    echo "   网页访问: http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP'):5000"

elif [ "$MODE" = "direct" ]; then
    # ============ 直接部署 ============
    echo ""
    echo "🐍 Python 直接部署模式"

    if ! command -v python3 &>/dev/null; then
        echo -e "${RED}请先安装 Python 3.9+${NC}"
        exit 1
    fi

    python3 -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --quiet 2>/dev/null || \
    python3 -m pip install -r requirements.txt --quiet

    # systemd 服务
    echo "📝 创建 systemd 服务..."
    sudo tee /etc/systemd/system/chengdu-metro.service > /dev/null << EOF
[Unit]
Description=成都地铁智能规划
After=network.target

[Service]
Type=simple
User=$USER
WorkingDirectory=$(pwd)
Environment="MODE=prod"
EnvironmentFile=$(pwd)/.env
ExecStart=/usr/bin/python3 $(pwd)/metro_app.py
Restart=always
RestartSec=5

[Install]
WantedBy=multi-user.target
EOF

    sudo systemctl daemon-reload
    sudo systemctl enable chengdu-metro --now

    echo ""
    echo -e "${GREEN}✅ 部署完成！${NC}"
    echo "   服务状态: sudo systemctl status chengdu-metro"
    echo "   查看日志: sudo journalctl -u chengdu-metro -f"
    echo "   网页访问: http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP'):5000"
fi

echo ""
echo -e "${CYAN}============================================"
echo "  🎉 手机/电脑访问:"
echo "  http://$(curl -s ifconfig.me 2>/dev/null || echo 'YOUR_IP'):5000"
echo "============================================${NC}"
