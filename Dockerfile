FROM cloudflare/cloudflared:latest AS tunnel-builder

FROM alpine:latest

# 极简变量，仅需 Token
ARG ARGO_TOKEN=""
ENV ARGO_TOKEN="${ARGO_TOKEN}"

# 安装基础依赖
RUN apk add --no-cache curl unzip libc6-compat dos2unix caddy bash

# 复制隧道程序
COPY --from=tunnel-builder /usr/local/bin/cloudflared /usr/bin/cloudflared

# 单行下载原生支持 XHTTP 的稳定版 Xray 内核
RUN curl -L -H "Cache-Control: no-cache" -o xray.zip "https://github.com/XTLS/Xray-core/releases/download/v1.8.24/Xray-linux-64.zip" && mkdir -p /usr/bin/xray && unzip xray.zip -d /usr/bin/xray/ && rm xray.zip && chmod +x /usr/bin/xray/xray

# 复制配置文件
COPY config.json /etc/xray/config.json
COPY Caddyfile /etc/caddy/Caddyfile
COPY start.sh /start.sh

# 转换格式并赋予执行权限
RUN dos2unix /start.sh && chmod +x /start.sh

CMD ["/start.sh"]