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

# Did you run setup.sh first? let's see about that...
if [ ! -f /usr/bin/createproject ]; then
  echo "${red}It seems you did not run setup.sh. Run sh setup.sh and try again.${txtreset}"
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

while true; do
read -p "${boldyellow}Created Bitbucket/Github repo? (y/n)${txtreset} " yn
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
# NOTE: this needs auto-login to local vm
ssh vagrant@10.1.2.3 "mysql -u root -pvagrant -e \"CREATE DATABASE ${PROJECTNAME}\""
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
set :repo_url,  \"git@bitbucket.org:YOUR_BITBUCKET_ACCOUNT_HERE/$PROJECTNAME.git\"
set :branch, :master
set :log_level, :debug
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

end" > "$HOME/Projects/$PROJECTNAME/config/deploy.rb"
echo "${yellow}Generating staging.rb${txtreset}"
echo "role :app, %w{YOUR_STAGING_USERNAME_HERE@YOUR_STAGING_SERVER_HERE}

set :ssh_options, {
    auth_methods: %w(password),
    password: \"YOUR_STAGING_SERVER_PASSWORD_HERE\",
    forward_agent: \"true\"
}

set :deploy_to, \"/YOUR_STAGING_SERVER_HOME_PATH_HERE/projects/#{fetch(:application)}\"
set :tmp_dir, \"/YOUR_STAGING_SERVER_HOME_PATH_HERE/tmp\"
SSHKit.config.command_map[:composer] = \"/YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 2

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

            execute \"mkdir -p /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/content && ln -nfs #{current_path}/content /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/content\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/index.php && ln -nfs #{current_path}/index.php /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/index.php\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/wp-config.php && ln -nfs #{current_path}/wp-config.php /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/wp-config.php\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/wp && ln -nfs #{current_path}/wp /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/wp\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/vendor && ln -nfs #{current_path}/vendor /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/vendor\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/#{fetch(:application)}/config && ln -nfs #{current_path}/config /YOUR_SERVER_HOME_PATH_HERE/#{fetch(:application)}/config\"

        end
    end

    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                if test(\"[ -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer ]\")
                    puts \"Composer already exists, running update only...\"
                    execute 'composer', 'update'
                else
                    execute \"mkdir -p /YOUR_STAGING_SERVER_HOME_PATH_HERE/bin && curl -sS https://getcomposer.org/installer | php && mv composer.phar /YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer && chmod +x /YOUR_STAGING_SERVER_HOME_PATH_HERE/bin/composer\"
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

set :deploy_to, \"/home/#{fetch(:application)}/deploy/\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 2
set :tmp_dir, \"/home/#{fetch(:application)}/tmp\"
SSHKit.config.command_map[:composer] = \"/home/#{fetch(:application)}/bin/composer\"

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

            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/content && ln -nfs #{current_path}/content /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/content\"
            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/index.php && ln -nfs #{current_path}/index.php /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/index.php\"
            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/wp-config.php && ln -nfs #{current_path}/wp-config.php /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/wp-config.php\"
            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/wp && ln -nfs #{current_path}/wp /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/wp\"
            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/vendor && ln -nfs #{current_path}/vendor /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/vendor\"
            execute \"rm -f /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/config && ln -nfs #{current_path}/config /home/#{fetch(:application)}/www.#{fetch(:application)}.fi/config\"

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
echo "${yellow}Creating Sublime Text project...${txtreset}"
echo "{
    \"folders\":
    [
        {
            \"follow_symlinks\": true,
            \"path\": \".\",
            \"file_exclude_patterns\":[
                \"*.jpg\",
                \"*.png\",
                \"*.ico\",
                \"*.tar\",
                \"*.tgz\",
                \"*.zip\"
            ],
            \"folder_exclude_patterns\": [
                \"images\",
                \"wp\",
                \".sass-cache\",
                \"node_modules\",
                \"lib\",
                \"scripts\",
                \"vendor\",
                \"uploads\"
            ]
        }
    ]
}
" > "$PROJECTNAME.sublime-project"
echo "${yellow}Setting up package.json${txtreset}"
echo "{
  \"name\": \"$PROJECTNAME\",
  \"version\": \"1.0.0\",
  \"description\": \"$PROJECTNAME powered by wpstack-rolle + gulp\",
  \"author\": \"Digitoimisto Dude Oy (moro@dude.fi)\",
  \"devDependencies\": {
    \"browser-sync\": \"*\",
    \"gulp\": \"*\",
    \"gulp-changed\": \"*\",
    \"gulp-imagemin\": \"*\",
    \"gulp-notify\": \"*\",
    \"gulp-sass\": \"*\",
    \"gulp-util\": \"*\",
    \"gulp-minify-css\": \"*\",
    \"gulp-autoprefixer\": \"*\",
    \"gulp-uglify\": \"*\",
    \"gulp-cache\": \"*\",
    \"gulp-concat\": \"*\",
    \"gulp-header\": \"*\",
    \"normalize-css\": \"*\",
    \"gulp-pixrem\": \"*\",
    \"require-dir\": \"*\",
    \"psi\": \"*\"
  },
  \"dependencies\": {
    \"backbone\": \"*\",
    \"jquery\": \"*\"
  }
}" > "$HOME/Projects/$PROJECTNAME/package.json"
echo "${yellow}Installing local node.js packages (may take a while)${txtreset}"
npm install
echo "${yellow}Generating gulpfile...${txtreset}"
echo "/* 

REQUIRED STUFF
==============
*/

var changed     = require('gulp-changed');
var gulp        = require('gulp');
var imagemin    = require('gulp-imagemin');
var sass        = require('gulp-sass');
var browserSync = require('browser-sync');
var reload      = browserSync.reload;
var notify      = require('gulp-notify');
var prefix      = require('gulp-autoprefixer');
var minifycss   = require('gulp-minify-css');
var uglify      = require('gulp-uglify');
var cache       = require('gulp-cache');
var concat      = require('gulp-concat');
var util        = require('gulp-util');
var header      = require('gulp-header');
var pixrem      = require('gulp-pixrem');
var pagespeed   = require('psi');

/* 

ERROR HANDLING
==============
*/

var handleErrors = function() {
module.exports = function() {

  var args = Array.prototype.slice.call(arguments);

  // Send error to notification center with gulp-notify
  notify.onError({
    title: \"Compile Error\",
    message: \"<%= error.message %>\"
  }).apply(this, args);

  // Keep gulp from hanging on this task
  this.emit('end');
};
};

/* 

FILE PATHS
==========
*/

var themeDir = 'content/themes/$PROJECTNAME'
var imgSrc = themeDir + '/images/*.{png,jpg,jpeg,gif}';
var imgDest = themeDir + '/images/optimized';
var sassSrc = themeDir + '/sass/**/*.{sass,scss}';
var sassFile = themeDir + '/sass/layout.scss';
var cssDest = themeDir + '/css';
var customjs = themeDir + '/js/scripts.js';
var jsSrc = themeDir + '/js/src/**/*.js';
var jsDest = themeDir + '/js/';
var phpSrc = [themeDir + '/**/*.php', !'vendor/**/*.php'];

/* 

BROWSERSYNC
===========
*/

var devEnvironment = '$PROJECTNAME.dev'
var hostname = 'localhost'
var localURL = 'http://' + devEnvironment;

gulp.task('browserSync', function () {
    
    //declare files to watch + look for files in assets directory (from watch task)
    var files = [
    cssDest + '/**/*.{sass,scss}',
    jsSrc + '/**/*.js',
    imgDest + '/*.{png,jpg,jpeg,gif}',
    themeDir + '**/*.php'
    ];

    browserSync.init(files, {
    proxy: localURL,
    host: hostname,
    agent: false,
    browser: \"Google Chrome Canary\"
    });

});


/* 

SASS
====
*/

gulp.task('sass', function() {
  gulp.src(sassFile)

  // gulp-ruby-sass:

  .pipe(sass({
    compass: false,
    bundleExec: true,
    sourcemap: false,
    style: 'compressed'
  })) 

  // gulp-compass:

  // .pipe(sass({
  //   config_file: './config.rb',
  //   css: themeDir + '/css',
  //   sass: themeDir + '/sass',
  //   image: themeDir + '/images'
  // }))

  // gulp-sass:

  // .pipe(sass({
  //   style: 'compressed', 
  //   errLogToConsole: true,
  //   sourceComments: 'normal'
  //   }
  //   ))

  .on('error', handleErrors)
  .on('error', util.log)
  .on('error', util.beep)
  .pipe(prefix('last 3 version', 'safari 5', 'ie 8', 'ie 9', 'opera 12.1', 'ios 6', 'android 4')) //adds browser prefixes (eg. -webkit, -moz, etc.)
  .pipe(minifycss({keepBreaks:false,keepSpecialComments:0,}))
  .pipe(pixrem())
  .pipe(gulp.dest(themeDir + '/css'))
  .pipe(reload({stream:true}));
  });


/* 

IMAGES
======
*/


gulp.task('images', function() {
  var dest = imgDest;

  return gulp.src(imgSrc)

    .pipe(changed(dest)) // Ignore unchanged files
    .pipe(cache(imagemin({ optimizationLevel: 5, progressive: true, interlaced: true }))) //use cache to only target new/changed files, then optimize the images
    .pipe(gulp.dest(imgDest));

});


/* 

SCRIPTS
=======
*/

var currentDate   = util.date(new Date(), 'dd-mm-yyyy HH:ss');
var pkg       = require('./package.json');
var banner      = '/*! <%= pkg.name %> <%= currentDate %> - <%= pkg.author %> */\n';

gulp.task('js', function() {

      gulp.src(
        [
          themeDir + '/js/src/jquery.js',
          themeDir + '/js/src/jquery.flexnav.js',
          themeDir + '/js/src/trunk.js',
          themeDir + '/js/src/scripts.js'
        ])
        .pipe(concat('all.js'))
        .pipe(uglify({preserveComments: false, compress: true, mangle: true}).on('error',function(e){console.log('\x07',e.message);return this.end();}))
        .pipe(header(banner, {pkg: pkg, currentDate: currentDate}))
        .pipe(gulp.dest(jsDest));
});


/*

PAGESPEED
=====

Notes:
   - This runs Google PageSpeed Insights just like here http://developers.google.com/speed/pagespeed/insights/
   - You can use Google Developer API key if you have one, see: http://goo.gl/RkN0vE

*/

gulp.task('pagespeed', pagespeed.bind(null, {
  url: 'http://' + projectName + '.fi',
  strategy: 'mobile'
}));


/*

WATCH
=====

Notes:
   - browserSync automatically reloads any files
     that change within the directory it's serving from
*/

gulp.task('setWatch', function() {
  global.isWatching = true;
});

gulp.task('watch', ['setWatch', 'browserSync'], function() {
  gulp.watch(sassSrc, ['sass']);
  gulp.watch(imgSrc, ['images']);
  gulp.watch(jsSrc, ['js', browserSync.reload]);
});


/* 

BUILD
=====
*/

gulp.task('build', function(cb) {
  runSequence('sass', 'images', cb);
});

/* 

DEFAULT
=======
*/

gulp.task('default', function(cb) {
    runSequence(
    'images',
    'sass',
    'browserSync',
    'watch',
    cb
    );
});" > "$HOME/Projects/$PROJECTNAME/gulpfile.js"
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
rm -rf .git
composer update
echo "${yellow}Updating .env (db credentials)...:${txtreset}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/YOUR_DEFAULT_DATABASE_USERNAME_HERE/g" .env
sed -i -e "s/database_password/YOUR_DEFAULT_DATABASE_PASSWORD_HERE/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.dev/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.dev/g" .env

# If you are using MAMP you may want to enable these:

# echo "${yellow}Installing wp-cli...:${txtreset}"
# curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# chmod +x wp-cli.phar
# mkdir wp-cli
# mv wp-cli.phar wp-cli/wp

# But if you are using vagrant, you should be using these:

echo "${yellow}Installing WordPress...:${txtreset}"
echo "path: wp
url: http://${PROJECTNAME}.dev

core install:
  admin_user: YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE
  admin_password: YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE
  admin_email: YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
  title: \"${PROJECTNAME}\"" > wp-cli.yml

# The command is following for MAMP:
#./wp-cli/wp core install

# These syntaxes are for vagrant:

echo "${yellow}Removing default WordPress posts...:${txtreset}"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp post delete 1 --force"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp post delete 2 --force"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp option update blogdescription ''"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp theme delete twentytwelve"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp theme delete twentythirteen"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp option update permalink_structure '/%postname%'"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp option update timezone_string 'Europe/Helsinki'"
echo "${yellow}Activating necessary plugins, mainly for theme development...:${txtreset}"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp plugin activate advanced-custom-fields"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp plugin activate wordpress-seo"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp plugin activate wp-last-login"
ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp plugin activate wp-nested-pages"
chmod 777 "$HOME/Projects/$PROJECTNAME/content"

## You can set up your users here - if you want, uncomment next lines
#####################################################################

#echo "${yellow}Setting up users...:${txtreset}"
#ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp user update admin --display_name=\"Your Company Ltd\""
#ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp user update admin --first_name=\"Your Company Ltd\""
#ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp user create user1 user1@yourcompanyltd.com --role=administrator --user_pass=somepass --first_name=John --last_name=Doe --display_name=John"
#ssh vagrant@10.1.2.3 "cd /var/www/$PROJECTNAME/;wp user create user2 user2@yourcompanyltd.com --role=administrator --user_pass=somepass --first_name=Marilyn --last_name=Manson --display_name=Marilyn"

echo "${yellow}Set up .htaccess for pretty urls...:${txtreset}"
echo "<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>

AddType font/ttf .ttf
AddType font/eot .eot
AddType font/otf .otf
AddType font/woff .woff

<FilesMatch \"\.(ttf|otf|eot|woff)$\">
    <IfModule mod_headers.c>
        Header set Access-Control-Allow-Origin "*"
    </IfModule>
</FilesMatch>" > .htaccess
chmod 777 .htaccess
echo "${yellow}Setting uploads permissions...:${txtreset}"
chmod -Rv 777 "$HOME/Projects/$PROJECTNAME/content/uploads"

echo "${yellow}Setting up package.json${txtreset}"
echo "{
  \"name\": \"$PROJECTNAME\",
  \"version\": \"1.0.0\",
  \"description\": \"$PROJECTNAME powered by wpstack-rolle + gulp\",
  \"author\": \"Your company (your@email.com)\",
  \"devDependencies\": {
    \"browser-sync\": \"*\",
    \"gulp\": \"*\",
    \"gulp-changed\": \"*\",
    \"gulp-imagemin\": \"*\",
    \"gulp-notify\": \"*\",
    \"gulp-sass\": \"*\",
    \"gulp-util\": \"*\",
    \"gulp-minify-css\": \"*\",
    \"gulp-autoprefixer\": \"*\",
    \"gulp-uglify\": \"*\",
    \"gulp-cache\": \"*\",
    \"gulp-concat\": \"*\",
    \"gulp-header\": \"*\",
    \"normalize-css\": \"*\",
    \"gulp-pixrem\": \"*\",
    \"require-dir\": \"*\",
    \"psi\": \"*\"
  },
  \"dependencies\": {
    \"backbone\": \"*\",
    \"jquery\": \"*\"
  }
}" > "$HOME/Projects/$PROJECTNAME/package.json"

echo "${yellow}Installing local node.js packages (may take a while)${txtreset}"
npm install
rm "$HOME/Projects/$PROJECTNAME/createproject.sh"
echo "${yellow}Initializing bitbucket repo...${txtreset}"
cd "$HOME/Projects/$PROJECTNAME"
git init
# If you are using MAMP instead of jolliest-vagrant, please comment out all but the last line:
echo "<VirtualHost *:80>

  ServerAdmin webmaster@$PROJECTNAME
  ServerName  $PROJECTNAME.dev
  ServerAlias www.$PROJECTNAME.dev
  DirectoryIndex index.html index.php
  DocumentRoot /var/www/$PROJECTNAME
  LogLevel warn
  ErrorLog  /var/www/$PROJECTNAME/error.log
  CustomLog /var/www/$PROJECTNAME/access.log combined

</VirtualHost>" > "$HOME/jolliest-vagrant/vhosts/$PROJECTNAME.dev.conf"
echo "${boldgreen}Added vhost, $PROJECTNAME.dev.conf added to vagrant sites-enabled.${txtreset}"
echo "${yellow}Reprovisioning vagrant...${txtreset}"
cd ~/jolliest-vagrant
vagrant provision
echo "${boldgreen}VM provisioned, local environment up and running.${txtreset}"
echo "${yellow}Updating hosts file...${txtreset}"
sudo -- sh -c "echo 10.1.2.3 ${PROJECTNAME}.dev >> /etc/hosts"
echo "${boldgreen}All done! Start coding at http://${PROJECTNAME}.dev!${txtreset}"
fi