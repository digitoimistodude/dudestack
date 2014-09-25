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

# Comment this out after editing this file:
while true; do
read -p "${boldyellow}Edited this file (createproject.sh) to your needs with your credentials etc. (OTHERWISE THIS SCRIPT WON'T WORK)? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done

while true; do
read -p "${boldyellow}MAMP properly set up and running? (y/n)${txtreset} " yn
    case $yn in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "Please answer y or n.";;
    esac
done

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
/Applications/MAMP/Library/bin/mysql -u root -p -e "create database ${PROJECTNAME}"
echo "${boldgreen}MySQL database created${txtreset}"
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
SSHKit.config.command_map[:composer] = \"PATH_TO_STAGING_BIN_COMPOSER\"
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
    
  desc \"Set up symlinks\"
    task :finished do
        on roles(:app) do

            execute \"mkdir -p /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/content && ln -nfs #{current_path}/content /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/content\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/index.php && ln -nfs #{current_path}/index.php /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/index.php\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/wp-config.php && ln -nfs #{current_path}/wp-config.php /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/wp-config.php\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/wp && ln -nfs #{current_path}/wp /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/wp\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/vendor && ln -nfs #{current_path}/vendor /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/vendor\"
            execute \"rm -f /YOUR_STAGING_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/config && ln -nfs #{current_path}/config /YOUR_SERVER_HOME_PATH_HERE/public_html/#{fetch(:application)}/config\"

        end
    end

    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                execute \"mkdir -p STAGING_HOME_BIN_PATH && curl -sS https://getcomposer.org/installer | php && mv composer.phar PATH_TO_STAGING_BIN_COMPOSER && chmod +x PATH_TO_STAGING_BIN_COMPOSER\"
                execute 'composer', 'update'
                execute 'composer', 'install', '--no-dev', '--optimize-autoloader'
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

set :deploy_to, \"/home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/deploy/\"
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3
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

            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/content && ln -nfs #{current_path}/content /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/content\"
            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/index.php && ln -nfs #{current_path}/index.php /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/index.php\"
            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/wp-config.php && ln -nfs #{current_path}/wp-config.php /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/wp-config.php\"
            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/wp && ln -nfs #{current_path}/wp /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/wp\"
            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/vendor && ln -nfs #{current_path}/vendor /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/vendor\"
            execute \"rm -f /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/config && ln -nfs #{current_path}/config /home/#{fetch(:application)}/sites/#{fetch(:application)}.fi/public_html/config\"

        end
    end


    desc 'composer install'
    task :composer_install do
        on roles(:app) do
            within release_path do
                execute \"mkdir -p /home/#{fetch(:application)}/bin/ && curl -sS https://getcomposer.org/installer | php && mv composer.phar /home/#{fetch(:application)}/bin/composer && chmod +x /home/#{fetch(:application)}/bin/composer\"
                execute 'composer', 'update'
                execute 'composer', 'install', '--no-dev', '--optimize-autoloader'
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
echo "${yellow}Setting up compass${txtreset}"
echo "require 'breakpoint';
require 'sassy-buttons';

preferred_syntax = :scss
http_path = '/'
css_dir = 'content/themes/$PROJECTNAME/css'
sass_dir = 'content/themes/$PROJECTNAME/sass'
images_dir = 'content/themes/$PROJECTNAME/images'
fonts_dir = 'content/themes/$PROJECTNAME/fonts'
relative_assets = true
output_style = :compressed
line_comments = false
color_output = false" > "$HOME/Projects/$PROJECTNAME/config.rb"
echo "${yellow}Setting up package.json${txtreset}"
echo "{
  \"name\": \"$PROJECTNAME\",
  \"version\": \"1.0.0\",
  \"description\": \"$PROJECTNAME powered by wpstack-rolle + gulp\",
  \"author\": \"Digitoimisto Dude Oy (moro@dude.fi)\",
  \"devDependencies\": {
    \"browser-sync\": \"~0.8.2\",
    \"gulp\": \"^3.8.0\",
    \"gulp-changed\": \"^0.4.1\",
    \"gulp-imagemin\": \"^0.6.2\",
    \"gulp-notify\": \"^1.4.2\",
    \"gulp-ruby-sass\": \"^0.7.1\",
    \"gulp-compass\": \"^1.2.0\",
    \"gulp-util\": \"^3.0.0\",
    \"gulp-minify-css\": \"0.3.7\",
    \"gulp-autoprefixer\": \"0.0.8\",
    \"gulp-uglify\": \"0.3.1\",
    \"gulp-cache\": \"0.2.0\",
    \"gulp-concat\": \"2.3.4\",
    \"gulp-header\": \"1.1.1\",
    \"normalize-css\": \"2.3.1\",
    \"gulp-pixrem\": \"^0.1.1\",
    \"require-dir\": \"^0.1.0\",
    \"psi\": \"^0.1.2\"
  },
  \"dependencies\": {
    \"backbone\": \"~1.1.2\",
    \"jquery\": \"~2.1.0\"
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
var sass        = require('gulp-ruby-sass');
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
    '**/*.php'
    ];

    browserSync.init(files, {
    proxy: localURL,
    host: hostname,
    agent: false,
    browser: \"firefox\"
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
rm -rf .git
composer update
echo "${yellow}Updating .env (db credentials)...:${txtreset}"
sed -i -e "s/database_name/${PROJECTNAME}/g" .env
sed -i -e "s/database_user/YOUR_DEFAULT_DATABASE_USERNAME_HERE/g" .env
sed -i -e "s/database_password/YOUR_DEFAULT_DATABASE_PASSWORD_HERE/g" .env
sed -i -e "s/database_host/localhost/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.dev/g" .env
sed -i -e "s/example.com/${PROJECTNAME}.dev/g" .env
echo "${yellow}Installing wp-cli...:${txtreset}"
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mkdir wp-cli
mv wp-cli.phar wp-cli/wp
echo "${yellow}Installing WordPress...:${txtreset}"
echo "path: wp
url: http://${PROJECTNAME}.dev

core install:
  admin_user: YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE
  admin_password: YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE
  admin_email: YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
  title: \"${PROJECTNAME}\"" > wp-cli.yml
./wp-cli/wp core install
echo "${yellow}Removing default WordPress posts...:${txtreset}"
./wp-cli/wp post delete 1 --force
./wp-cli/wp post delete 2 --force
./wp-cli/wp option update blogdescription ''
./wp-cli/wp theme delete twentytwelve
./wp-cli/wp theme delete twentythirteen
./wp-cli/wp option update permalink_structure '/%postname%'
./wp-cli/wp option update timezone_string 'Europe/Helsinki'
echo "${yellow}Activating necessary plugins, mainly for theme development...:${txtreset}"
./wp-cli/wp plugin activate advanced-custom-fields
./wp-cli/wp plugin activate wordpress-seo
chmod 777 "$HOME/Projects/$PROJECTNAME/content"
./wp-cli/wp plugin activate ewww-image-optimizer
echo "${yellow}Set up .htaccess for pretty urls...:${txtreset}"
echo "<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>" > .htaccess
chmod 777 .htaccess
echo "${yellow}Setting uploads permissions...:${txtreset}"
chmod -Rv 777 "$HOME/Projects/$PROJECTNAME/content/uploads"
echo "${boldgreen}All done! Start coding at http://${PROJECTNAME}.dev! Remember to make a repo on Bitbucket, eventually.${txtreset}"