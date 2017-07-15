#!/bin/bash
# First setup.

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

while true; do
echo -e "${boldyellow}Which local environment you are using? 
Type:

1 for marlin-vagrant: https://github.com/digitoimistodude/marlin-vagrant
2 for native OS X: https://github.com/digitoimistodude/osx-lemp-setup
3 for Docker: https://github.com/digitoimistodude/dudestack-docker"
read choice
echo

case $choice in
     1)
      choice="marlin-vagrant"
      localip="10.1.2.4"
      break
      # Choose $choice
     ;;
     2)
      choice="osxlemp"
      localip="127.0.0.1"
      break
      # Choose $choice
     ;;
     3)
      choice="docker"
      localip="127.0.0.1"
      break
      # Choose $choice
     ;;     
     *)
     echo "${red}Please type, 1, 2 or 3 only.${txtreset}
     "
     ;;
esac
done

if [ "$choice" == "marlin-vagrant" ] ;
then
echo "${boldyellow}Starting $choice... (type password if prompted)${txtreset} "
cd ~/Projects/$choice && vagrant up --provision

while true; do
read -p "${boldyellow}Have you created a public key for SSH? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) ssh-keygen -t rsa;;
        * ) echo "${boldwhite}Please answer y or n.${txtreset}";;
    esac
done

echo "${boldyellow}Pairing vagrant with your computer...${txtreset} "
cat ~/.ssh/id_rsa.pub | ssh vagrant@$localip 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' && chmod -Rv 755 ~/.ssh && chmod 400 ~/.ssh/id_rsa
fi

echo "${boldyellow}Bitbucket account email:${txtreset} "
read -e YOUR_BITBUCKET_ACCOUNT_HERE

echo "${boldyellow}Bitbucket password:${txtreset} "
read -e YOUR_BITBUCKET_PASSWORD_HERE

echo "${boldyellow}Bitbucket team name (lowercase account name):${txtreset} "
read -e YOUR_BITBUCKET_TEAM_HERE

echo "${boldyellow}Staging server hostname (for example myawesomeserver.com):${txtreset} "
read -e YOUR_STAGING_SERVER_HERE

echo "${boldyellow}Staging server username (for example myusername0123):${txtreset} "
read -e YOUR_STAGING_USERNAME_HERE

echo "${boldyellow}Staging server password:${txtreset} "
read -e YOUR_STAGING_SERVER_PASSWORD_HERE

echo "${boldyellow}Staging server home path without last trailing slash (for example /home/myusername0123 or /var/www/somehome):${txtreset} "
read -e YOUR_STAGING_SERVER_HOME_PATH_HERE

echo "${boldyellow}Staging server public path without last trailing slash (for example /home/myusername0123/site.com or /var/www/somehome/public_html):${txtreset} "
read -e YOUR_STAGING_SERVER_PUBLIC_PATH_HERE

if [ $choice == "osxlemp" ] || [ $choice == "marlin-vagrant" ] ; then
echo "${boldyellow}Default MySQL-username (default: 'root'):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_USERNAME_HERE

echo "${boldyellow}Default MySQL-password (do not use / or \ characters, it may break the script):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_PASSWORD_HERE
fi

echo "${boldyellow}Default admin username for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE

echo "${boldyellow}Default admin password for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE

echo "${boldyellow}Default admin email for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE

echo "${boldyellow}Generating createscript with your information (requires root):${txtreset} "
if [ $choice == "marlin-vagrant" ]
then
sed -e "s;\YOUR_BITBUCKET_ACCOUNT_HERE;$YOUR_BITBUCKET_ACCOUNT_HERE;" -e "s;\YOUR_BITBUCKET_PASSWORD_HERE;$YOUR_BITBUCKET_PASSWORD_HERE;" -e "s;\YOUR_BITBUCKET_TEAM_HERE;$YOUR_BITBUCKET_TEAM_HERE;" -e "s;\YOUR_STAGING_SERVER_HERE;$YOUR_STAGING_SERVER_HERE;" -e "s;\YOUR_STAGING_USERNAME_HERE;$YOUR_STAGING_USERNAME_HERE;" -e "s;\YOUR_STAGING_SERVER_PASSWORD_HERE;$YOUR_STAGING_SERVER_PASSWORD_HERE;" -e "s;\YOUR_STAGING_SERVER_HOME_PATH_HERE;$YOUR_STAGING_SERVER_HOME_PATH_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_USERNAME_HERE;$YOUR_DEFAULT_DATABASE_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_PASSWORD_HERE;$YOUR_DEFAULT_DATABASE_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;" ~/Projects/dudestack/bin/createproject.sh > ~/Projects/dudestack/bin/createproject_generated.sh
fi
if [ $choice == "osxlemp" ] ;
then
sed -e "s;\YOUR_BITBUCKET_ACCOUNT_HERE;$YOUR_BITBUCKET_ACCOUNT_HERE;" -e "s;\YOUR_BITBUCKET_PASSWORD_HERE;$YOUR_BITBUCKET_PASSWORD_HERE;" -e "s;\YOUR_BITBUCKET_TEAM_HERE;$YOUR_BITBUCKET_TEAM_HERE;" -e "s;\YOUR_STAGING_SERVER_HERE;$YOUR_STAGING_SERVER_HERE;" -e "s;\YOUR_STAGING_USERNAME_HERE;$YOUR_STAGING_USERNAME_HERE;" -e "s;\YOUR_STAGING_SERVER_PASSWORD_HERE;$YOUR_STAGING_SERVER_PASSWORD_HERE;" -e "s;\YOUR_STAGING_SERVER_HOME_PATH_HERE;$YOUR_STAGING_SERVER_HOME_PATH_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_USERNAME_HERE;$YOUR_DEFAULT_DATABASE_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_PASSWORD_HERE;$YOUR_DEFAULT_DATABASE_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;" ~/Projects/dudestack/bin/osxlemp.sh > ~/Projects/dudestack/bin/createproject_generated.sh
fi
if [ $choice == "docker" ] ;
then
sed -e "s;\YOUR_BITBUCKET_ACCOUNT_HERE;$YOUR_BITBUCKET_ACCOUNT_HERE;" -e "s;\YOUR_BITBUCKET_PASSWORD_HERE;$YOUR_BITBUCKET_PASSWORD_HERE;" -e "s;\YOUR_BITBUCKET_TEAM_HERE;$YOUR_BITBUCKET_TEAM_HERE;" -e "s;\YOUR_STAGING_SERVER_HERE;$YOUR_STAGING_SERVER_HERE;" -e "s;\YOUR_STAGING_USERNAME_HERE;$YOUR_STAGING_USERNAME_HERE;" -e "s;\YOUR_STAGING_SERVER_PASSWORD_HERE;$YOUR_STAGING_SERVER_PASSWORD_HERE;" -e "s;\YOUR_STAGING_SERVER_HOME_PATH_HERE;$YOUR_STAGING_SERVER_HOME_PATH_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_USERNAME_HERE;$YOUR_DEFAULT_DATABASE_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_DATABASE_PASSWORD_HERE;$YOUR_DEFAULT_DATABASE_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE;" -e "s;\YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;$YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE;" ~/Projects/dudestack/bin/docker.sh > ~/Projects/dudestack/bin/createproject_generated.sh
fi

sudo mv ~/Projects/dudestack/bin/createproject_generated.sh /usr/local/bin/createproject
sudo chmod +x /usr/local/bin/createproject

echo "${boldgreen}Setup successful. Please run createproject before starting a project. Double check out source code of /usr/local/bin/createproject before using."
echo "${red}WARNING! ${boldwhite}Don't trust blindly in your deploy configs, they contain remove commands! Please check them twice before deploying!${txtreset}"
