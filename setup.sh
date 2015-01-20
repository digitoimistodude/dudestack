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
read -p "${boldyellow}Have you installed jolliest-vagrant as instructed? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) echo "${red}Please do so. Here: https://github.com/ronilaukkarinen/jolliest-vagrant${txtreset}"; exit;;
        * ) echo "${boldwhite}Please answer y or n.${txtreset}";;
    esac
done

echo "${boldyellow}Bitbucket account:${txtreset} "
read -e YOUR_BITBUCKET_ACCOUNT_HERE

echo "${boldyellow}Bitbucket account:${txtreset} "
read -e YOUR_BITBUCKET_ACCOUNT_HERE

echo "${boldyellow}Staging server hostname:${txtreset} "
read -e YOUR_STAGING_SERVER_HERE

echo "${boldyellow}Staging server username:${txtreset} "
read -e YOUR_STAGING_USERNAME_HERE

echo "${boldyellow}Staging server password:${txtreset} "
read -e YOUR_STAGING_SERVER_PASSWORD_HERE

echo "${boldyellow}Staging server home path:${txtreset} "
read -e YOUR_STAGING_SERVER_HOME_PATH_HERE

echo "${boldyellow}Default MySQL-username (root for jolliest-vagrant):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_USERNAME_HERE

echo "${boldyellow}Default MySQL-password (vagrant for jolliest-vagrant):${txtreset} "
read -e YOUR_DEFAULT_DATABASE_PASSWORD_HERE

echo "${boldyellow}Default admin username for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE

echo "${boldyellow}Default admin password for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE

echo "${boldyellow}Default admin password for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE

echo "${boldyellow}Default admin email for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE

echo "${boldyellow}Default admin email for WordPress:${txtreset} "
read -e YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE


echo "${boldgreen}Setup successful."
echo "${red}WARNING! ${boldwhite}Don't trust blindly in your deploy configs, they contain remove commands! Please check them twice before deploying\!${txtreset}"