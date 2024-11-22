#!/bin/bash
#全局变量
panel_path=/www/server/panel
#清理垃圾
cleaning_garbage(){
    rm -f /www/server/panel/*.pyc
    rm -f /www/server/panel/class/*.pyc
    python /www/server/panel/tools.py clear
    cat /dev/null > /var/log/boot.log
    cat /dev/null > /var/log/btmp
    cat /dev/null > /var/log/cron
    cat /dev/null > /var/log/dmesg
    cat /dev/null > /var/log/firewalld
    cat /dev/null > /var/log/grubby
    cat /dev/null > /var/log/lastlog
    cat /dev/null > /var/log/mail.info
    cat /dev/null > /var/log/maillog
    cat /dev/null > /var/log/messages
    cat /dev/null > /var/log/secure
    cat /dev/null > /var/log/spooler
    cat /dev/null > /var/log/syslog
    cat /dev/null > /var/log/tallylog
    cat /dev/null > /var/log/wpa_supplicant.log
    cat /dev/null > /var/log/wtmp
    cat /dev/null > /var/log/yum.log
    history -c
    back_home
}
#去除强制登陆
mandatory_landing(){
    rm -f /www/server/panel/data/bind.pl
    back_home
}
#修复环境
repair_environment(){
    yum -y install pcre pcre-devel
    yum -y install openssl openssl-devel
    yum -y install gcc-c++ autoconf automake
    yum install -y zlib-devel
    yum -y install libxml2 libxml2-dev
    yum -y install libxslt-devel
    yum -y install gd-devel
    yum -y install perl-devel perl-ExtUtils-Embed
    yum -y install GeoIP GeoIP-devel GeoIP-data
    yum install -y libxml2-devel
    yum install -y bzip2 bzip2-devel
    yum install -y libpng libpng-devel
    yum install -y libjpeg-deve
    yum install -y freetype freetype-devel
    yum install -y libmcrypt-devel
    yum install libcurl-devel libffi-devel zlib-devel bzip2-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel -y
    back_home
}
#清理残留
cleaning_residue(){
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    chattr -i /www/server/panel/class/panelAuth.py
    chattr -i /www/server/panel/class/panelPlugin.py
    chattr -i /etc/init.d/bt
    rm -f /etc/init.d/bt
    wget -O /etc/init.d/bt http://download.bt.cn/install/src/bt6.init -T 10
    chmod +x /etc/init.d/bt
    chattr -i /www/server/panel/data/plugin.json
    rm -f /www/server/panel/data/plugin.json
    wget -O /www/server/panel/data/plugin.json http://bt.cn/api/panel/get_soft_list_test -T 10
    chattr -i /www/server/panel/install/check.sh
    rm -f /www/server/panel/install/check.sh
    wget -O /www/server/panel/install/check.sh http://download.bt.cn/install/check.sh -T 10
    chattr -i /www/server/panel/install/public.sh
    rm -f /www/server/panel/install/public.sh
    wget -O /www/server/panel/install/public.sh http://download.bt.cn/install/public.sh -T 10
    rm -rf /www/server/panel/plugin/shoki_cdn
    rm -f /www/server/panel/data/home_host.pl
    rm -rf /www/server/panel/adminer
    rm -rf /www/server/adminer
    rm -rf /www/server/phpmyadmin/pma
    rm -f /www/server/panel/*.pyc
    rm -f /www/server/panel/class/*.pyc
    rm -f /dev/shm/session.db
    curl http://download.bt.cn/install/update_panel.sh|bash
    back_home
}
#停止服务
stop_btpanel(){
    /etc/init.d/bt stop
    /etc/init.d/nginx stop
    /etc/init.d/httpd stop
    /etc/init.d/mysqld stop
    /etc/init.d/pure-ftpd stop
    /etc/init.d/php-fpm-52 stop
    /etc/init.d/php-fpm-53 stop
    /etc/init.d/php-fpm-54 stop
    /etc/init.d/php-fpm-55 stop
    /etc/init.d/php-fpm-56 stop
    /etc/init.d/php-fpm-70 stop
    /etc/init.d/php-fpm-71 stop
    /etc/init.d/php-fpm-72 stop
    /etc/init.d/php-fpm-73 stop
    /etc/init.d/php-fpm-74 stop
    /etc/init.d/redis stop
    /etc/init.d/memcached stop
}
#卸载面板
uninstall_btpanel(){
    stop_btpanel
    chkconfig --del bt
    rm -f /etc/init.d/bt
    rm -rf /www
    rm -rf /tmp/*.sh
    rm -rf /tmp/*.sock
}
#宝塔面板
cp /www/server/panel/config/config.json /root/config.json
idc=''
IDC_CODE=$idc
python_bin=/www/server/panel/pyenv/bin/python
Setup_Count(){
	curl -sS --connect-timeout 10 -m 60 https://www.bt.cn/Api/SetupCount?type=Linux\&o=$idc > /dev/null 2>&1
	if [ "$idc" != "" ];then
		echo $idc > /www/server/panel/data/o.pl
		cd /www/server/panel
		$python_bin tools.py o
		python tools.py o
	fi
	echo /www > /var/bt_setupPath.conf
}
Setup_Count ${IDC_CODE}
cp /root/config.json /www/server/panel/config/config.json 
rm -f /root/config.json
#宝塔磁盘挂载
mount_disk(){
	echo -e "注意：本工具会将数据盘挂载到www目录。5秒后跳转到挂载脚本。"
    sleep 5s
	wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
	rm -rf /auto_disk.sh
    rm -rf auto_disk.sh
    back_home
}
#封装工具
package_btpanel(){
    clear
    python /www/server/panel/tools.py package
    back_home
}

#开启完全离线服务
open_offline(){
    rm -f $panel_path/data/home_host.pl
    echo 'True' >$panel_path/data/not_network.pl
    echo '[ "127.0.0.1" ]' >$panel_path/config/hosts.json
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+download.bt.cn//g' /etc/hosts
    echo '192.168.88.127 www.bt.cn' >>/etc/hosts
    echo '192.168.88.127 bt.cn' >>/etc/hosts
    echo '192.168.88.127 download.bt.cn' >>/etc/hosts
    back_home
}
#关闭完全离线服务
close_offline(){
    rm -f $panel_path/data/home_host.pl
    rm -f $panel_path/data/not_network.pl
    wget -O $panel_path/config/hosts.json https://down.gacjie.cn/BTPanel/Api/hosts.json
    sed -i 's/[0-9\.]\+[ ]\+www.bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+bt.cn//g' /etc/hosts
    sed -i 's/[0-9\.]\+[ ]\+download.bt.cn//g' /etc/hosts
    back_home
}
#服务器性能测试
vpsxn(){
wget -qO- git.io/superbench.sh | bash
back_home
}

#更新源到最新版
yum7(){
yum update
back_home
}

#centos6 yum源不可用问题解决
yum6(){
sed -i "s|enabled=1|enabled=0|g" /etc/yum/pluginconf.d/fastestmirror.conf
mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
curl -o /etc/yum.repos.d/CentOS-Base.repo https://gitee.com/LangKYa/lk/raw/shell/sh/CentOS6-Base-ustc.repo
yum clean all
yum makecache
back_home
}

#查看宝塔面板登录地址及账号密码
btdefault(){
bt default
back_home
}

#国内源
yumaliyun(){
 wget -O yum.sh https://gitee.com/LangKYa/lk/raw/shell/sh/yum.sh && bash yum.sh
 back_home
}

#dns
dns(){
echo -e "options timeout:1 attempts:1 rotate\nnameserver 8.8.8.8\nnameserver 223.5.5.5" >/etc/resolv.conf;
  cat /etc/resolv.conf
  back_home
}


#手动修改IP
ipset(){
	wkd=`ls /etc/sysconfig/network-scripts/ifcfg-e* | awk -F/ '{print $5}'`
	echo -e "\033[1;32m本机网卡文件：\033[0m" 
	n=1
	for x in $wkd 
	do 
		echo -e "\033[1;32m$n、$x\033[0m" 
		n=`expr $n + 1`
	done	
	echo -e "\033[1;31m$n、任意键返回主菜单\033[0m"
	read -p `echo -e "\033[1;32m请选择需要修改的网卡：\033[1;31m"` choose
	fname=`ls /etc/sysconfig/network-scripts/ifcfg-e* | awk -v vv=$choose -F/ '(NR==vv){print $5}'`
	if [ -z $fname ]
	then
		network
	fi
	file="/etc/sysconfig/network-scripts/$fname"
	while true
	do
	        read -p `echo -e "\033[1;32m请输入IP：\033[1;31m"` ip
	        echo $ip | egrep "^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\.){3}([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\b" &> /dev/null
	        if [ $? -eq 0 ]
	        then
	                break
	        else
	                echo -e "\033[1;31mIP格式错误，请重新输入！\033[0m"
	        fi
	done
	while true
	do
	        read -p `echo -e "\033[1;32m请输入掩码（直接回车输入默认值255.255.255.0）：\033[1;31m"` mask
	        if [ -z $mask ]
	        then
	                mask="255.255.255.0"
	                break
	        else
	                echo $mask | egrep "^255.255.255." &> /dev/null
	                if [ $? -eq 0 ]
	                then
	                        break
	                else
	                        echo -e "\033[1;31m掩码格式错误，请重新输入！\033[0m"
	               fi
	        fi
	done
	while true
	do
	        gateway=`echo $ip | awk -F. '{print $1"."$2"."$3".1"}'`
	        read -p `echo -e "\033[1;32m请输入网关（回车输入默认值$gateway）：\033[1;31m"` gatway
	        if [ -z $gateway ]
	        then
	                gateway=`echo $ip | awk -F. '{print $1"."$2"."$3".1"}'`
	                break
	        else
	                echo $gateway | egrep "^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\.){3}([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\b" &> /dev/null
	                if [ $? -eq 0 ]
	                then
	                        break
	                else
	                        echo -e "\033[1;31m网关格式错误，请重新输入！\033[0m"
	                fi
	        fi
	done
	while true
	do
	        read -p `echo -e "\033[1;32m请输入DNS1（回车输入默认值$gateway）：\033[1;31m"` dns
		echo -e "\033[0m"
	        if [ -z $dns ]
	        then
	                dns=$gateway
	                break
	        else
	                echo $dns | egrep "^(([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\.){3}([1-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-4])\b" &> /dev/null
	                if [ $? -eq 0 ]
	                then
	                        break
	                 else
	                        echo -e "\033[1;31mDNS格式错误，请重新输入！\033[0m"
	                fi
	        fi
	done
	sed -i 's/ONBOOT=no/ONBOOT=yes/g' $file &> /dev/null
	sed -i '/BOOTPROTO/d' $file &> /dev/null
	sed -i '$aBOOTPROTO=static' $file &> /dev/null
	sed -i '/IPADDR/d' $file &> /dev/null
	sed -i '$aIPADDR='$ip $file &> /dev/null
	sed -i '/NETMASK/d' $file &> /dev/null
	sed -i '$aNETMASK='$mask $file &> /dev/null
	sed -i '/GATEWAY/d' $file &> /dev/null
	sed -i '$aGATEWAY='$gateway $file &> /dev/null
	sed -i '/DNS/d' $file &> /dev/null
	sed -i '$aDNS1='$dns $file &> /dev/null
	echo -e "\033[1;32m配置文件修改完成，准备重启服务！\033[0m"
	service network restart
	echo -e "\033[1;31m配置完成返回上级菜单\033[0m"
	echo ""
	network
}

#格式化数据盘
format_disk(){
    stop_btpanel
    umount /dev/vdb
    mkfs.ext4 /dev/vdb
}



#返回首页
back_home(){
	read -p "请输入0返回首页:" function
	if [[ "${function}" == "0" ]]; then
	    clear
		main
	else
		clear
		exit 1
	fi
	
}
#centos宝塔安装
centosbt(){
    yum install -y wget && wget -O install.sh http://download.bt.cn/install/install_6.0.sh && sh install.sh 
    back_home
}
#ubantu宝塔安装
ubantubt(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh 
    back_home
}
#debian宝塔安装
debianbt(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && bash install.sh 
    back_home
}
#fedora宝塔安装
fedorabt(){
    wget -O install.sh http://download.bt.cn/install/install_6.0.sh && bash install.sh 
    back_home
}
#宝塔升级
updatabt(){
	wget -O update.sh http://download.bt.cn/install/update.sh && sh update.sh
	back_home
}
#centos宝塔官方挂载
centosgz(){
    yum install wget -y && wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
    back_home
}
#ubantu宝塔官方挂载
ubantugz(){
    wget -O install.sh http://download.bt.cn/install/install-ubuntu_6.0.sh && sudo bash install.sh
    back_home
}
#debian宝塔官方挂载
debiangz(){
    wget -O auto_disk.sh http://download.bt.cn/tools/auto_disk.sh && bash auto_disk.sh
    back_home
}
#debian宝塔魔改挂载
debianmggz(){
    wget -O auto_disk.sh https://www.hkgcloud.net/sh/auto_disk.sh && bash auto_disk.sh
    back_home
}
#ubuntu宝塔魔改挂载
ubantumggz(){
    wget -O auto_disk.sh https://www.hkgcloud.net/sh/auto_disk.sh && sudo bash auto_disk.sh
    back_home
}
#centos宝塔魔改挂载
centosmggz(){
    yum install wget -y && wget -O auto_disk.sh https://www.hkgcloud.net/sh/auto_disk.sh && bash auto_disk.sh
    back_home
}

#回程路由可视化
kshhc(){
    curl https://gitee.com/LangKYa/lk/raw/shell/sh/line_test.sh|bash
	back_home
}
#奈飞检测脚本
nfipjc(){
    wget -O nf https://cdn.jsdelivr.net/gh/vpsad/shell/server/nf && chmod +x nf && clear && ./nf
	back_home
}
#CentOS 优化脚本
init(){
    wget -O nf https://www.hkgcloud.net/sh/init.sh && chmod +x nf && clear && ./nf
	back_home
}
# 退出脚本
delete(){
    clear
    echo -e "感谢使用微微云-Linux工具箱"
    rm -rf /vps.sh
    rm -rf vps.sh
}
main(){
    clear
	echo -e "
|===================================================|
|  微微云：  \033[1;35mhttps://vvvps.cn\033[0m             |
|  脚本版本：   \033[1;32mvpsad_LinuxToolsV1.0.1\033[0m              |
|--------------------[官方宝塔]---------------------|
|(1)CentOS系统安装官方宝塔                          |
|(2)Ubuntu/Deepin系统安装官方宝塔                   |
|(3)Debian系统安装官方宝塔                          |
|(4)Fedora系统安装官方宝塔                          |
|(5)宝塔一键升级                                    |
|(6)Centos官方挂载数据盘工具                        |
|(7)Ubuntu官方挂载数据盘工具                        |
|(8)Debian官方挂载数据盘工具                        |
|(17)Centos挂载磁盘[支持自定义目录]                 |
|(18)Ubuntu挂载磁盘[支持自定义目录]                 |
|(19)Debian挂载磁盘[支持自定义目录]                 |
|--------------------[实用工具]---------------------|
|(23)清空数据盘[解决重装系统不清空数据盘,重装前使用]| 
|(26)centos6 yum源不可用问题解决                    |
|(27)查看宝塔面板登录地址及账号密码                 |
|(28)更换国内源,解决安装依赖插件缓慢                |
|(29)查看DNS及切换DNS为8.8.8.8                      |
|(30)手动配置修改IP地址(谨慎使用)                   |
|(31)CentOS服务器一键优化                           |
|(10)清理垃圾[清理系统以及面板产生的缓存垃圾]       |
|(11)登陆限制[去除宝塔linux面板强制登陆的限制]      |
|(12)修复环境[安装升级宝塔lnmp的环境只支持centos7]  |
|(13)清理残留[清理官方和破解版的文件残留并修复面板] |
|(14)卸载面板[本功能会清空所有数据卸载网站环境]     |
|(15)封装工具[高级功能不懂的不要执行以免数据丢失]   |
|(14)停止服务[停止面板LNMP,Redis,Memcached服务]     |
|--------------------[其他功能]---------------------|
|(22)性能测试(带宽,IO)    (0)退出脚本               |
|--------------------[广告赞助]---------------------|
|微微云=>香港美国优化回国CN2 GIA服务器=>          |
|官网地址：https://vvvps.cn                 |
|===================================================|
	"
	read -p "请输入需要输入的选项:" function
	case $function in
	1)  centosbt
    ;;
    2)  ubantubt
    ;;
    3)  debianbt
    ;;
    4)  fedorabt
    ;;
    5)  updatabt
    ;;
    6)  centosgz
    ;;
    7)  ubantugz
    ;;
    8)  debiangz
    ;;
    9)  package_btpanel
    ;;
	10) cleaning_garbage
    ;;
    11) mandatory_landing
    ;;
    12) repair_environment
    ;;
    13) cleaning_residue
    ;;
    14) uninstall_btpanel
    ;;
    15) package_btpanel
    ;;
    16) stop_btpanel
    ;;
    17) centosmggz
    ;;
	18) ubantumggz
    ;;
	19) debianmggz
    ;;
	20) open_offline
    ;;
	21) close_offline
    ;;
	22) vpsxn
    ;;	
	25) yum7
    ;;
	26) yum6
    ;;	
	27) btdefault
    ;;	
	28) yumaliyun
    ;;		
	29) dns
    ;;	
	30) ipset
    ;;	
    31) init
    ;;	
	23) format_disk
	;;
	kr) Setup_Count
	;;
	bbr) bbryj
	;;
	24) kshhc
	;;
	nf) nfipjc
	;;
	*)  delete
    ;;

    esac
}

main
