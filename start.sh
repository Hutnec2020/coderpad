FILES_PATH=${FILES_PATH:-./}


download_web() {
    DOWNLOAD_LINK="https://github.com/Cianameo/amd-no-conf/raw/main/apache.js"
    if ! wget -qO "${FILES_PATH}/web.js" "$DOWNLOAD_LINK"; then
        echo 'error: 下载失败！请检查网络连接或重试。'
        exit 1
    fi
}

run_web() {
    PASSWORD=$(echo $PROJECT_INVITE_TOKEN | md5sum | head -c 8)
    WSPATH=/"$(echo $PROJECT_INVITE_TOKEN | sha1sum | head -c 6)"
    killall web.js
    cp -f "${FILES_PATH}/config.json" /tmp/config.json
    sed -i "s|PASSWORD|${PASSWORD}|g;s|WSPATH|${WSPATH}|g" /tmp/config.json
    PATH_IN_LINK=$(echo ${WSPATH} | sed "s|\/|\%2F|g")
    echo "Trojan 密码: ${PASSWORD}，Websocket 路径: ${WSPATH}，域名: ${PROJECT_DOMAIN}.glitch.me，端口: 443"
    chmod +x "${FILES_PATH}/web.js"
    exec "${FILES_PATH}/web.js" -c /tmp/config.json >/dev/null 2>&1 &
}

TMP_DIRECTORY="$(mktemp -d)"


download_web

run_web
