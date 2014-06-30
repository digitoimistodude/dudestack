# Rolle's WP-Stack

I'm constantly developing my development workflow. Honestly, I think I've been through hundreds of articles, tools and scripts. Went with regular WordPress structure, different wp-configs and [Dandelion](https://github.com/scttnlsn/dandelion) for a long time, but realized in some point I have to get some sense to it all. Still too much hassle with setting up things.

I love [Bedrock](https://github.com/roots/bedrock), which is a is a modern WordPress stack that helps you get started with the best development tools and project structure. Bedrock contains the tools I've been already using, but more.

**You should modify things to your needs.**

## Why not just fork and go?

Despite the fact I love most of bedrock, I noticed there's some things I don't like. Maybe little things for you, but some things matter to me. And I just want everything to be _mine_.

* Stuff are in app/ by default. I prefer content/. It describes it better, since I'm not a programmer and developing WordPress themes or plugins (that's what I do) is not exactly programming in my mind.
* I mostly use WordPress in finnish language, so WPLANG must be set to fi
* Composer modifications, getting latest finnish WordPress from sv.wordpress.org.
* Automation. I mean composer create-project is awesome, but I want everything else automated as well when I start a new project

I assume you use and know these tools in your workflow:

- Sublime Text 3
- CodeKit
- Sequel Pro
- MAMP Pro
- GitHub for Mac
- Flow
- CodeBox
- Adobe Edge Inspect
- Capistrano
- Composer
- WordPress Cli
- Nginx

## createproject.sh

Creating a new project has a lot of configs to do. I wanted to automate some of it by creating a bash script. The script assumes:

- You are using staging server like customer.example.com and you store your customers' sites like customer.example.com/customerone. Your staging server user has proper permissions like making changes to /tmp
- You are using separate production server that may necessarily not have all the permissions like writing in /tmp dir
- You use MAMP Pro and Bitbucket
- Your project hostname is project.dev
- You use CodeKit2+, gulp or grunt
- WordPress dependencies are controlled by composer
- You feel comfy using bundle
- Your project's name is your customer's name and also the server's account name (can be easily changed per project though, like everything else in this stack)
- Executables are stored in your server's $HOME/bin
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

You also will need to edit define('WPLANG', 'fi'); unless you want to use finnish language.

## Getting started

1. This assumes your projects are in ~/Projects. You should make sure that folder exists. Or decide to use another folder, but then you need a lot of search&replace and using this would be quite pointless.
2. Run MAMP Pro server with project name as your server name
3. Clone this repo to your home directory by running `git clone git@github.com:ronilaukkarinen/wpstack-rolle.git ~/`
4. Make the bash script global `mv createproject.sh /usr/bin/createproject && sudo chmod +x /usr/bin/createproject`
5. Remember to edit createproject.sh and composer.json based on your own needs
6. Please do a lot of other editing if you need. It will eventually shape to the right form.

To start a project, run `createproject` and have fun.

## Requirements

* Basic knowledge of capistrano, bundle, gulp, bash scripting and composer and other possible tools like this
* Git
* PHP >= 5.3.2 (for Composer)
* Ruby >= 1.9 (for Capistrano)