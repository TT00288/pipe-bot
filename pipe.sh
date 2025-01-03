#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/pipe.sh"

# 检查是否以 root 用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以 root 用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到 root 用户，然后再次运行此脚本。"
    exit 1
fi

# 安装必要的依赖
function install_dependencies() {
    echo "安装必要的依赖..."
    apt update && apt upgrade -y
    apt install -y curl wget gcc git
}

# 安装 Python 3.11 
function install_python() {
    echo "安装 Python 3.11..."
    add-apt-repository ppa:deadsnakes/ppa -y
    apt install -y python3.11 python3.11-venv python3.11-dev python3-pip

    echo "验证 Python 版本..."
    python3.11 --version
}

install_dependencies
install_python

# 安装节点的函数
function install_node() {
    echo "开始安装节点..."

     # 检查是否已经存在 pipe 目录 
    if [ -d "pipe" ]; then
        echo "pipe 目录已存在，正在删除并重新安装..."
        rm -rf pipe
    fi

      # 检查并终止已存在的 pipe tmux 会话
    if tmux has-session -t pipe 2>/dev/null; then
        echo "检测到正在运行的 pipe 会话，正在终止..."
        tmux kill-session -t pipe
        echo "已终止现有的 pipe 会话。"
    fi
    
    git clone https://github.com/sdohuajia/pipe.git
    cd pipe || { echo "进入目录失败"; exit 1; }
    pip install -r requirements.txt
    
    # 提示用户输入 token
    USER_TOKEN=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJlbWFpbCI6ImpvdmpheWx5bjA5MjE5NUBvdXRsb29rLmNvbSIsImlhdCI6MTczNTExODAxNn0.wkQhIpMchRUna1qqIT4zU59037Lm4X37OlCtATM4LD4
    
    # 提示用户输入邮箱
    USER_EMAIL=jovjaylyn092195@outlook.com
    
    # 将 token 和邮箱保存到 token.txt 文件中
    echo "$USER_TOKEN,$USER_EMAIL" > token.txt

    # 提示用户输入代理IP---请输入代理IP (如需本地直连，请直接回车)
    USER_PROXY=''
    
    # 如果用户输入了代理IP，则保存到 proxy.txt 文件中
    if [ -n "$USER_PROXY" ]; then
        echo "$USER_PROXY" > proxy.txt
    else
        echo "未输入代理IP，将使用本地直连。"
    fi
    
    # 使用 正在使用 tmux 启动 main.py
    tmux new-session -d -s pipe  # 创建新的 tmux 会话，名称为 pipe
    tmux send-keys -t pipe "cd pipe" C-m  # 切换到 pipe 目录
    tmux send-keys -t pipe "python3 main.py" C-m  # 启动 main.py
    
    echo "使用 'tmux attach -t pipe' 命令来查看日志。"
    echo "要退出 tmux 会话，请按 Ctrl+B 然后按 D。"
 
}

install_node

