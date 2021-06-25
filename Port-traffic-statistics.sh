#!/usr/bin/env bash
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH



addport(){
read -p "输入要添加的端口(多个端口请用空格隔开，如：111 222 333)：" ports
overp=$ports
for ports in ${ports[@]};
do
iptables -I INPUT -p tcp --dport $ports
iptables -I INPUT -p udp --dport $ports
iptables -I OUTPUT -p tcp --sport $ports
iptables -I OUTPUT -p udp --sport $ports
done
echo -e "\033[32m添加完成，所添加端口为：\033[0m $overp"
sleep 3s
start_menu
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
  count_line=$(awk 'END{print NR}' /root/flow5.txt)
    echo -e "\033[33m‖\t序号\t‖\t端口号\t‖\t入站流量\t‖\t出站流量\033[0m\t‖"
  for ((i = 1; i <= $count_line; i++)); do
    a=$(sed -n "${i}p" /root/flow5.txt)
    b=$(sed -n "${i}p" /root/flow7.txt)
    c=$(sed -n "${i}p" /root/flow9.txt)    
    echo -e "\033[31m‖\t$i\t‖\t$a\t‖\t$b\t\t‖\t$c\\033[0m\t\t‖"
           done
rm -f /root/flow*
}

Clear(){
iptables -Z
echo -e "\033[32m清空完成！\033[0m"
}

delete(){
read -p "输入要删除的端口(多个端口请用空格隔开)： " ports
overp=$ports
for ports in ${ports[@]};
do
iptables -D INPUT -p tcp --dport $ports
iptables -D INPUT -p udp --dport $ports
iptables -D OUTPUT -p tcp --sport $ports
iptables -D OUTPUT -p udp --sport $ports
done
echo -e "\033[32m删除完成，所删除端口为：\033[0m $overp"
sleep 3s
start_menu
}

realtime(){
read -p "请输入要查看端口流量统计的时间，单位为秒： " s1
for ((s =1 ; s <= s1 ; s++));do
sleep 1s
clear
Checkthetraffic
done
}

start_menu(){
echo -e "\033[32m#############################################################\033[0m"
echo -e "\033[32m#             端口流量统计一键脚本  By：Seal0207            #\033[0m"
echo -e "\033[32m#             此脚本采用iptables对端口流量进行统计          #\033[0m"
echo -e "\033[32m#             专为懒人小白打造,使用便捷,操作明了~           #\033[0m"
echo -e "\033[32m#############################################################\033[0m"
echo -e
echo -e "‖            \033[33m菜单\033[0m           ‖
‖   1.  添加端口            ‖   
‖   2.  查看端口流量统计    ‖
‖   3.  清除端口流量统计    ‖
‖   4.  删除端口            ‖
‖   5.  动态查看端口流量    ‖"

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
	Clear
	;;
	4)
	delete
	;;
	5)
	realtime
	;;
	*)	
	echo -e "${Error}:请输入正确数字[0-1]按回车键"
	sleep 2s
	start_menu
	;;
esac
	}
start_menu
