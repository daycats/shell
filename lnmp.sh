rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

# mysql install
rpm -qa | grep -i libs | grep -i mysql
rpm -e mysql-libs  --nodeps
yum install -y mysql55w mysql55w-server

# php install
yum -y install php56w-cli php56w-devel php56w-fpm php56w-gd php56w-mysql php56w-mbstring php56w-pdo php56w-tidy php56w-xml

# nginx install
echo "[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/\$releasever/\$basearch/
gpgcheck=0
enabled=1" > /etc/yum.repos.d/nginx.repo
yum -y install nginx

# start service
service mysqld start
service php-fpm start
service nginx start

# auto startup
chkconfig mysqld on
chkconfig php-fpm on
chkconfig nginx on

groupadd www
useradd www -g www
mkdir /data/wwwroot -p && mkdir /data/session
chown www.www /data/wwwroot /data/session

# 用www用户和www用户组启动服务
sed -i "s/user = apache/user = www/g" /etc/php-fpm.d/www.conf
sed -i "s/group = apache/group = www/g" /etc/php-fpm.d/www.conf
sed -i "s/\/var\/lib\/php\/session/\/data\/session/g" /etc/php-fpm.d/www.conf
service nginx restart
service php-fpm restart
