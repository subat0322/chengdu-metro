# 🚇 成都地铁智能规划系统

成都地铁线路查询 + AI 智能路线推荐，支持 Windows / Linux / 鲲鹏ARM / 安卓。

## 快速开始（本机）

```bash
pip install -r requirements.txt
python metro_app.py
# 访问 http://localhost:5000
```

双击 `tunnel.bat` 可生成公网URL，手机也能访问。

---

## ☁️ 华为云部署

### 准备

1. 华为云 ECS（2核4G，x86 或 鲲鹏ARM 均可）
2. 系统：openEuler / Ubuntu / CentOS
3. 安全组入方向开放 **5000** 端口

### 方法一：Docker 部署（推荐）

```bash
# 1. SSH 登录华为云
ssh root@你的服务器IP

# 2. 安装 Docker（如未安装）
curl -fsSL https://get.docker.com | bash
systemctl enable docker --now

# 3. 克隆代码
git clone https://github.com/subat0322/chengdu-metro.git
cd chengdu-metro

# 4. 配置 API Key
cp .env.example .env
vi .env   # 填入你的 DeepSeek API Key

# 5. 一键部署
./deploy.sh docker
```

### 方法二：直接部署

```bash
git clone https://github.com/subat0322/chengdu-metro.git
cd chengdu-metro
cp .env.example .env
vi .env   # 填入 API Key
./deploy.sh direct   # 自动创建 systemd 服务，开机自启
```

### 访问

```
http://你的华为云公网IP:5000
```

手机、电脑、平板都能用。

---

## 📁 项目结构

```
├── metro_app.py          # 核心应用
├── templates/index.html  # 响应式前端
├── static/               # PWA 离线支持
├── Dockerfile            # 多架构容器 (x86+ARM)
├── docker-compose.yml    # 容器编排
├── deploy.sh             # 华为云一键部署
├── tunnel.py             # 公网隧道
├── start.bat / start.sh  # 本地启动
└── .env.example          # 环境变量模板
```

## 🔧 技术栈

- **后端**: Flask + Waitress
- **AI**: DeepSeek API
- **地图**: 高德地图 JS API
- **算法**: Dijkstra(A*) 多策略路径规划
- **跨平台**: Docker + PWA + 响应式

## 📱 手机使用

- 华为云部署后直接用浏览器打开
- 支持添加到主屏幕（PWA），像原生 App 一样使用
- 自适应手机/平板/电脑布局
