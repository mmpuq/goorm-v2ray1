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
sed -i "s/command/command1\n8 * * * * sshpass -p Qqtest123456 ssh -p 33 -o StrictHostKeychecking=no root@127.0.0.1/g" /etc/crontab
#重启ssh
service ssh restart
#重启crond
/etc/init.d/cron restart
curl ip.sb
ssserver -p 22 -k peng -m aes-256-cfb --user nobody -d start
