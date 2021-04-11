#!/bin/bash
# Project starting bash script for WSL native LEMP by rolle.
# More info: https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development

# Helpers:
currentfile=`basename $0`
txtbold=$(tput bold)
boldyellow=${txtbold}$(tput setaf 3)
boldgreen=${txtbold}$(tput setaf 2)
boldwhite=${txtbold}$(tput setaf 7)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
green=$(tput setaf 2)
white=$(tput setaf 7)
txtreset=$(tput sgr0)
LOCAL_IP=$(ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1")
YEAR=$(date +%y)
PROJECTS_HOME='/var/www'

if [ ! -f ~/.env ]; then
  echo "${boldyellow}What is your MySQL root password (asked only first time):${txtreset} "
  read -e MYSQL_ROOT_PASSWORD

  echo "${boldyellow}What is the admin user you want to login to wp-admin by default (asked only first time):${txtreset} "
  read -e WP_ADMIN_USER

  echo "${boldyellow}What is the password you want to use with your wp-admin admin user by default (asked only first time):${txtreset} "
  read -e WP_ADMIN_USER_PASSWORD

  echo "${boldyellow}What is the email address you want to use with your wp-admin admin user by default (asked only first time):${txtreset} "
  read -e WP_ADMIN_USER_EMAIL
fi

touch ~/.env
echo -e "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}" >> ~/.env
echo -e "WP_ADMIN_USER=${WP_ADMIN_USER}" >> ~/.env
echo -e "WP_ADMIN_USER_PASSWORD=${WP_ADMIN_USER_PASSWORD}" >> ~/.env
echo -e "WP_ADMIN_USER_EMAIL=${WP_ADMIN_USER_EMAIL}" >> ~/.env

MYSQL_ROOT_PASSWORD_ENV=$(grep MYSQL_ROOT_PASSWORD ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_ENV=$(grep WP_ADMIN_USER ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_PASSWORD_ENV=$(grep WP_ADMIN_USER_PASSWORD ~/.env | cut -d '=' -f2)
WP_ADMIN_USER_EMAIL_ENV=$(grep WP_ADMIN_USER_EMAIL ~/.env | cut -d '=' -f2)

echo "${boldyellow}Project name in lowercase (without spaces or special characters):${txtreset} "
read -e PROJECTNAME
cd $PROJECTS_HOME/dudestack
echo "${yellow}Ensuring git is installed...${txtreset}"
if [ ! -f /usr/bin/git ]; then
  echo "${yellow}Installing git${txtreset}"
  sudo apt install git -y
fi
git pull
echo "${yellow}Ensuring composer is installed...${txtreset}"
if [ ! -f /usr/local/bin/composer ]; then
  echo "${yellow}Installing composer${txtreset}"
  cd /tmp
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
  php composer-setup.php
  php -r "unlink('composer-setup.php');"
  sudo mv composer.phar /usr/local/bin/composer
  sudo chmod +x /usr/local/bin/composer
fi
composer create-project -n ronilaukkarinen/dudestack $PROJECTS_HOME/${PROJECTNAME} dev-master
cd $PROJECTS_HOME/${PROJECTNAME}
composer update
echo "${yellow}Creating a MySQL database for ${PROJECTNAME}${txtreset}"
mysql -u root -p${MYSQL_ROOT_PASSWORD_ENV} -e "CREATE DATABASE ${PROJECTNAME}"
echo "${boldgreen}Attempt to create MySQL database successful.${txtreset}"

cd "$PROJECTS_HOME/$PROJECTNAME/"
echo "${yellow}Updating WordPress related stuff...:${txtreset}"
cp $PROJECTS_HOME/dudestack/composer.json "$PROJECTS_HOME/$PROJECTNAME/composer.json"
cd "$PROJECTS_HOME/$PROJECTNAME/"

# Clean ups
rm README.md
rm LICENSE
rm -rf .git
rm .travis.yml
rm -rf bin
rm .env.example
rm phpcs.xml

composer update
echo "${yellow}Updating .env (db credentials)...:${txtreset}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/root/g" .env
sed -i -e "s/database_password/${MYSQL_ROOT_PASSWORD_ENV}/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/http/https/g" .env
# echo '
# SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE' >> .env
# echo -e '
# IMAGIFY_API_KEY=YOUR_IMAGIFY_API_KEY_HERE' >> .env
# echo -e '
# HS_BEACON_ID=YOUR_HS_BEACON_ID_HERE' >> .env

echo "${yellow}Installing WordPress...:${txtreset}"
echo "path: wp
url: https://${PROJECTNAME}.test

core install:
  admin_user: ${WP_ADMIN_USER_ENV}
  admin_password: ${WP_ADMIN_USER_PASSWORD_ENV}
  admin_email: ${WP_ADMIN_USER_EMAIL_ENV}
  title: \"${PROJECTNAME}\"" > wp-cli.yml

cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp core install --title=$PROJECTNAME --admin_email=${WP_ADMIN_USER_EMAIL_ENV}
echo "${yellow}Removing default WordPress posts...:${txtreset}"
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 1 --force
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 2 --force
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update blogdescription ''
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update WPLANG 'fi'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update current_theme '$PROJECTNAME'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentytwelve
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentythirteen
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update permalink_structure '/%postname%'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update timezone_string 'Europe/Helsinki'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_pingback_flag '0'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_ping_status 'closed'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_comment_status 'closed'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update date_format 'j.n.Y'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update time_format 'H.i'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update admin_email 'koodarit@dude.fi'
cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option delete new_admin_email

echo "${yellow}Setting file permissions for local dev server...${txtreset}"
sudo chmod -R 777 $PROJECTS_HOME/$PROJECTNAME
$PROJECTS_HOME/$PROJECTNAME
git config core.fileMode false

echo "${yellow}Ensuring mkcert is installed...${txtreset}"
cd "$PROJECTS_HOME/$PROJECTNAME/"
if [ ! -f /usr/local/bin/mkcert ]; then
  echo "${yellow}Installing mkcert${txtreset}"
  sudo apt update
  sudo apt install linuxbrew-wrapper -y
  brew update
  brew install mkcert

  # Just to make sure it's installed:
  brew install mkcert

  # Link
  sudo ln -s /home/linuxbrew/.linuxbrew/bin/mkcert /usr/local/bin/mkcert
  sudo chmod +x /usr/local/bin/mkcert
fi

echo "${yellow}Ensuring dhparam is generated...${txtreset}"
if [ ! -f /etc/ssl/certs/dhparam.pem ]; then
  echo "${yellow}Generating dhparam${txtreset}"
  sudo mkdir -p /etc/ssl/certs
  cd /etc/ssl/certs
  sudo openssl dhparam -out dhparam.pem 4096
fi

echo "${yellow}Generating HTTPS cert for project...${txtreset}"
mkdir -p /var/www/certs && cd /var/www/certs && mkcert "$PROJECTNAME.test"

echo "${yellow}Ensuring browsersync certs are is installed...${txtreset}"
if [ ! -f /var/www/certs/localhost-key.pem ]; then
  mkdir -p /var/www/certs && cd /var/www/certs && mkcert localhost
fi

echo "server {
    listen 443 ssl http2;
    root /var/www/$PROJECTNAME;
    index index.php;
    server_name $PROJECTNAME.test www.$PROJECTNAME.test;

    include php7.conf;
    include global/wordpress.conf;

    ssl_certificate /var/www/certs/$PROJECTNAME.test.pem;
    ssl_certificate_key /var/www/certs/$PROJECTNAME.test-key.pem;
    ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
    ssl_prefer_server_ciphers on;
    ssl_dhparam /etc/ssl/certs/dhparam.pem;
    ssl_ciphers 'ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-AES256-GCM-SHA384:DHE-RSA-AES128-GCM-SHA256:DHE-DSS-AES128-GCM-SHA256:kEDH+AESGCM:ECDHE-RSA-AES128-SHA256:ECDHE-ECDSA-AES128-SHA256:ECDHE-RSA-AES128-SHA:ECDHE-ECDSA-AES128-SHA:ECDHE-RSA-AES256-SHA384:ECDHE-ECDSA-AES256-SHA384:ECDHE-RSA-AES256-SHA:ECDHE-ECDSA-AES256-SHA:DHE-RSA-AES128-SHA256:DHE-RSA-AES128-SHA:DHE-DSS-AES128-SHA256:DHE-RSA-AES256-SHA256:DHE-DSS-AES256-SHA:DHE-RSA-AES256-SHA:AES128-GCM-SHA256:AES256-GCM-SHA384:AES128-SHA256:AES256-SHA256:AES128-SHA:AES256-SHA:AES:CAMELLIA:DES-CBC3-SHA:!aNULL:!eNULL:!EXPORT:!DES:!RC4:!MD5:!PSK:!aECDH:!EDH-DSS-DES-CBC3-SHA:!EDH-RSA-DES-CBC3-SHA:!KRB5-DES-CBC3-SHA';
    ssl_session_timeout 1d;
    ssl_session_cache shared:SSL:50m;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security max-age=15768000;
}

server {
    listen 80;
    server_name $PROJECTNAME.test;
    return 301 https://\$host\$request_uri;
}" > ~/$PROJECTNAME.test
sudo mv ~/$PROJECTNAME.test /etc/nginx/sites-available/$PROJECTNAME.test
sudo ln -s /etc/nginx/sites-available/$PROJECTNAME.test /etc/nginx/sites-enabled/$PROJECTNAME.test

echo "${boldgreen}Added vhost, $PROJECTNAME.test added to /etc/nginx/sites-enabled/${txtreset}"
echo "${yellow}Restarting nginx...${txtreset}"
sudo service nginx stop
sudo service nginx start
echo "${boldgreen}Local environment up and running.${txtreset}"
echo "${boldyellow}Almost done! Use HostsFileEditor https://github.com/scottlerch/HostsFileEditor and add 127.0.0.1 $PROJECTNAME.test to your Windows hosts file (Windows does not let to update this via command line)."
echo " ${txtreset}"
echo "${white}${txtbold}Front end: ${white}https://${PROJECTNAME}.test${txtreset}"
echo "${white}${txtbold}WP-admin:  ${white}https://${PROJECTNAME}/wp/wp-login.php${txtreset}"
echo " ${txtreset}"
echo "${white}${txtbold}Please note!${white} There are no themes installed so you may see a white page. We recommend Air-light which is designed for dudestack: https://github.com/digitoimistodude/air-light - So next git clone air-light and run newtheme.sh under bin/."
echo " ${txtreset}"
