#!/bin/bash
# Project starting bash script by rolle

txtbold=$(tput bold)
boldyellow=${txtbold}$(tput setaf 3)
boldgreen=${txtbold}$(tput setaf 2)
boldwhite=${txtbold}$(tput setaf 7)
yellow=$(tput setaf 3)
green=$(tput setaf 2)
white=$(tput setaf 7)
txtreset=$(tput sgr0)
LOCAL_IP=$(ifconfig | grep -Eo "inet (addr:)?([0-9]*\.){3}[0-9]*" | grep -Eo "([0-9]*\.){3}[0-9]*" | grep -v "127.0.0.1")

 while true; do
 read -p "${boldyellow}MAMP properly set up and running? (y/n)${txtreset} " yn
     case $yn in
         [Yy]* ) break;;
         [Nn]* ) exit;;
         * ) echo "Please answer y or n.";;
     esac
 done

echo "${boldyellow}Project name in lowercase:${txtreset} "
read -e PROJECTNAME
cd $HOME/wpstack-rolle
composer create-project -n ronilaukkarinen/wpstack-rolle $HOME/Projects/${PROJECTNAME} dev-master
cd $HOME/Projects/${PROJECTNAME}
composer update
echo "${yellow}Creating a MySQL database for ${PROJECTNAME}${txtreset}"
/Applications/MAMP/Library/bin/mysql -u root -p -e "create database ${PROJECTNAME}"
echo "${boldgreen}MySQL database created${txtreset}"
echo "${yellow}Installing Capistrano${txtreset}"
#bundle install
#bundle exec cap install
cap install
echo "${boldgreen}Capistrano installed${txtreset}"
echo "${yellow}Generating config/deploy.rb${txtreset}"
echo "set :application, \"$PROJECTNAME\"
set :repo_url,  \"git@bitbucket.org:ronilaukkarinen/$PROJECTNAME.git\"
SSHKit.config.command_map[:composer] = \"/home/dude/bin/composer\"
set :branch, :master
set :log_level, :info
set :linked_files, %w{.env}
set :linked_dirs, %w{content/uploads}
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


    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                execute 'composer', 'install', '--no-dev', '--optimize-autoloader'
            end
        end
    end

    after :updated, 'deploy:composer_install'
    
end
" > "$HOME/Projects/$PROJECTNAME/config/deploy.rb"
echo "${yellow}Generating staging.rb${txtreset}"
echo "role :app, %w{dude@kettu.skyred.fi}

set :ssh_options, {
    auth_methods: %w(password),
    password: \"cr7d3truNajuvu5\",
    forward_agent: \"true\"
}

set :deploy_to, \"/home/dude/sites/asiakas.dude.fi/projects/#{fetch(:application)}\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3

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


        end
    end

end" > "$HOME/Projects/$PROJECTNAME/config/deploy/staging.rb"
echo "${yellow}Generating production.rb${txtreset}"
echo "role :app, %w{username@yourserver.com}

set :ssh_options, {
    auth_methods: %w(password),
    password: \"yourpassword\",
    forward_agent: \"true\"
}

set :deploy_to, \"/home/#{fetch(:application)}/deploy\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3

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

            # set this up:
            #execute \"rm -f /home/#{fetch(:application)}/path/to/public_html && ln -nfs #{current_path} /path/to/public_html\"

        end
    end

end" > "$HOME/Projects/$PROJECTNAME/config/deploy/production.rb"
echo "${yellow}Copying languages...${txtreset}"
cd wp/wp-content
cp -R languages "/Users/rolle/Projects/$PROJECTNAME/content/"
cd "$HOME/Projects/$PROJECTNAME/"
#rm CHANGELOG.md
#rm CONTRIBUTING.md
rm README.md
#rm LICENSE.md
echo "<?php
\$root_dir = dirname(dirname(__FILE__));

/**
 * Use Dotenv to set required environment variables and load .env file in root
 */
Dotenv::load(\$root_dir);
Dotenv::required(array('DB_NAME', 'DB_USER', 'DB_PASSWORD', 'WP_HOME', 'WP_SITEURL'));

/**
 * Set up our global environment constant and load its config first
 * Default: development
 */
define('WP_ENV', getenv('WP_ENV') ? getenv('WP_ENV') : 'development');

\$env_config = dirname(__FILE__) . '/environments/' . WP_ENV . '.php';

if (file_exists(\$env_config)) {
  require_once \$env_config;
}

/**
 * Custom Content Directory
 */
define('CONTENT_DIR', '/content');
define('WP_CONTENT_DIR', \$root_dir . CONTENT_DIR);
define('WP_CONTENT_URL', WP_HOME . CONTENT_DIR);

/**
 * DB settings
 */
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';

/**
 * WordPress Localized Language
 * Default: English
 *
 * A corresponding MO file for the chosen language must be installed to content/languages
 */
define('WPLANG', 'fi');

/**
 * Authentication Unique Keys and Salts
 */
define('AUTH_KEY',         getenv('AUTH_KEY'));
define('SECURE_AUTH_KEY',  getenv('SECURE_AUTH_KEY'));
define('LOGGED_IN_KEY',    getenv('LOGGED_IN_KEY'));
define('NONCE_KEY',        getenv('NONCE_KEY'));
define('AUTH_SALT',        getenv('AUTH_SALT'));
define('SECURE_AUTH_SALT', getenv('SECURE_AUTH_SALT'));
define('LOGGED_IN_SALT',   getenv('LOGGED_IN_SALT'));
define('NONCE_SALT',       getenv('NONCE_SALT'));

/**
 * Custom Settings
 */
define('AUTOMATIC_UPDATER_DISABLED', true);
define('DISABLE_WP_CRON', true);
define('DISALLOW_FILE_EDIT', true);

/**
 * Bootstrap WordPress
 */
if (!defined('ABSPATH')) {
  define('ABSPATH', \$root_dir . '/wp/');
}
" > config/application.php
echo "${boldgreen}deploy.rb generated${txtreset}"
echo "${yellow}Updating WordPress related stuff...:${txtreset}"
cp $HOME/wpstack-rolle/composer.json "$HOME/Projects/$PROJECTNAME/composer.json"
cd "$HOME/Projects/$PROJECTNAME/"
composer update
echo "${yellow}Copy these to .env:${txtreset}"
echo "
DB_NAME=${PROJECTNAME}
DB_USER=root
DB_PASSWORD=yourpassword
DB_HOST=localhost

WP_ENV=development
WP_HOME=http://${LOCAL_IP}
WP_SITEURL=http://${LOCAL_IP}/wp
"
echo "${boldgreen}All done! Install WP and start coding at http://${LOCAL_IP}! Remember to make a repo on Bitbucket, eventually.${txtreset}"
