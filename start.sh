# 启动 Xray，并将错误日志重定向到 boot.log，而不是丢弃
echo "Starting Xray..."
/usr/bin/xray/xray -config /etc/xray/config.json > /tmp/xray.log 2>&1 &

# 启动 Caddy
echo "Starting Caddy..."
caddy start --config /etc/caddy/Caddyfile --adapter caddyfile

# 启动隧道并保持前台
/usr/bin/cloudflared tunnel --no-autoupdate run --token "${ARGO_TOKEN}"
