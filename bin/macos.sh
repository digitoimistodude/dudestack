#!/bin/bash
# Project starting bash script for macOS native LEMP.
# More info: https://github.com/digitoimistodude/macos-lemp-setup

# Import required variables
source helpers/variables.sh

# Script specific vars
SCRIPT_LABEL='for macOS'
SCRIPT_VERSION='1.0.2'

# Final note about server requirements
echo ""
echo "${WHITE}Using this start script requires you have dev server installed and working:
https://github.com/digitoimistodude/macos-lemp-setup
${TXTRESET}"
echo ""

# Script header
source helpers/header.sh

echo "${BOLDYELLOW}Project name in lowercase (without spaces or special characters):${TXTRESET} "
read -e PROJECTNAME
cd $HOME/Projects/dudestack
git pull
composer create-project -n ronilaukkarinen/dudestack $HOME/Projects/${PROJECTNAME} dev-master
cd $HOME/Projects/${PROJECTNAME}
composer update
echo "${YELLOW}Creating a MySQL database for ${PROJECTNAME}${TXTRESET}"
mysql -u root -p'YOUR_DEFAULT_DATABASE_PASSWORD_HERE' -e "CREATE DATABASE ${PROJECTNAME}"
echo "${BOLDGREEN}Attempt to create MySQL database successful.${TXTRESET}"
echo "${YELLOW}Installing Capistrano in the project directory${TXTRESET}"
sudo gem install capistrano
cap install
echo "${BOLDGREEN}Capistrano installed${TXTRESET}"
echo "${YELLOW}Generating config/deploy.rb${TXTRESET}"
cho "set :application, \"$PROJECTNAME\"
set :repo_url, \"git@github.com:YOUR_GITHUB_COMPANY_USERNAME/$PROJECTNAME.git\"
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
      # This task is requiRED by Capistrano but can be a no-op
      # Your restart mechanism here, for example:
      # execute :service, :nginx, :reload
    end
  end

end" > "$HOME/Projects/$PROJECTNAME/config/deploy.rb"
echo "${BOLDGREEN}deploy.rb generated${TXTRESET}"
echo "${YELLOW}Generating staging.rb${TXTRESET}"
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
echo "${YELLOW}Generating production.rb${TXTRESET}"
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
echo "${YELLOW}Updating WordPress related stuff...:${TXTRESET}"
cp $HOME/Projects/dudestack/composer.json "$HOME/Projects/$PROJECTNAME/composer.json"
cd "$HOME/Projects/$PROJECTNAME/"

# Clean ups
rm README.md
rm LICENSE
rm -rf .git
rm .travis.yml
rm package-lock.json
rm .DS_Store
rm -rf bin
rm .env-e
rm .env.example
rm phpcs.xml

composer update
echo "${YELLOW}Updating .env (db cREDentials)...:${TXTRESET}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/YOUR_DEFAULT_DATABASE_USERNAME_HERE/g" .env
sed -i -e "s/database_password/YOUR_DEFAULT_DATABASE_PASSWORD_HERE/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.test/g" .env
sed -i -e "s/http/https/g" .env
echo '
SENDGRID_API_KEY=YOUR_SENDGRID_API_KEY_HERE' >> .env
echo -e '
IMAGIFY_API_KEY=YOUR_IMAGIFY_API_KEY_HERE' >> .env
echo -e '
HS_BEACON_ID=YOUR_HS_BEACON_ID_HERE' >> .env

echo "${YELLOW}Installing WordPress...:${TXTRESET}"
echo "path: wp
url: https://${PROJECTNAME}.test

core install:
  admin_user: YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE
  admin_password: YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE
  admin_email: YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
  title: \"${PROJECTNAME}\"" > wp-cli.yml

cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp core install --title=$PROJECTNAME --admin_email=YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
echo "${YELLOW}Removing default WordPress posts...:${TXTRESET}"
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
#echo "${YELLOW}Activating necessary plugins, mainly for theme development...:${TXTRESET}"
#cd /var/www/$PROJECTNAME/;vendor/wp-cli/wp-cli/bin/wp plugin activate --all

echo "${YELLOW}Setting file permissions for local...${TXTRESET}"
chmod -R 777 $HOME/Projects/$PROJECTNAME

echo "${YELLOW}Generating HTTPS cert for project...${TXTRESET}"
mkdir -p /var/www/certs && cd /var/www/certs && mkcert "$PROJECTNAME.test"

# For GitHub:
echo "${YELLOW}Creating a GitHub repo...${TXTRESET}"
curl -u 'YOUR_GITHUB_COMPANY_USERNAME':'YOUR_GITHUB_ACCESS_TOKEN' https://api.github.com/orgs/YOUR_GITHUB_COMPANY_USERNAME/repos -d '{"name": "'${PROJECTNAME}'","auto_init": false,"private": true,"description": "A repository for '${PROJECTNAME}' site"}'

echo "${YELLOW}Initializing the GitHub repo...${TXTRESET}"
cd "$HOME/Projects/$PROJECTNAME"
git init
git remote add origin git@github.com:YOUR_GITHUB_COMPANY_USERNAME/$PROJECTNAME.git
git config core.fileMode false
git add --all
git commit -m 'First commit - project started'
git push -u origin --all

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
    ssl_session_cache shaRED:SSL:50m;
    ssl_stapling_verify on;
    add_header Strict-Transport-Security max-age=15768000;
}

server {
    listen 80;
    server_name $PROJECTNAME.test;
    return 301 https://\$host\$request_uri;
}" > "/etc/nginx/sites-available/$PROJECTNAME.test"
sudo ln -s /etc/nginx/sites-available/$PROJECTNAME.test /etc/nginx/sites-enabled/$PROJECTNAME.test

echo "${BOLDGREEN}Added vhost, $PROJECTNAME.test added to /etc/nginx/sites-enabled/${TXTRESET}"
echo "${YELLOW}Restarting nginx...${TXTRESET}"
sudo launchctl unload /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
sudo launchctl load /Library/LaunchDaemons/homebrew.mxcl.nginx.plist
echo "${BOLDGREEN}Local environment up and running.${TXTRESET}"
echo "${YELLOW}Updating hosts file...${TXTRESET}"
sudo -- sh -c "echo 127.0.0.1 ${PROJECTNAME}.test >> /etc/hosts"
sudo brew services stop nginx
sudo brew services start nginx
echo "${BOLDGREEN}All done! Start coding at https://${PROJECTNAME}.test!${TXTRESET} (Please note! no themes installed, so you may see a WHITE page. We recommend air which is designed for dudestack: https://github.com/digitoimistodude/air)"
fi
