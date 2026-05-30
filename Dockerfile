:8080 {
    handle /ss* {
        reverse_proxy 127.0.0.1:10001
    }
    handle /vless* {
        reverse_proxy 127.0.0.1:10002
    }
    handle /vmess* {
        reverse_proxy 127.0.0.1:10003
    }
    handle /xhttp-vless* {
        reverse_proxy 127.0.0.1:10005
    }
    
    # 新增 gRPC 路由。gRPC 流量到达 Caddy 时已经是解密的 HTTP/2 流
    # Xray gRPC 默认不需要 TLS，所以后端必须指定 h2c (HTTP/2 cleartext)
    handle /grpc-vless* {
        reverse_proxy h2c://127.0.0.1:10006
    }

    # 瞎猜路径的一律返回普通文字，防白嫖防探测
    handle {
        respond "Hello World" 200
    }
}
