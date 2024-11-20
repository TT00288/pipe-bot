#!/bin/bash

# 脚本保存路径
SCRIPT_PATH="$HOME/pipe.sh"

# 检查是否以 root 用户运行脚本
if [ "$(id -u)" != "0" ]; then
    echo "此脚本需要以 root 用户权限运行。"
    echo "请尝试使用 'sudo -i' 命令切换到 root 用户，然后再次运行此脚本。"
    exit 1
fi

# 安装节点的函数
function install_node() {
    echo "开始安装节点..."
    git clone https://github.com/sdohuajia/pipe.git
    cd pipe || { echo "进入目录失败"; exit 1; }
    pip install -r requirements.txt
    
    # 提示用户输入 token
    read -p "请输入您的 token: " USER_TOKEN
    
    # 将 token 保存到 token.txt 文件中
    echo "$USER_TOKEN" > token.txt
    
    # 使用 screen 启动 python3 main.py
    screen -S pipe -dm python3 main.py

    echo "节点安装完成，token 已成���保存到 token.txt 文件中。"
    echo "要查看运行中的 screen 会话，请使用命令: screen -r pipe"
 
    # 提示用户按任意键返回主菜单
    read -n 1 -s -r -p "按任意键返回主菜单..."
}

# 主菜单函数
function main_menu() {
    while true; do
        clear
        echo "脚本由大赌社区哈哈哈哈编写，推特 @ferdie_jhovie，免费开源，请勿相信收费"
        echo "如有问题，可联系推特，仅此只有一个号"
        echo "抄袭可耻，注意你的行为"
        echo "================================================================"
        echo "退出脚本，请按键盘 ctrl + C 退出即可"
        echo "请选择要执行的操作:"
        echo "1) 安装节点"
        echo "2) 退出"
        read -p "输入选项: " option
        
        case $option in
            1) 
                install_node  # 调用安装节点的函数
                ;;
            2) 
                echo "退出脚本。"
                exit 0
                ;;
            *) 
                echo "无效选项，请重试";;
        esac
    done
}

# 调用主菜单函数
main_menu
