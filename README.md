
curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part1.sh
curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh
chmod +x install_part1.sh install_part2.sh
./install_part2.sh


curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part1.sh
curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh
chmod +x install_part*.sh
./install_part2.sh


curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part1.sh
curl -O https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh
chmod +x install_part*.sh
./install_part2.sh


XUI_DOMAIN=你的域名.com bash <(curl -Ls https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh)


XUI_AUTO=1 bash <(curl -Ls https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh)


#1、带域名自动SSL安装
XUI_DOMAIN=你的域名.com bash <(curl -Ls https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh)

#2、全自动静默安装（随机端口、跳过SSL）
XUI_AUTO=1 bash <(curl -Ls https://raw.githubusercontent.com/linlin8866/ffb/main/install_part2.sh)


