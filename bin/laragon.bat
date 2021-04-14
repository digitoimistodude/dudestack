@echo off
SETLOCAL EnableDelayedExpansion
SET DOCUMENT_ROOT="c:/laragon/www/"

REM PROJECTNAME
SET PROJECTNAME=''
:projectnameinput
SET /p PROJECTNAME="Project name in lowercase (without spaces or special characters): "
IF %PROJECTNAME% == '' GOTO :projectnameinput

REM MYSQL_ROOT_PASSWORD
SET MYSQL_ROOT_PASSWORD=''
:mysqlrootinput
SET /p MYSQL_ROOT_PASSWORD="What is your MySQL root password: "
IF %MYSQL_ROOT_PASSWORD% == '' GOTO :mysqlrootinput

REM ADMIN_USER
SET ADMIN_USER=''
:admin_userinput
SET /p ADMIN_USER="What is the admin user you want to login to wp-admin: "
IF %ADMIN_USER% == '' GOTO :admin_userinput

REM ADMIN_PASSWORD
SET ADMIN_PASSWORD=''
:admin_passwordinput
SET /p ADMIN_PASSWORD="What is the password you want to use with your wp-admin admin user: "
IF %ADMIN_PASSWORD% == '' GOTO :admin_passwordinput

REM ADMIN_EMAIL
SET ADMIN_EMAIL=''
:admin_emailinput
SET /p ADMIN_EMAIL="What is the email address you want to use with your wp-admin admin user: "
IF %ADMIN_EMAIL% == '' GOTO :admin_emailinput
CALL composer create-project -n ronilaukkarinen/dudestack %DOCUMENT_ROOT%/%PROJECTNAME% dev-master

cd %DOCUMENT_ROOT%/%PROJECTNAME%

CALL composer update

mysql -u root -p%MYSQL_ROOT_PASSWORD% -e "CREATE DATABASE %PROJECTNAME%"

sed -i -e "s/database_name/%PROJECTNAME%/g" .env
sed -i -e "s/database_user/root/g" .env
sed -i -e "s/database_password/%MYSQL_ROOT_PASSWORD%/g" .env
sed -i -e "s/database_host/127.0.0.1/g" .env
sed -i -e "s/example.com/%PROJECTNAME%.test/g" .env
sed -i -e "s/example.com/%PROJECTNAME%.test/g" .env
sed -i -e "s/http/https/g" .env

echo path: wp > wp-cli.yml
echo url: https://%PROJECTNAME%.test >> wp-cli.yml
echo core install: >> wp-cli.yml
echo      admin_user: "%ADMIN_USER%" >> wp-cli.yml
echo      admin_password: "%ADMIN_PASSWORD%" >> wp-cli.yml
echo      admin_email: "%ADMIN_EMAIL%" >> wp-cli.yml
echo      title: "%PROJECTNAME%" >> wp-cli.yml

CALL vendor\wp-cli\wp-cli\bin\wp core install --title=test --admin_email=%ADMIN_EMAIL%

CALL vendor\wp-cli\wp-cli\bin\wp post delete 1 --force
CALL vendor\wp-cli\wp-cli\bin\wp post delete 2 --force
CALL vendor\wp-cli\wp-cli\bin\wp option update blogdescription ''
CALL vendor\wp-cli\wp-cli\bin\wp option update WPLANG 'fi'
CALL vendor\wp-cli\wp-cli\bin\wp option update current_theme '$PROJECTNAME'
CALL vendor\wp-cli\wp-cli\bin\wp theme delete twentytwelve
CALL vendor\wp-cli\wp-cli\bin\wp theme delete twentythirteen
CALL vendor\wp-cli\wp-cli\bin\wp option update permalink_structure '\%postname%'
CALL vendor\wp-cli\wp-cli\bin\wp option update timezone_string 'Europe\Helsinki'
CALL vendor\wp-cli\wp-cli\bin\wp option update default_pingback_flag '0'
CALL vendor\wp-cli\wp-cli\bin\wp option update default_ping_status 'closed'
CALL vendor\wp-cli\wp-cli\bin\wp option update default_comment_status 'closed'
CALL vendor\wp-cli\wp-cli\bin\wp option update date_format 'j.n.Y'
CALL vendor\wp-cli\wp-cli\bin\wp option update time_format 'H.i'
REM %DOCUMENT_ROOT%\%PROJECTNAME% && vendor\wp-cli\wp-cli\bin\wp option update admin_email 'koodarit@dude.fi'
REM %DOCUMENT_ROOT%\%PROJECTNAME% && vendor\wp-cli\wp-cli\bin\wp option delete new_admin_email

rm README.md
rm LICENSE
rm -rf .git
rm .travis.yml
rm -rf bin
rm .env.example
rm phpcs.xml
rm wp-cli.yml

REM CLEAN VARIABLES
SET DOCUMENT_ROOT=''
SET PROJECTNAME=''
SET ADMIN_USER=''
SET ADMIN_PASSWORD=''
SET ADMIN_EMAIL=''
SET MYSQL_ROOT_PASSWORD=''
ECHO DONE
ECHO RESTART NGINX FROM LARAGON GUI