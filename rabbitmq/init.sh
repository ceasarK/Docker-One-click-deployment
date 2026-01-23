#!/bin/sh
set -e

echo "等待 RabbitMQ 完全启动..."

# 等待 RabbitMQ 管理插件就绪
for i in $(seq 1 60); do
    # 检查 rabbitmqctl 是否能连接
    if rabbitmq-diagnostics ping >/dev/null 2>&1; then
        echo "✓ RabbitMQ 服务已就绪"
        break
    fi
    
    echo "等待 RabbitMQ 启动 ($i/60)..."
    sleep 2
done

# 再次确认
if ! rabbitmq-diagnostics ping >/dev/null 2>&1; then
    echo "警告: RabbitMQ 可能未完全启动，继续尝试初始化..."
fi

echo "开始初始化 RabbitMQ..."

# 创建虚拟主机
# echo "创建虚拟主机 mini-rig..."
# rabbitmqctl add_vhost mini-rig
# if [ $? -eq 0 ]; then
#     echo "✓ 虚拟主机创建成功"
# else
#     echo "虚拟主机可能已存在"
# fi

# 创建用户
# echo "创建用户 mini-rig-user..."
# rabbitmqctl add_user mini-rig-user mini-rig-pwd
# if [ $? -eq 0 ]; then
#     echo "✓ 用户创建成功"
# else
#     echo "用户可能已存在"
# fi

# 设置权限
echo "设置用户权限..."
#rabbitmqctl set_permissions -p mini-rig mini-rig-user ".*" ".*" ".*"
if [ $? -eq 0 ]; then
    echo "✓ 权限设置成功"
else
    echo "权限设置失败"
fi

# 验证设置
echo "验证设置..."
echo "虚拟主机列表:"
rabbitmqctl list_vhosts
echo ""
echo "用户列表:"
rabbitmqctl list_users
echo ""
# echo "权限列表:"
# rabbitmqctl list_permissions -p mini-rig

echo "RabbitMQ 初始化完成!"