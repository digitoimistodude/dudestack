# Dudestack
## Tools for modern WordPress development

Dudestack is a modern WordPress stack that helps you get started with the best development tools and project structure - just like [Bedrock](https://github.com/roots/bedrock).

#### Background

I'm constantly developing my development workflow. Honestly, I think I've been through hundreds of articles, tools and scripts. Went with regular WordPress structure, different wp-configs and [Dandelion](https://github.com/scttnlsn/dandelion) for a long time, but realized in some point I have to get some sense to it all. Setting up things should not be the most time consuming task when starting a new project.

I love [Bedrock](https://github.com/roots/bedrock), which is a is a modern WordPress stack that helps you get started with the best development tools and project structure. Bedrock contains the tools I've been already using, but more. In fact, I'm proud to say that most of this stack is based on [Bedrock](https://github.com/roots/bedrock).

Like bedrock, dudestack saves you hours when starting a new project.

#### How it's different, why should I use this?

Well, this is mainly for myself for backup purposes or to show off how I roll. You should use this if you really like how I do things.

Despite the fact I love most of bedrock, I noticed there's some things I don't like. Maybe little things for you, but some things matter to me. And I just want everything to be _mine_.

* Stuff are in app/ by default. I prefer content/. It describes it better, since I'm not a programmer and developing WordPress themes or plugins (that's what I do) is not exactly programming in my mind.
* Composer modifications, getting latest finnish WordPress from sv.wordpress.org.
* Automation. I mean composer's `create-project` is awesome, but I need more. You still need to do stuff after `create-project` and my createproject.sh is for designed for automating the rest.

**You should modify things to your needs. Please note: This is not in any way tested with other people or or in different environments. Yet. Please address an issue if something goes south.** 

## Features

 - Designed for pure WordPress development
 - Fast and easy templates for development and deployment
 - Customizable bash script for creating new WordPress projects
 - Automatic MySQL-database generation
 - Automatic Bitbucket repo initializition
 - Automatic Project-related host settings for vagrant
 - Cleaning default WordPress stuff with wp-cli
 - [Capistrano 3](http://capistranorb.com/) deployment templates bundled in createproject.sh
 - [Composer](https://getcomposer.org/) to take care of WordPress installation and plugin dependencies and updates
 - [Dotenv](https://github.com/vlucas/phpdotenv)-environments for development, staging and production
 - Support for MAMP and vagrant development environments

## Requirements

* Basic knowledge about bash scripting, deployment with capistrano, npm packages, bundle, composer etc.
* Vagrant ([jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant)), but can be configured for MAMP too
* Bitbucket account
* Unix-based OS (built for Mac OS X by default)
* Access to staging and production servers that supports sftp and git
* Projects located under $HOME/Projects
* Git
* PHP >= 5.3.2
* Ruby >= 1.9

# Installation 

1. Clone this repo to your home directory
2. Go to dudestack directory (`cd ~/dudestack && sh setup.sh`)
4. Edit `/usr/bin/createproject` to your needs. See instructions and **Getting started** below.

If you are using [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant), you need to "pair" your machine with the VM (I presume you are already set up keypairs, if not, run without password: `ssh-keygen -t rsa`):

```shell
cat ~/.ssh/id_rsa.pub | ssh vagrant@10.1.2.3 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' && chmod -Rv 755 ~/.ssh && chmod 400 ~/.ssh/id_rsa
```

If you are starting from clean slate, better yet, run Bitbucket's tutorial for [Set up SSH for Git](https://confluence.atlassian.com/display/BITBUCKET/Set+up+SSH+for+Git).

# Documentation 
1. [Starting a new project with createproject bash script](#starting-a-new-project-with-createproject-bash-script)
  1. [What createproject.sh does](#what-createprojectsh-does)
2. [What you most probably need to edit in every project](#what-you-most-probably-need-to-edit-in-every-project)
3. [Getting started](#getting-started)
4. [Paid or Premium plugins](#paid-or-premium-plugins)

## Starting a new project with createproject bash script

Creating a new project has a lot of configs to do. I wanted to automate most of it by creating a bash script called `createproject.sh`. The script assumes:

- You are using staging server like customer.example.com and you store your customers' sites like customer.example.com/customerone. Your staging server user has proper permissions like making changes to /tmp
- You are using separate production server that may necessarily not have all the permissions like writing in /tmp dir
- You use [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant) or MAMP Pro
- Your repositories are stored in Bitbucket
- Your project hostname is project.dev
- You use gulp, grunt or CodeKit2+
- WordPress dependencies are controlled by composer
- Your project's name is your customer's name and also the server's account name (can be easily changed per project though, like everything else in this stack)
- Executables are stored in your server's $HOME/bin

### What createproject.sh does

1. First it runs `composer create-project` with dudestack settings
2. Installs default WordPress plugins and updates them
3. Creates MySQL repository automatically with project name (assumes by default that you have [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant)) installed with default settings and paired with your host computer, for MAMP you'll need to edit createproject.sh and edit `YOURMAMPMYSQLPASSWORD`)
4. Installs capistrano
5. Generates capistrano configs (config/deploy.rb, config/deploy/staging.rb, config/deploy/production.rb) with your bitbucket details and paths
6. Creates a Sublime Text 3 project
7. Sets up WordPress configs and salts automatically
8. Installs WordPress under its own subdirectory /wp (thus, admin located in example.dev/wp/wp-admin)
9. Sets up default admin user (extra users can be configured in createproject.sh)
10. Removes default WordPress posts, themes and plugins
11. Activates default plugins, timezones, permalinks
12. Updates .htaccess, adds support for mod_rewrite/permalinks and webfonts
13. Sets up file permissions
14. Inits bitbucket repository
15. Sets up a vagrant virtual host
16. Updates /etc/hosts file

### What you most probably need to edit in every project

- Production server SSH-credentials and paths in config/deploy/production.rb because they are usually different in every project. If you have the same directory structure on your servers, you can edit createproject.sh so you don't repeat yourself in every project.
- You will need gulp or grunt, feel free to use [my gulpfile and npm package settings](https://github.com/ronilaukkarinen/gulpfile-rolle) designed for this purpose

**Note:**
- This is a starter package without theme configs. I leave theme development up to you entirely. I have my own starter theme that relies on this package but I'm not (yet) willing to share it
- You are accepting the fact this is only one of the ways to do things and things are not staying this way forever, everything changes as you read this :)

## Getting started

1. This assumes your projects are in ~/Projects. You should make sure that folder exists. You can also decide to use another folder, but then you need a lot of search&replace and using this would be quite pointless.
2. Run [jolliest-vagrant](https://github.com/ronilaukkarinen/jolliest-vagrant) (if you use MAMP Pro server, you need to edit createproject.sh accordingly)
3. Edit `createproject.sh` and `composer.json` based on your own needs
4. Please do a lot of other editing if you need. It will eventually shape to the right form.
5. **Optional**: Get gulpfile.js and package.json from [devpackages](https://github.com/ronilaukkarinen/devpackages), edit them to your needs, run `npm install && npm-check-updates -u && npm update && gulp watch` and start developing your theme/plugin.

To start a new project, run `createproject` and have fun.

## Paid or Premium plugins

Edit your `composer.json` and add these lines inside respository, separated by commas:

### Advanced Custom Fields Pro

```json
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
```

### WPML

```json
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
```

### Gravity Forms

Gravityforms and some other plugins have urls that expire after some time, so to not having always get the url after new version, use your own private plugin repository to store zip files on remote server with basic HTTP auth and add package like this:

```json
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
```

In the similar manner you can add other plugins. I've covered with this almost every plugin I use.

When getting the new zip, I use this function in my `~/.bashrc`:

```shell
function plugin() { scp -r $@ 'username@yoursite.com:~/path/to/plugins/'; }
```

So with simple ssh-pairing (passwordless login), I can upload a plugin by simple command: `plugin gravityforms_1.8.20.5.zip` and then just change version and `composer update`. DRY, you see.

Feel free to post any issue or question if you are actually using this...