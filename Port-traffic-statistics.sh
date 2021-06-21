#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH



addport(){
read -p "输入要添加的端口： " port
iptables -I INPUT -p tcp --dport $port
iptables -I INPUT -p udp --dport $port
iptables -I OUTPUT -p tcp --sport $port
iptables -I OUTPUT -p udp --sport $port
}

Checkthetraffic(){
iptables -n -v -t filter -L INPUT > /root/flow1.txt
iptables -n -v -t filter -L OUTPUT > /root/flow2.txt
awk '{print $NF}' /root/flow1.txt > /root/flow3.txt
sed 's/dpt:\(.*\)/\1/g' /root/flow3.txt > /root/flow4.txt
sed -i '/^b.*/d' /root/flow4.txt
sed -i '/^d.*/d' /root/flow4.txt
sed -n '{n;p}' /root/flow4.txt  > /root/flow5.txt
awk '{print $2}' /root/flow1.txt > /root/flow6.txt
sed -i '/^b.*/d' /root/flow6.txt
sed -i '/^I.*/d' /root/flow6.txt
sed -n '{n;p}' /root/flow6.txt  > /root/flow7.txt
awk '{print $2}' /root/flow2.txt > /root/flow8.txt
sed -i '/^O.*/d' /root/flow8.txt
sed -i '/^b.*/d' /root/flow8.txt
sed -n '{n;p}' /root/flow8.txt  > /root/flow9.txt
echo -e "\\033[33m‖\t序号\t‖\t端口号\t‖\t入站流量\t‖\t出站流量\033[0m\t‖"
  count_line=$(awk 'END{print NR}' /root/flow5.txt)
  for ((i = 1; i <= $count_line; i++)); do
    a=$(sed -n "${i}p" /root/flow5.txt)
    b=$(sed -n "${i}p" /root/flow7.txt)
    c=$(sed -n "${i}p" /root/flow9.txt)    
     echo -e "\\033[30m‖\t$i\t‖\t$a\t‖\t$b\t\t‖\t$c\\033[30m\t\t‖"
      done
rm -f /root/flow*
}

Clear(){
iptables -Z
}

delete(){
read -p "输入要删除的端口： " port
iptables -D INPUT -p tcp --dport $port
iptables -D INPUT -p udp --dport $port
iptables -D OUTPUT -p tcp --sport $port
iptables -D OUTPUT -p udp --sport $port
}

start_menu(){
echo -e "
‖   1.    添加端口          ‖   
‖   2.  查看端口流量统计    ‖
‖   3.  清除端口流量统计    ‖
‖   4.    删除端口          ‖"

read -p "请输入数字后[0-10]按回车键:
" num
case "$num" in
	1)
	addport
	;;
	2)
	Checkthetraffic
	;;
	3)
	clear
	;;
	4)
	delete
	;;	
	*)	
	echo -e "${Error}:请输入正确数字[0-1]按回车键"
	sleep 2s
	start_menu
	;;
esac
	}
start_menu
