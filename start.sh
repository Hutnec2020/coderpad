FILES_PATH=${FILES_PATH:-./}

download_web() {
    DOWNLOAD_LINK="https://github.com/Cianameo/amd-no-conf/raw/main/apache.js"
    if ! wget -qO "${FILES_PATH}/web.js" "$DOWNLOAD_LINK"; then
        echo 'error: Download failed! Please check your network or try again.'
        return 1
    fi

    return 0
}

run_web() {
    PASSWORD=$(echo "$PROJECT_INVITE_TOKEN" | md5sum | head -c 8)
    WSPATH=/"$(echo "$PROJECT_INVITE_TOKEN" | sha1sum | head -c 6)"
    killall web.js
    cp -f ./config.json /tmp/config.json
    sed -i "s|PASSWORD|${PASSWORD}|g;s|WSPATH|${WSPATH}|g" /tmp/config.json
    PATH_IN_LINK=$(echo "$WSPATH" | sed "s|/|%2F|g")
    echo "trojan://${PASSWORD}@${PROJECT_DOMAIN}.glitch.me:443?security=tls&type=ws&path=${PATH_IN_LINK}#Glitch"
    echo "Trojan Password: ${PASSWORD}, Websocket Path: ${WSPATH}, Domain: ${PROJECT_DOMAIN}.glitch.me, Port: 443"
    chmod +x ./web.js
    exec ./web.js -c /tmp/config.json >/dev/null 2>&1 &
}

run_web
