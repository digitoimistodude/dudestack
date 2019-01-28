#!/bin/bash
# Project starting bash script by rolle.

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

# Did you run bin/setup.sh first? let's see about that...
if [ ! -f /usr/local/bin/createproject ]; then
  echo "${red}It seems you did not run bin/setup.sh. Run sh bin/setup.sh and try again.${txtreset}"
  exit
else

# while true; do
# read -p "${boldyellow}MAMP properly set up and running? (y/n)${txtreset} " yn
#     case $yn in
#         [Yy]* ) break;;
#         [Nn]* ) exit;;
#         * ) echo "Please answer y or n.";;
#     esac
# done

echo "${boldyellow}Project name in lowercase (without spaces or special characters):${txtreset} "
read -e PROJECTNAME
cd $HOME/Projects/dudestack
composer create-project -n digitoimistodude/dudestack $HOME/Projects/${PROJECTNAME} dev-master
cd $HOME/Projects/${PROJECTNAME}
composer update
echo "${yellow}Creating a MySQL database for ${PROJECTNAME}${txtreset}"
# NOTE: this needs auto-login to local vm
WP_CLI_PREFIXmysql -u root -p'YOUR_DEFAULT_DATABASE_PASSWORD_HERE' -e \"CREATE DATABASE ${PROJECTNAME}\"WP_CLI_SUFFIX
# For MAMP:
#/Applications/MAMP/Library/bin/mysql -u root -pYOURMAMPMYSQLPASSWORD -e "create database ${PROJECTNAME}"
echo "${boldgreen}Attempt to create MySQL database successful.${txtreset}"
echo "${yellow}Installing Capistrano in the project directory${txtreset}"
#bundle install
#bundle exec cap install
cap install
echo "${boldgreen}Capistrano installed${txtreset}"
echo "${yellow}Generating config/deploy.rb${txtreset}"
echo "set :application, \"$PROJECTNAME\"
set :repo_url,  \"git@bitbucket.org:YOUR_BITBUCKET_USERNAME_HERE/$PROJECTNAME.git\"
set :branch, :master
set :log_level, :debug
set :linked_files, %w{.env}
set :linked_dirs, %w{media}
set :composer_install_flags, '--no-dev --prefer-dist --no-scripts --optimize-autoloader'
set :composer_roles, :all

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # This task is required by Capistrano but can be a no-op
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end

end" > "$HOME/Projects/$PROJECTNAME/config/deploy.rb"
echo "${boldgreen}deploy.rb generated${txtreset}"
echo "${yellow}Generating staging.rb${txtreset}"
echo "role :app, %w{YOUR_STAGING_USERNAME_HERE@YOUR_STAGING_SERVER_HERE}

set :ssh_options, {
    auth_methods: %w(password),
    password: \"YOUR_STAGING_SERVER_PASSWORD_HERE\",
    forward_agent: \"true\"
}

set :deploy_to, \"YOUR_STAGING_SERVER_HOME_PATH_HERE/projects/#{fetch(:application)}\"
SSHKit.config.command_map[:composer] = \"YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 2
set :tmp_dir, \"YOUR_STAGING_SERVER_HOME_PATH_HERE/tmp\"

namespace :deploy do

    desc \"Build\"
    after :updated, :build do
        on roles(:app) do
            within release_path  do

           end
        end
    end

  desc \"Set up symlinks\"
    task :finished do
        on roles(:app) do

            execute \"mkdir -p YOUR_STAGING_SERVER_PUBLIC_PATH_HERE\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/content && ln -nfs #{current_path}/content YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/content\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/index.php && ln -nfs #{current_path}/index.php YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/index.php\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/wp-config.php && ln -nfs #{current_path}/wp-config.php YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/wp-config.php\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/wp && ln -nfs #{current_path}/wp YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/wp\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/vendor && ln -nfs #{current_path}/vendor YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/vendor\"
            execute \"rm -f YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/config && ln -nfs #{current_path}/config YOUR_STAGING_SERVER_PUBLIC_PATH_HERE/config\"

        end
    end

    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                if test(\"[ -f YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer ]\")
                    puts \"Composer already exists, running update only...\"
                    execute 'composer', 'update'
                else
                    execute \"mkdir -p YOUR_STAGING_SERVER_HOME_PATH_HERE/bin && curl -sS https://getcomposer.org/installer | php && mv composer.phar YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer && chmod +x YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer\"
                    execute 'composer', 'update'
                    execute 'composer', 'install', '--no-dev', '--optimize-autoloader'
                end
            end
        end
    end

    after :updated, 'deploy:composer_install'

end" > "$HOME/Projects/$PROJECTNAME/config/deploy/staging.rb"
echo "${yellow}Generating production.rb${txtreset}"
echo "role :app, %w{$PROJECTNAME@YOUR_PRODUCTION_SERVER_HERE}

set :ssh_options, {
    auth_methods: %w(password),
    password: \"YOUR_PRODUCTION_SERVER_PASSWORD_HERE\",
    forward_agent: \"true\"
}

set :deploy_to, \"/home/$PROJECTNAME/deploy/\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 2
set :tmp_dir, \"/home/$PROJECTNAME/tmp\"
SSHKit.config.command_map[:composer] = \"/home/$PROJECTNAME/bin/composer\"

namespace :deploy do

    desc \"Build\"
    after :updated, :build do
        on roles(:app) do
            within release_path  do

           end
        end
    end

  desc \"Fix symlinks\"
    task :finished do
        on roles(:app) do

            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/content && ln -nfs #{current_path}/content /home/$PROJECTNAME/www.$PROJECTNAME.fi/content\"
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/index.php && ln -nfs #{current_path}/index.php /home/$PROJECTNAME/www.$PROJECTNAME.fi/index.php\"
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/wp-config.php && ln -nfs #{current_path}/wp-config.php /home/$PROJECTNAME/www.$PROJECTNAME.fi/wp-config.php\"
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/wp && ln -nfs #{current_path}/wp /home/$PROJECTNAME/www.$PROJECTNAME.fi/wp\"
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/vendor && ln -nfs #{current_path}/vendor /home/$PROJECTNAME/www.$PROJECTNAME.fi/vendor\"
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/config && ln -nfs #{current_path}/config /home/$PROJECTNAME/www.$PROJECTNAME.fi/config\"

            # Media library:
            execute \"rm -f /home/$PROJECTNAME/www.$PROJECTNAME.fi/media && ln -nfs #{current_path}/media /home/$PROJECTNAME/www.$PROJECTNAME.fi/media\"
            execute \"chmod -R 775 #{current_path}/media\"

            # Permissions:
            execute \"chmod 755 #{current_path}/content\"
            #execute \"chmod -Rv 755 #{current_path}/content/wp-rocket-config\"

            # WP-CLI (optional):
            #within release_path do
            #    execute \"cd #{current_path} && vendor/wp-cli/wp-cli/bin/wp --path=/home/$PROJECTNAME/www.$PROJECTNAME.fi/wp rocket regenerate --file=advanced-cache\"
            #    execute \"cd #{current_path} && vendor/wp-cli/wp-cli/bin/wp --path=//home/$PROJECTNAME/www.$PROJECTNAME.fi/wp rocket regenerate --file=htaccess\"
            #end

        end
    end


    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                if test(\"[ -f /home/USERNAME/bin/composer ]\")
                    puts \"Composer already exists, running update only...\"
                    execute 'composer', 'update'
                else
                    execute \"mkdir -p /home/#{fetch(:application)}/bin/ && curl -sS https://getcomposer.org/installer | php && mv composer.phar /home/#{fetch(:application)}/bin/composer && chmod +x /home/#{fetch(:application)}/bin/composer\"
                    execute 'composer', 'update'
                    execute 'composer', 'install', '--no-dev', '--optimize-autoloader'
                end
            end
        end
    end

    after :updated, 'deploy:composer_install'

end" > "$HOME/Projects/$PROJECTNAME/config/deploy/production.rb"

cd "$HOME/Projects/$PROJECTNAME/"
echo "${yellow}Updating WordPress related stuff...:${txtreset}"
cp $HOME/Projects/dudestack/composer.json "$HOME/Projects/$PROJECTNAME/composer.json"
cd "$HOME/Projects/$PROJECTNAME/"

# Clean ups
rm README.md
rm LICENSE
rm -rf .git
rm .travis.yml
rm package-lock.json
rm .DS_Store

composer update
echo "${yellow}Updating .env (db credentials)...:${txtreset}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/YOUR_DEFAULT_DATABASE_USERNAME_HERE/g" .env
sed -i -e "s/database_password/YOUR_DEFAULT_DATABASE_PASSWORD_HERE/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
echo '
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE' >> .env
echo -e '
IMAGIFY_API_KEY=YOUR_IMAGIFY_API_KEY_HERE' >> .env

# If you are using MAMP you may want to enable these:

# echo "${yellow}Installing wp-cli...:${txtreset}"
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# chmod +x wp-cli.phar
# mkdir wp-cli
# mv wp-cli.phar wp-cli/wp

# But if you are using vagrant, you should be using these:

echo "${yellow}Installing WordPress...:${txtreset}"
echo "path: wp
url: http://${PROJECTNAME}.test

core install:
  admin_user: YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE
  admin_password: YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE
  admin_email: YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
  title: \"${PROJECTNAME}\"" > wp-cli.yml

# The command is following for MAMP:
#./wp-cli/wp core install

# These syntaxes are for vagrant:

WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp core install --title=$PROJECTNAME --admin_email=YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HEREWP_CLI_SUFFIX
echo "${yellow}Removing default WordPress posts...:${txtreset}"
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 1 --forceWP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp post delete 2 --forceWP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update blogdescription ''WP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentytwelveWP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp theme delete twentythirteenWP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update permalink_structure '/%postname%'WP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update timezone_string 'Europe/Helsinki'WP_CLI_SUFFIX
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update default_pingback_flag '0'WP_CLI_SUFFIX
date_format=$(vendor/wp-cli/wp-cli/bin/wp eval "echo __( 'j.n.Y' );")
WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp option update date_format $date_formatWP_CLI_SUFFIX
#echo "${yellow}Activating necessary plugins, mainly for theme development...:${txtreset}"
#WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp plugin activate --allWP_CLI_SUFFIX
chmod -R 775 $HOME/Projects/$PROJECTNAME/content

## You can set up extra users here - if you want, uncomment next lines
#####################################################################

#echo "${yellow}Setting up users...:${txtreset}"
#WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp user update admin --display_name=\"Your Company Ltd\"WP_CLI_SUFFIX
#WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp user update admin --first_name=\"Your Company Ltd\"WP_CLI_SUFFIX
#WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp user create user1 user1@yourcompanyltd.com --role=administrator --user_pass=somepass --first_name=John --last_name=Doe --display_name=JohnWP_CLI_SUFFIX
#WP_CLI_PREFIXcd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp user create user2 user2@yourcompanyltd.com --role=administrator --user_pass=somepass --first_name=Marilyn --last_name=Manson --display_name=MarilynWP_CLI_SUFFIX

rm "$HOME/Projects/$PROJECTNAME/.env.example"
#echo "${yellow}Creating a Bitbucket repo...${txtreset}"
#curl -X POST -v -u YOUR_BITBUCKET_ACCOUNT_HERE:YOUR_BITBUCKET_PASSWORD_HERE "https://api.bitbucket.org/2.0/repositories/YOUR_BITBUCKET_TEAM_HERE/${PROJECTNAME}" -H "Content-Type: application/json"  -d '{"is_private": true, "project": {"key": "PROJECTS'"${YEAR}"'"}}'

# For GitHub:
#echo "${yellow}Creating a GitHub repo...${txtreset}"
#curl -u 'YOUR_GITHUB_COMPANY_USERNAME':'YOUR_ACCESS_TOKEN' https://api.github.com/orgs/YOUR_GITHUB_COMPANY_USERNAME/repos -d '{"name": "${PROJECTNAME}","auto_init": false,"private": true,"description": "A repository for ${PROJECTNAME} site"}'

#echo "${yellow}Initializing the bitbucket repo...${txtreset}"
cd "$HOME/Projects/$PROJECTNAME"
git init
#git remote add origin git@bitbucket.org:YOUR_BITBUCKET_TEAM_HERE/$PROJECTNAME.git
git add --all
git commit -m 'First commit - project started'
#git push -u origin --all

echo "server {
    listen 80;
    #listen [::]:80 default ipv6only=on;

    root /var/www/$PROJECTNAME;
    index index.html index.htm index.php;

    server_name $PROJECTNAME.test www.$PROJECTNAME.test;
    include php7.conf;
    include global/wordpress.conf;
}" > "$HOME/Projects/marlin-vagrant/vhosts/$PROJECTNAME.test"

echo "${boldgreen}Added vhost, $PROJECTNAME.test added to vagrant sites-enabled.${txtreset}"
echo "${yellow}Reprovisioning vagrant...${txtreset}"
cd ~/Projects/marlin-vagrant
vagrant provision
echo "${boldgreen}VM provisioned, local environment up and running.${txtreset}"
echo "${yellow}Updating hosts file...${txtreset}"
sudo -- sh -c "echo 10.1.2.4 ${PROJECTNAME}.test >> /etc/hosts"
echo "${boldgreen}All done! Start coding at http://${PROJECTNAME}.test!${txtreset} (Please note! no themes installed, so you may see a white page. We recommend air which is designed for dudestack: https://github.com/digitoimistodude/air)"
fi
