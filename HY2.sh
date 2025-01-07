#!/bin/sh

# 更新系统
apk update && apk upgrade

# 安装依赖项
apk add git gcc g++ make cmake

# 下载 Hy2
git clone https://github.com/HyNetwork/Hy2.git
cd Hy2

# 编译 Hy2
mkdir build
cd build
cmake ..
make

# 安装 Hy2
make install

# 创建服务文件
cat <<EOL > /etc/init.d/hy2
#!/sbin/openrc-run

command=/usr/local/bin/hy2-server
command_args="-c /etc/hy2/config.json"
pidfile=/run/hy2.pid
name=hy2

depend() {
    need net
}

start_pre() {
    checkpath --directory --mode 0755 /run/hy2
}
EOL

# 使服务文件可执行
chmod +x /etc/init.d/hy2

# 添加服务到启动项
rc-update add hy2

# 启动 HY2
rc-service hy2 start

echo "HY2 安装完成并已启动！"
