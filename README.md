# Rolle's WP-Stack

I'm constantly developing my development workflow. Honestly, I think I've been through hundreds of articles, tools and scripts. Went with regular WordPress structure, different wp-configs and [Dandelion](https://github.com/scttnlsn/dandelion) for a long time, but realized in some point I have to get some sense to it all. Still too much hassle with setting up things.

I love [Bedrock](https://github.com/roots/bedrock), which is a is a modern WordPress stack that helps you get started with the best development tools and project structure. Bedrock contains the tools I've been already using, but more.

At best this wpstack saves you hours when starting a new project.

**You should modify things to your needs.**

## Features

 - Designed for pure WordPress development
 - Fast and easy templates for development and deployment
 - Gulp template with various magical gulp pieces and [BrowserSync](http://www.browsersync.io/)
 - Customizable bash script for creating new WordPress projects
 - Automatic MySQL-database generation
 - Cleaning default WordPress stuff with wp-cli
 - [Compass](http://compass-style.org) with [libsass (gulp-sass)](https://github.com/dlmanning/gulp-sass)
 - [Capistrano 3](http://capistranorb.com/) deployment templates bundled in createproject.sh
 - [Composer](https://getcomposer.org/) to take care of WordPress installation and plugin dependencies and updates
 - [Dotenv](https://github.com/vlucas/phpdotenv)-environments for development, staging and production
 - MAMP and vagrant support

## How it's different, why should I use this?

Well, this is mainly for myself for backup purposes or to show off how I roll. You should use this if you really like how I do things.

Despite the fact I love most of bedrock, I noticed there's some things I don't like. Maybe little things for you, but some things matter to me. And I just want everything to be _mine_.

* Stuff are in app/ by default. I prefer content/. It describes it better, since I'm not a programmer and developing WordPress themes or plugins (that's what I do) is not exactly programming in my mind.
* Composer modifications, getting latest finnish WordPress from sv.wordpress.org.
* Automation. I mean composer create-project is awesome, but I want everything else automated as well when I start a new project

# Installation 

1. Clone this repo to your home directory
2. Make the bash script global by `sudo cp ~/wpstack-rolle/createproject.sh /usr/bin/createproject && sudo chmod +x /usr/bin/createproject`
3. Edit createproject.sh with your favourite editor. For Sublime Text, use `subl ~/wpstack-rolle/createproject.sh`
4. Start tuning up to your needs. See instructions and **Getting started** below.

If you are using [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant), you need to "pair" your machine with the VM (I presume you are already set up keypairs, if not, run without password: `ssh-keygen -t rsa`):

    cat ~/.ssh/id_rsa.pub | ssh vagrant@10.1.2.3 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' && chmod -Rv 755 ~/.ssh && chmod 400 ~/.ssh/id_rsa

## createproject.sh

Creating a new project has a lot of configs to do. I wanted to automate most of it by creating a bash script. The script assumes:

- You are using staging server like customer.example.com and you store your customers' sites like customer.example.com/customerone. Your staging server user has proper permissions like making changes to /tmp
- You are using separate production server that may necessarily not have all the permissions like writing in /tmp dir
- You use MAMP Pro or [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant)
- Your repositories are stored in Bitbucket
- Your project hostname is project.dev
- You use CodeKit2+, gulp or grunt
- WordPress dependencies are controlled by composer
- You feel comfy using bundle
- Your project's name is your customer's name and also the server's account name (can be easily changed per project though, like everything else in this stack)
- Executables are stored in your server's $HOME/bin

Note:
~~- If you are using gulp, you should check out [my gulpfile](https://github.com/ronilaukkarinen/gulpfile-rolle)~~ Gulpfile generator is now integrated in createproject.sh
- This is a starter package without theme configs. I leave theme development up to you entirely. I have my own starter theme that relies on this package but I'm not (yet) willing to share it
- You are accepting the fact this is only one of the ways to do things and things are not staying this way forever, everything changes as you read this :)

**This needs rough editing, so please copy createproject.sh to desired path and modify to your needs!**

To use, please edit all the caps written information in the file (don't touch variables, like $PROJECTNAME!), like these:
 - YOUR_BITBUCKET_ACCOUNT_HERE
 - YOUR_STAGING_USERNAME_HERE
 - YOUR_STAGING_SERVER_HERE
 - YOUR_STAGING_SERVER_PASSWORD_HERE
 - YOUR_STAGING_SERVER_HOME_PATH_HERE
 - PATH_TO_STAGING_BIN_COMPOSER
 - STAGING_HOME_BIN_PATH
 - YOUR_PRODUCTION_SERVER_HERE
 - YOUR_PRODUCTION_SERVER_PASSWORD_HERE
 - YOUR_DEFAULT_DATABASE_USERNAME_HERE
 - YOUR_DEFAULT_DATABASE_PASSWORD_HERE
 - YOUR_DEFAULT_WORDPRESS_ADMIN_USERNAME_HERE
 - YOUR_DEFAULT_WORDPRESS_ADMIN_PASSWORD_HERE
 - YOUR_DEFAULT_WORDPRESS_ADMIN_EMAIL_HERE
 - YOUR_BITBUCKET_USERNAME_HERE

## Getting started

1. This assumes your projects are in ~/Projects. You should make sure that folder exists. Or decide to use another folder, but then you need a lot of search&replace and using this would be quite pointless.
2. Run MAMP Pro server or [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant)
3. Remember to edit createproject.sh and composer.json based on your own needs
4. Please do a lot of other editing if you need. It will eventually shape to the right form.

To start a project, run `createproject` and have fun.

## Paid or Premium plugins

Edit your `composer.json` and add these lines inside respository, separated by commas:

### Advanced Custom Fields Pro

    {
      "type": "package",
      "package": {
        "name": "advanced-custom-fields/advanced-custom-fields-pro",
        "version": "5.0",
        "type": "wordpress-plugin",
        "dist": {
          "type": "zip",
          "url": "YOUR_DOWNLOAD_URL (get it from ACF website)"
        }
      }
    }

### WPML

    {
      "type": "package",
      "package": {
        "name": "wpml/sitepress-multilingual-cms",
        "type": "wordpress-plugin",
        "version": "3.1.8.4",
        "dist": {
          "type": "zip",
          "url": "YOUR_DOWNLOAD_URL (get it from WPML website)"
        }
      }
    }

### Gravity Forms

Gravityforms and some other plugins have urls that expire after some time, so to not having always get the url after new version, use your own private plugin repository to store zip files on remote server with basic HTTP auth and add package like this:

      {
        "type": "package",
        "package": {
          "name": "gravityforms",
          "type": "wordpress-plugin",
          "version": "1.8.20.5",
          "dist": {
            "type": "zip",
            "url": "http://YOURUSERNAME:YOURPASSWORD@www.yoursite.com/path/to/plugins/gravityforms_1.8.20.5.zip"
          }
        }
      }

In the similar manner you can add other plugins. I've covered with this almost every plugin I use.

When getting the new zip, I use this function in my `~/.bashrc`:

    function plugin() { scp -r $@ 'username@yoursite.com:~/path/to/plugins/'; }

So with simple ssh-pairing (passwordless login), I can upload a plugin by simple command: `plugin gravityforms_1.8.20.5.zip` and then just change version and `composer update`. DRY, you see.

## Requirements

* Basic knowledge of capistrano, bundle, gulp, bash scripting and composer and other possible tools like this
* Git
* PHP >= 5.3.2 (for Composer)
* Ruby >= 1.9 (for Capistrano)
