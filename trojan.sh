#!sh

rm -f $0

clear
echo "+------------------------------------------------------------------------+"
echo "|                            Trojan                                      |"
echo "+------------------------------------------------------------------------+"
echo "|        A tool to auto-compile & install Trojan on Alpine               |"
echo "+------------------------------------------------------------------------+"
echo "|               Welcome to  https://github.com/msl4437                   |"
echo "+------------------------------------------------------------------------+"

echo -n "  请输入数据库密码："
read MySQLPass
if [ -z $MySQLPass ]
    then
        echo -n "  密码不能为空，请重新输入："
        read MySQLPass
fi

echo -n "  请输入域名："
read DOMAIN
if [ -z $DOMAIN ]
    then
        echo -n "  域名不能为空，请重新输入："
        read DOMAIN
fi 

if ! wget --no-check-certificate https://github.com/msl4437/trojan/releases/download/1.16.0/trojan -O /usr/local/bin/trojan ; then
    echo "Failed to download Trojan file!"
    exit 1
fi
chmod +x /usr/local/bin/trojan
if ! wget --no-check-certificate https://github.com/msl4437/trojan/releases/download/1.16.0/trojan.json -O /usr/local/trojan.json ; then
    echo "Failed to download Trojan.json file!"
    exit 1
fi

apk add mysql mysql-client openssl
sed -i "s/skip-networking/user=mysql/g" /etc/my.cnf.d/mariadb-server.cnf
mysql_install_db --datadir=/var/lib/mysql
mysqld_safe --nowatch --datadir=/var/lib/mysql
sleep 5

mysqladmin -u root password "$MySQLPass"
mysql -u root -p$MySQLPass -e"GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MySQLPass' WITH GRANT OPTION;"
mysql -u root -p$MySQLPass -e"FLUSH PRIVILEGES;"
mysql -u root -p$MySQLPass -e"CREATE DATABASE IF NOT EXISTS trojan CHARACTER SET 'utf8' COLLATE 'utf8_general_ci';"
mysql -u root -p$MySQLPass -e"CREATE TABLE users (id INT UNSIGNED NOT NULL AUTO_INCREMENT, username VARCHAR(64) NOT NULL, password CHAR(56) NOT NULL, active varchar(64) NOT NULL DEFAULT 0, address text NOT NULL DEFAULT 0, quota BIGINT NOT NULL DEFAULT -1, download BIGINT UNSIGNED NOT NULL DEFAULT 0, upload BIGINT UNSIGNED NOT NULL DEFAULT 0, PRIMARY KEY (id), INDEX (password));"

sed -i "s/{DOMAIN}/$DOMAIN/g" /usr/local/trojan.json
sed -i "s/{MySQLPass}/$MySQLPass/g" /usr/local/trojan.json

openssl req -new -newkey rsa:2048 -nodes -keyout /usr/local/$DOMAIN.key -out /usr/local/$DOMAIN.csr -subj "/C=CN/ST=BeiJing/L=BeiJing/O=Trojan/CN=$DOMAIN"
openssl req -sha256 -new -x509 -days 36500 -key /usr/local/$DOMAIN.key -out /usr/local/$DOMAIN.crt -subj "/C=CN/ST=BeiJing/L=BeiJing/O=Trojan/CN=$DOMAIN"

/usr/local/bin/trojan &
