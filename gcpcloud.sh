#!/bin/bash
apt-get -y update
apt install sshpass -y
apt install python-pip -y
pip install git+https://github.com/shadowsocks/shadowsocks.git@master
#同步系统时间
cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
sed -i "s/Port 22/Port 33/g" /etc/ssh/sshd_config
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/KeyRegenerationInterval/#KeyRegenerationInterval/g" /etc/ssh/sshd_config
sed -i "s/ServerKeyBits/#ServerKeyBits/g" /etc/ssh/sshd_config
sed -i "s/RSAAuthentication yes/#RSAAuthentication yes/g" /etc/ssh/sshd_config
sed -i "s/RhostsRSAAuthentication no/#RhostsRSAAuthentication no/g" /etc/ssh/sshd_config
echo root:Qqtest123456 |chpasswd
#测试添加定时任务唤醒
rm -f /etc/crontab
wget -P /etc https://github.com/byxiaopeng/goorm-v2ray/raw/master/crontab

#开启BBR
echo "net.core.default_qdisc=fq" >> /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" >> /etc/sysctl.conf
sysctl -p
#重启ssh
service ssh restart
#重启crond
/etc/init.d/cron restart
curl ip.sb
ssserver -p 22 -k peng -m aes-256-cfb --user nobody -d start
