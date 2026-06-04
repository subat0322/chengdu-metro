#!/bin/bash
# ==============================================
# 成都地铁智能规划 — Linux / 鲲鹏ARM 启动脚本
# 支持: Ubuntu, CentOS, Debian, 鲲鹏云(ARM64)
# ==============================================

set -e

DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$DIR"

echo "========================================"
echo "  🚇 成都地铁智能线路规划系统"
echo "  平台: $(uname -m)"
echo "========================================"

# 检查 Python
if command -v python3 &>/dev/null; then
    PYTHON=python3
elif command -v python &>/dev/null; then
    PYTHON=python
else
    echo "❌ 未找到 Python，请先安装 Python 3.9+"
    echo "   Ubuntu/Debian: sudo apt install python3 python3-pip"
    echo "   CentOS/RHEL:   sudo yum install python3 python3-pip"
    echo "   鲲鹏openEuler: sudo dnf install python3 python3-pip"
    exit 1
fi

echo "Python: $($PYTHON --version)"

# 安装依赖
echo ""
echo "📦 安装依赖..."
$PYTHON -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --quiet 2>/dev/null || \
$PYTHON -m pip install -r requirements.txt --quiet

# 加载 .env（如存在）
if [ -f .env ]; then
    echo "🔑 加载 .env 环境变量"
    set -a; source .env; set +a
fi

# 启动
echo ""
echo "🚀 启动服务 (生产模式)..."
echo "   访问: http://localhost:5000"
echo "   按 Ctrl+C 停止"
echo ""

MODE=prod $PYTHON metro_app.py
