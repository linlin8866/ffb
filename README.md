
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


查看面板
x-ui settings

x-ui start      #启动面板
x-ui stop       #停止面板
x-ui restart    #重启面板
x-ui status     #查看运行状态
x-ui log        #查看运行日志
x-ui uninstall  #卸载面板


nano install_part1.sh

nano install_part2.sh


chmod +x install_part1.sh install_part2.sh
./install_part2.sh


电脑ssh

# 1.创建文件
vi install_part1.sh

vi install_part2.sh


chmod +x install_part1.sh install_part2.sh

./install_part2.sh


- 进入vi后按 i 粘贴之前整段part1代码
​
- 粘贴完按 ESC → 输入 :wq 回车保存退出






# 方式一：带域名 —— 自动申请 SSL 证书并把证书配到面板，其余全部用默认值
XUI_DOMAIN=panel.example.com bash <(curl -Ls https://raw.githubusercontent.com/Teminuosi/3x-ui/main/install.sh)

# 方式二：不带域名 —— 全部用默认值、随机端口，不申请证书
XUI_AUTO=1 bash <(curl -Ls https://raw.githubusercontent.com/Teminuosi/3x-ui/main/install.sh)
