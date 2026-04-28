#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH

#=================================================
#	System Required: CentOS 6/7,Debian 8/9,Ubuntu 16+
#	Description: Sky Manager CLI
#	Version: 1.0.0
#	Author: Sky Manager Team
#=================================================

cli_ver="1.0.0"
github="raw.githubusercontent.com/pig0224/sky-manager/main"

Green_font_prefix="\033[32m" && Red_font_prefix="\033[31m" && Green_background_prefix="\033[42;37m" && Red_background_prefix="\033[41;37m" && Font_color_suffix="\033[0m"
Info="${Green_font_prefix}[Info]${Font_color_suffix}"
Error="${Red_font_prefix}[Error]${Font_color_suffix}"
Tip="${Green_font_prefix}[Warn]${Font_color_suffix}"

check_sys(){
	if [[ -f /etc/redhat-release ]]; then
		release="centos"
	elif cat /etc/issue | grep -q -E -i "debian"; then
		release="debian"
	elif cat /etc/issue | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /etc/issue | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
	elif cat /proc/version | grep -q -E -i "debian"; then
		release="debian"
	elif cat /proc/version | grep -q -E -i "ubuntu"; then
		release="ubuntu"
	elif cat /proc/version | grep -q -E -i "centos|red hat|redhat"; then
		release="centos"
    fi
}

check_version(){
	if [[ -s /etc/redhat-release ]]; then
		version=`grep -oE  "[0-9.]+" /etc/redhat-release | cut -d . -f 1`
	else
		version=`grep -oE  "[0-9.]+" /etc/issue | cut -d . -f 1`
	fi
	bit=`uname -m`
	if [[ ${bit} = "x86_64" ]]; then
		bit="x64"
	else
		bit="x32"
	fi
}

Update_CLI(){
	echo -e "Current CLI Version [ ${cli_ver} ], Updating..."
	cli_new_ver=$(wget --no-check-certificate -qO- "http://${github}/cli.sh"|grep 'cli_ver="'|awk -F "=" '{print $NF}'|sed 's/\"//g'|head -1)
	[[ -z ${cli_new_ver} ]] && echo -e "${Error} Failed to detect the latest version." && start_menu
	if [[ ${cli_new_ver} != ${cli_ver} ]]; then
		echo -e "Discover the new version [ ${cli_new_ver} ], Is it updated?[Y/n]"
		read -p "(default: y):" yn
		[[ -z "${yn}" ]] && yn="y"
		if [[ ${yn} == [Yy] ]]; then
			wget -N --no-check-certificate http://${github}/cli.sh && chmod +x cli.sh
			echo -e "Has been updated to the latest version [ ${cli_new_ver} ] !"
		else
			echo && echo "	Cancelled..." && echo
		fi
	else
		echo -e "This is the latest version at present. [ ${cli_new_ver} ] !"
		sleep 5s
	fi
	read -n 1 -p "Press any key back to menu..."
	start_menu
}

remove_all(){
	sed -i '/net.core.default_qdisc/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_congestion_control/d' /etc/sysctl.conf
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_default/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_recycle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_keepalive_time/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_mtu_probing/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syncookies/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_fin_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.route.gc_timeout/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_synack_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_syn_retries/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_timestamps/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_orphans/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	clear
	echo -e "${Info}: Clear BBR and system optimization settings successfully!"
	sleep 1s
}

Enabled_BBR(){
	remove_all
	if [[ `echo ${kernel_version} | awk -F'.' '{print $1}'` -ge "5" ]]; then
		echo "net.core.default_qdisc=cake" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	else
		echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
		echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
	fi
	sysctl -p
	echo -e "${Info} BBR Started Successfully"
	read -n 1 -p "Press any key back to menu..."
	start_menu
}

System_Optimization(){
	sed -i '/fs.file-max/d' /etc/sysctl.conf
	sed -i '/fs.inotify.max_user_instances/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_tw_reuse/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_local_port_range/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_rmem/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_wmem/d' /etc/sysctl.conf
	sed -i '/net.core.somaxconn/d' /etc/sysctl.conf
	sed -i '/net.core.rmem_max/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_max/d' /etc/sysctl.conf
	sed -i '/net.core.wmem_default/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_tw_buckets/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_max_syn_backlog/d' /etc/sysctl.conf
	sed -i '/net.core.netdev_max_backlog/d' /etc/sysctl.conf
	sed -i '/net.ipv4.tcp_slow_start_after_idle/d' /etc/sysctl.conf
	sed -i '/net.ipv4.ip_forward/d' /etc/sysctl.conf
	echo "fs.file-max = 1000000
fs.inotify.max_user_instances = 8192
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65535
net.ipv4.tcp_rmem = 16384 262144 8388608
net.ipv4.tcp_wmem = 32768 524288 16777216
net.core.somaxconn = 8192
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216
net.core.wmem_default = 2097152
net.ipv4.tcp_max_tw_buckets = 5000
net.ipv4.tcp_max_syn_backlog = 10240
net.core.netdev_max_backlog = 10240
net.ipv4.tcp_slow_start_after_idle = 0
# forward ipv4
net.ipv4.ip_forward = 1">>/etc/sysctl.conf
	sysctl -p
	echo "*               soft    nofile           1000000
*               hard    nofile          1000000">/etc/security/limits.conf
	echo "ulimit -SHn 1000000">>/etc/profile
	read -p "After restarting the VPS, the system optimization settings will take effect. Should we restart now? [Y/n] :" yn
	[ -z "${yn}" ] && yn="y"
	if [[ $yn == [Yy] ]]; then
		echo -e "${Info} VPS Restarting..."
		reboot
	else
    read -n 1 -p "Press any key back to menu..."
    start_menu
	fi
}

NODE_VERSION="v20.11.1"
NODE_DIR="/opt/node-${NODE_VERSION}-linux-x64"
NODE_FILE="node-${NODE_VERSION}-linux-x64.tar.xz"
NODE_URL="https://nodejs.org/dist/${NODE_VERSION}/${NODE_FILE}"

Install_Manager(){
	echo "===================================================="  
	echo "========= Start installing the Sky Manager ========="
	echo "===================================================="

	export PATH=${NODE_DIR}/bin:$PATH

	if command -v sky &>/dev/null; then
		echo "Complated, Sky Manager is installed."
		read -n 1 -p "Press any key back to menu..."
		start_menu
		return 0
	fi

	if command -v node &> /dev/null && [ -d "${NODE_DIR}" ]; then
		node --version
		npm --version
	else
		wget -q --show-progress "${NODE_URL}" -O "${NODE_FILE}"
		if [ $? -ne 0 ]; then
			echo "Download failed. Please check your network."
			read -n 1 -p "Press any key back to menu..."
			start_menu
			return 1
		fi

		echo "The files are being decompressed to /opt..."
		tar -xJvf "${NODE_FILE}" -C /opt >/dev/null 2>&1
		if [ $? -ne 0 ]; then
			echo "Decompression failed, please check the integrity of the downloaded file."
			read -n 1 -p "Press any key back to menu..."
			start_menu
			return 1
		fi

		ln -sf /opt/node-v20.11.1-linux-x64/bin/node /usr/local/bin/
		ln -sf /opt/node-v20.11.1-linux-x64/bin/npm /usr/local/bin/

		node --version
		npm --version
	fi

	npm install -g sky-manager
	if [ $? -eq 0 ]; then
		ln -sf /opt/node-v20.11.1-linux-x64/bin/sky /usr/local/bin/
		echo "Sky Manager Installed successfully"
	else
		echo "Sky Manager Installation failed, please check the error message above."
		read -n 1 -p "Press any key back to menu..."
		start_menu
		return 1
	fi

	rm -f "${NODE_FILE}"

	if command -v sky &>/dev/null; then
		local status=$(sky status 2>/dev/null)
		if [[ "${status}" =~ "online" ]]; then
		sky restart
		else
		sky start
		fi
	fi

	echo -e "\n Complated"
	read -n 1 -p "Press any key back to menu..."
	start_menu
}

Uninstall_Manager(){
	echo "=================================================="
	echo "========= Start uninstalling Sky Manager ========="
	echo "=================================================="

	export PATH=${NODE_DIR}/bin:$PATH

	if command -v sky &>/dev/null; then
		local status=$(sky status 2>/dev/null)
		if [[ "${status}" =~ "online" ]]; then
			sky stop
			pkill -f "manager" 2>/dev/null
			killall -9 manager 2>/dev/null
		fi
	fi

	if [ ! -d "${NODE_DIR}" ] && ! command -v node &>/dev/null; then
		echo "Complated, Sky Manager is not installed."
		read -n 1 -p "Press any key back to menu..."
		start_menu
		return 0
	fi

	pkill -f "node" 2>/dev/null
	killall -9 node 2>/dev/null

	npm uninstall -g sky-manager >/dev/null 2>&1

	rm -f /usr/local/bin/sky
	rm -f /usr/local/bin/node
	rm -f /usr/local/bin/npm
	rm -rf "${NODE_DIR}"

	echo "Complated, Sky Manager has been uninstalled."
	read -n 1 -p "Press any key back to menu..."
	start_menu
}

Start_Manager(){
	echo "====================================="
	echo "========= Start Sky Manager ========="
	echo "====================================="

	export PATH=${NODE_DIR}/bin:$PATH

	if ! command -v sky &>/dev/null; then
		echo "Sky Manager has not been installed. Please Install Manager."
		read -n 1 -p "Press any key back to menu..."
		start_menu
		return 1
	fi

	local status=$(sky status 2>/dev/null)
	if [[ ! "${status}" =~ "online" ]]; then
		sky start
	else
		echo -e "${Tip} Sky Manager is already running"
	fi

	read -n 1 -p "Press any key back to menu..."
	start_menu
}

Stop_Manager(){
	echo "===================================="
	echo "========= Stop Sky Manager ========="
	echo "===================================="

	export PATH=${NODE_DIR}/bin:$PATH
	
	if ! command -v sky &>/dev/null; then
		echo "Sky Manager has not been installed. Please Install Manager."
		read -n 1 -p "Press any key back to menu..."
		start_menu
		return 1
	fi

	local status=$(sky status 2>/dev/null)
	if [[ "${status}" =~ "online" ]]; then
		sky stop
		pkill -f "manager" 2>/dev/null
		killall -9 manager 2>/dev/null
	else
		echo -e "${Tip} Sky Manager is not running"
	fi

	read -n 1 -p "Press any key back to menu..."
	start_menu
}

start_menu(){
clear
echo && echo -e "Sky Manager CLI ${Red_font_prefix}[v${cli_ver}]${Font_color_suffix}

${Green_font_prefix}0.${Font_color_suffix} Update CLI
${Green_font_prefix}1.${Font_color_suffix} Install Manager
${Green_font_prefix}2.${Font_color_suffix} Uninstall Manager
${Green_font_prefix}3.${Font_color_suffix} Start Manager
${Green_font_prefix}4.${Font_color_suffix} Stop Manager
————————————Other Utils————————————
${Green_font_prefix}5.${Font_color_suffix} Enabled BBR
${Green_font_prefix}6.${Font_color_suffix} System Optimization
${Green_font_prefix}7.${Font_color_suffix} Exit
————————————————————————————————" && echo

	# check_manager_version
	# if [[ ${manager_version} == "noinstall" ]]; then
	# 	echo -e " Status: ${Green_font_prefix}Not installed${Font_color_suffix} Sky Manager ${Red_font_prefix} Please install. ${Font_color_suffix}"
	# else
	# 	echo -e " Status: ${Red_font_prefix} ${manager_version} ${Font_color_suffix}"
		
	# fi
echo
read -p "Entry Number [0-11]:" num
case "$num" in
	0)
	Update_CLI
	;;
	1)
	Install_Manager
	;;
	2)
	Uninstall_Manager
	;;
	3)
	Start_Manager
	;;
	4)
	Stop_Manager
	;;
	5)
	Enabled_BBR
	;;
	6)
	System_Optimization
	;;
	7)
	exit 1
	;;
	*)
	clear
	echo -e "${Error}: Please enter the correct number. [0-11]"
	sleep 2s
	start_menu
	;;
esac
}

check_sys
check_version
[[ ${release} != "debian" ]] && [[ ${release} != "ubuntu" ]] && [[ ${release} != "centos" ]] && echo -e "${Error} not support with the current system ${release} !" && exit 1
start_menu
