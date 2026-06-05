#!/bin/bash
#引入第一段所有函数
source ./install_part1.sh

install_x-ui() {
    cd ${xui_folder%/x-ui}/
    #=========唯一修改点：放弃github下载，使用本地/root/3xui.tar.gz，剩余全保留原代码=========
    local local_tar="/root/3xui.tar.gz"
    if [ ! -f "${local_tar}" ];then
        echo -e "${red}Local file /root/3xui.tar.gz not found！${plain}"
        exit 1
    fi
    cp "${local_tar}" "${xui_folder%/x-ui}/x-ui-linux-$(arch).tar.gz"
    #=====================================================================================
    if [ $# == 0 ]; then
        tag_version="local_package"
    else
        tag_version=$1
        tag_version_numeric=${tag_version#v}
        min_version="2.3.5"
        if [[ "$(printf '%s\n' "$min_version" "$tag_version_numeric" | sort -V | head -n1)" != "$min_version" ]]; then
            echo -e "${red}Please use a newer version (at least v2.3.5). Exiting installation.${plain}"
            exit 1
        fi
    fi

    #下载x-ui.sh保留原在线拉取不动
    curl -4fLRo /usr/bin/x-ui-temp https://raw.githubusercontent.com/Teminuosi/3x-ui/main/x-ui.sh
    if [[ $? -ne 0 ]]; then
        echo -e "${red}Failed to download x-ui.sh${plain}"
        exit 1
    fi
    # Stop x-ui service and remove old resources
    if [[ -e ${xui_folder}/ ]]; then
        if [[ $release == "alpine" ]]; then
            rc-service x-ui stop
        else
            systemctl stop x-ui
        fi
        rm ${xui_folder}/ -rf
    fi
    # Extract resources and set permissions
    tar zxvf x-ui-linux-$(arch).tar.gz
    rm x-ui-linux-$(arch).tar.gz -f
    cd x-ui
    chmod +x x-ui
    chmod +x x-ui.sh
    # Check the system's architecture and rename the file accordingly
    if [[ $(arch) == "armv5" || $(arch) == "armv6" || $(arch) == "armv7" ]]; then
        mv bin/xray-linux-$(arch) bin/xray-linux-arm
        chmod +x bin/xray-linux-arm
    fi
    chmod +x x-ui bin/xray-linux-$(arch)
    # Update x-ui cli and se set permission
    mv -f /usr/bin/x-ui-temp /usr/bin/x-ui
    chmod +x /usr/bin/x-ui
    mkdir -p /var/log/x-ui
    config_after_install
    # Etckeeper compatibility
    if [ -d "/etc/.git" ]; then
        if [ -f "/etc/.gitignore" ]; then
            if ! grep -q "x-ui/x-ui.db" "/etc/.gitignore"; then
                echo "" >> "/etc/.gitignore"
                echo "x-ui/x-ui.db" >> "/etc/.gitignore"
                echo -e "${green}Added x-ui.db to /etc/.gitignore for etckeeper${plain}"
            fi
        else
            echo "x-ui/x-ui.db" > "/etc/.gitignore"
            echo -e "${green}Created /etc/.gitignore and added x-ui.db for etckeeper${plain}"
        fi
    fi
    if [[ $release == "alpine" ]]; then
        curl -4fLRo /etc/init.d/x-ui https://raw.githubusercontent.com/Teminuosi/3x-ui/main/x-ui.rc
        if [[ $? -ne 0 ]]; then
            echo -e "${red}Failed to download x-ui.rc${plain}"
            exit 1
        fi
        chmod +x /etc/init.d/x-ui
        rc-update add x-ui
        rc-service x-ui start
    else
        # Install systemd service file
        service_installed=false
        if [ -f "x-ui.service" ]; then
            echo -e "${green}Found x-ui.service in extracted files, installing...${plain}"
            cp -f x-ui.service ${xui_service}/ > /dev/null 2>&1
            if [[ $? -eq 0 ]]; then
                service_installed=true
            fi
        fi
        if [ "$service_installed" = false ]; then
            case "${release}" in
            ubuntu | debian | armbian)
                if [ -f "x-ui.service.debian" ]; then
                    echo -e "${green}Found x-ui.service.debian in extracted files, installing...${plain}"
                    cp -f x-ui.service.debian ${xui_service}/x-ui.service > /dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        service_installed=true
                    fi
                fi
                ;;
            arch | manjaro | parch)
                if [ -f "x-ui.service.arch" ]; then
                    echo -e "${green}Found x-ui.service.arch in extracted files, installing...${plain}"
                    cp -f x-ui.service.arch ${xui_service}/x-ui.service > /dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        service_installed=true
                    fi
                fi
                ;;
            *)
                if [ -f "x-ui.service.rhel" ]; then
                    echo -e "${green}Found x-ui.service.rhel in extracted files, installing...${plain}"
                    cp -f x-ui.service.rhel ${xui_service}/x-ui.service > /dev/null 2>&1
                    if [[ $? -eq 0 ]]; then
                        service_installed=true
                    fi
                fi
                ;;
            esac
        fi
        # If service file not found in tar.gz, download from GitHub
        if [ "$service_installed" = false ]; then
            echo -e "${yellow}Service files not found in tar.gz, downloading from GitHub...${plain}"
            case "${release}" in
            ubuntu | debian | armbian)
                curl -4fLRo ${xui_service}/x-ui.service https://raw.githubusercontent.com/Teminuosi/3x-ui/main/x-ui.service.debian > /dev/null 2>&1
                ;;
            arch | manjaro | parch)
                curl -4fLRo ${xui_service}/x-ui.service https://raw.githubusercontent.com/Teminuosi/3x-ui/main/x-ui.service.arch > /dev/null 2>&1
                ;;
            *)
                curl -4fLRo ${xui_service}/x-ui.service https://raw.githubusercontent.com/Teminuosi/3x-ui/main/x-ui.service.rhel > /dev/null 2>&1
                ;;
            esac
            if [[ $? -ne 0 ]]; then
                echo -e "${red}Failed to install x-ui.service from GitHub${plain}"
                exit 1
            fi
            service_installed=true
        fi
        if [ "$service_installed" = true ]; then
            echo -e "${green}Setting up systemd unit...${plain}"
            chown root:root ${xui_service}/x-ui.service > /dev/null 2>&1
            chmod 644 ${xui_service}/x-ui.service > /dev/null 2>&1
            systemctl daemon-reload
            systemctl enable x-ui
            systemctl start x-ui
        else
            echo -e "${red}Failed to install x-ui.service file${plain}"
            exit 1
        fi
    fi
    echo -e "${green}x-ui ${tag_version}${plain} installation finished, it is running now..."
    echo -e ""
    echo -e "${yellow}Tip: run ${green}x-ui settings${plain}${yellow} on the server anytime to view the panel URL, username and password.${plain}"
    echo -e ""
    echo -e "┌───────────────────────────────────────────────────────┐ │ ${blue}x-ui control menu usages (subcommands):${plain} │ │ │ │ ${blue}x-ui${plain} - Admin Management Script │ │ ${blue}x-ui start${plain} - Start │ │ ${blue}x-ui stop${plain} - Stop │ │ ${blue}x-ui restart${plain} - Restart │ │ ${blue}x-ui status${plain} - Current Status │ │ ${blue}x-ui settings${plain} - Current Settings │ │ ${blue}x-ui enable${plain} - Enable Autostart on OS Startup │ │ ${blue}x-ui disable${plain} - Disable Autostart on OS Startup │ │ ${blue}x-ui log${plain} - Check logs │ │ ${blue}x-ui banlog${plain} - Check Fail2ban ban logs │ │ ${blue}x-ui update${plain} - Update │ │ ${blue}x-ui legacy${plain} - Legacy version │ │ ${blue}x-ui install${plain} - Install │ │ ${blue}x-ui uninstall${plain} - Uninstall │ └───────────────────────────────────────────────────────┘"
}

echo -e "${green}Running...${plain}"
install_base
install_x-ui $1
