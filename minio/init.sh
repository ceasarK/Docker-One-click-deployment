#!/bin/bash
set -e

# 获取脚本参数
MINIO_ROOT_USER="${1}"
MINIO_ROOT_PASSWORD="${2}"
SERVER_PORT="${3}"
CONSOLE_PORT="${4}"

echo "=== MinIO 初始化脚本 ==="
echo "开始时间: $(date)"

# 函数：等待服务就绪
wait_for_minio() {
    local max_attempts=60
    local attempt=1
    local api_ready=false
    local console_ready=false
    
    echo "等待 MinIO 服务就绪..."
    
    while [ $attempt -le $max_attempts ]; do
        # 检查 API 健康端点
        if [ "$api_ready" = "false" ]; then
            if curl -f -s -o /dev/null http://localhost:$SERVER_PORT/minio/health/live 2>/dev/null; then
                echo "✓ MinIO API 在 $(date) 就绪 (尝试 $attempt/$max_attempts)"
                api_ready=true
            fi
        fi
        
        # 检查控制台
        if [ "$api_ready" = "true" ] && [ "$console_ready" = "false" ]; then
            if curl -f -s -o /dev/null http://localhost:$CONSOLE_PORT 2>/dev/null; then
                echo "✓ MinIO 控制台在 $(date) 就绪 (尝试 $attempt/$max_attempts)"
                console_ready=true
            fi
        fi
        
        # 如果都就绪，退出循环
        if [ "$api_ready" = "true" ] && [ "$console_ready" = "true" ]; then
            echo "✓ MinIO 完全就绪"
            return 0
        fi
        
        echo "等待 MinIO... 尝试 $attempt/$max_attempts"
        sleep 2
        attempt=$((attempt + 1))
    done
    
    echo "✗ MinIO 在 $max_attempts 次尝试后仍未完全就绪"
    return 1
}

# 函数：执行命令并检查结果
safe_exec() {
    echo ""
    echo "执行: $*"
    if "$@"; then
        echo "✓ 成功"
        return 0
    else
        local exit_code=$?
        echo "✗ 失败 (退出码: $exit_code)"
        return $exit_code
    fi
}

# 主流程
if wait_for_minio; then
    echo ""
    echo "开始 MinIO 配置..."
    
    # 配置 MinIO 客户端

#创建桶

#创建一个实例用户

#设置桶公开
#mc anonymous set public  /myminio/mini-rig


    # 配置 mc 客户端
    safe_exec mc alias set myminio http://localhost:$SERVER_PORT "$MINIO_ROOT_USER" "$MINIO_ROOT_PASSWORD"
    
    # 创建存储桶
    safe_exec mc mb myminio/mini-rig --ignore-existing
    
    # 创建用户
#    safe_exec mc admin user add myminio mini-rig minirigadmin
  
    #授权用户一个桶的读写权限
#    safe_exec mc admin policy attach myminio readwrite --user mini-rig

    #设置桶数据可下载（不受权限限制）
    safe_exec mc anonymous set download myminio/mini-rig
    echo ""
    echo "=== 初始化完成 ==="
    echo "完成时间: $(date)"
fi