#!/bin/bash
pathCentOS="/etc/NetworkManager/system-connections/enp0s3.nmconnection"
pathDebian="/etc/network/interfaces"
pathUbuntu="/etc/netplan/00-installer-config.yaml"
log="network_setup.log"
current_ip="$(hostname -I | cut -d' ' -f1 | xargs)"
new_ip=$1

if [ "$EUID" -ne 0 ]
  then echo "Запустите команду от пользователя root" | tee -a $log
  exit
fi

echo "Выберите операционную систему: 1. CentOS 9+ 2. Debian 12+ 3. Ubuntu 20.04+"
read osVer

echo "Текущий IP-адрес: $current_ip" | tee -a $log
echo "Новый IP-адрес: $new_ip" | tee -a $log

echo ""
echo "Запускаем процесс смены IP-адреса" | tee -a $log

case $osVer in
1)
echo "Создание резервной копии $pathCentOS.back" | tee -a $log
cp $pathCentOS $pathCentOS.back

echo "$pathCentOS редактируем конфигурационный файл..." | tee -a $log
sed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ $pathCentOS
echo "$pathCentOS файл конфигурации изменен." | tee -a $log

for i in $(ls /sys/class/net/) ; do
    ip addr flush $i &
done

echo "Перезапускаем сервис сети..." | tee -a $log
systemctl restart NetworkManager.service
echo "Сервис сети перезапущен." | tee -a $log
echo "IP-адрес ($current_ip) успешно изменен на новый ($new_ip)." | tee -a $log
;;
2)
echo "Создание резервной копии $pathDebian.back" | tee -a $log
cp $pathDebian $pathDebian.back

echo "$pathDebian редактируем конфигурационный файл..." | tee -a $log
sed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ $pathDebian
echo "$pathDebian файл конфигурации изменен." | tee -a $log

for i in $(ls /sys/class/net/) ; do
    ip addr flush $i &
done

echo "Перезапускаем сервис сети..."
systemctl restart networking
echo "Сервис сети перезапущен." | tee -a $log
echo "IP-адрес ($current_ip) успешно изменен на новый ($new_ip)." | tee -a $log
;;
3)
echo "Создание резервной копии $pathUbuntu.back" | tee -a $log
cp $pathUbuntu $pathUbuntu.back

echo "$pathUbuntu редактируем конфигурационный файл..." | tee -a $log
sed -i -r 's/(\b[0-9]{1,3}\.){3}[0-9]{1,3}\b'/"$new_ip"/ $pathUbuntu
echo "$pathUbuntu файл конфигурации изменен." | tee -a $log

for i in $(ls /sys/class/net/) ; do
    ip addr flush $i &
done

echo "Перезапускаем сервис сети..." | tee -a $log
netplan generate
netplan apply
echo "Сервис сети перезапущен." | tee -a $log
echo "IP-адрес ($current_ip) успешно изменен на новый ($new_ip)." | tee -a $log
;;

*)
echo "Неправильно указан номер операционной системы, необходимо напечатать одну из цифр 1 2 3" | tee -a $log
;;
esac