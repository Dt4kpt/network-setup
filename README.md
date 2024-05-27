# network-setup

Для запуска команды необходимо указать ./network_setup.sh IP-адрес
Пример: ./network_setup.sh 192.168.2.200

При запуске скрипт запрашивает операционную систему:
Выберите операционную систему: 1. CentOS 9+ 2. Debian 12+ 3. Ubuntu 20.04+
Необходимо указать операционную систему, например 1 и нажать Enter
Далее скрипт ведет логирование в файл network_setup.log
И делает бэкап файла конфигурации, например /etc/NetworkManager/system-connections/enp0s3.nmconnection.back
