@echo off
chcp 65001 >nul
REM ==============================================
REM 成都地铁智能规划 — Windows 启动脚本
REM 支持: Windows 10/11
REM ==============================================

echo ========================================
echo   🚇 成都地铁智能线路规划系统
echo   平台: Windows
echo ========================================

REM 检查 Python
where python >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ 未找到 Python，请先安装 Python 3.9+
    echo    https://www.python.org/downloads/
    pause
    exit /b 1
)

python --version

REM 安装依赖
echo.
echo 📦 安装依赖...
python -m pip install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple --quiet 2>nul || python -m pip install -r requirements.txt --quiet

REM 启动
echo.
echo 🚀 启动服务...
echo    访问: http://localhost:5000
echo    按 Ctrl+C 停止
echo.

set MODE=dev
python metro_app.py

pause
