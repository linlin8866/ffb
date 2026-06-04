# curl一键
bash <(curl -Ls https://raw.githubusercontent.com/linlin8866/ffb/main/ip.sh)
# wget一键
bash <(wget -qO- https://raw.githubusercontent.com/linlin8866/ffb/main/ip.sh)


#带域名自动SSL
IP_DOMAIN=xxx.xxx.com bash <(curl -Ls https://cdn.jsdelivr.net/gh/linlin8866/ffb@main/ip.sh)

#无域名默认配置
IP_AUTO=1 bash <(curl -Ls https://cdn.jsdelivr.net/gh/linlin8866/ffb@main/ip.sh)
