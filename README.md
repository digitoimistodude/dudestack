# Dudestack
[![Packagist](https://img.shields.io/packagist/v/ronilaukkarinen/wpstack-rolle.svg?style=flat-square)](https://packagist.org/packages/ronilaukkarinen/dudestack) [![Build Status](https://img.shields.io/travis/digitoimistodude/dudestack.svg?style=flat-square)](https://travis-ci.org/digitoimistodude/dudestack)

Dudestack is a modern WordPress toolkit that helps you get started with the best development tools and project structure - just like [Bedrock](https://github.com/roots/bedrock).

The idea is to have just one command for starting the project. Saves 10 hours easily in each project start when *Dont-Repeat-Yourself* -stuff are fully automated! 

After setting up, you can start a new project just by running:

```` bash
createproject
````

**TL;DR:** You can test dudestack right away in just two minutes by following our [Air starter theme instructions](https://github.com/digitoimistodude/air#air-development).

## Table of contents

1. [Background](#background)
2. [How it's different, why should I use this?](#how-its-different-why-should-i-use-this)
3. [Features](#features)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Documentation](#documentation)
  1. [Starting a new project with createproject bash script](#starting-a-new-project-with-createproject-bash-script)
    1. [What createproject.sh does](#what-createprojectsh-does)
  2. [What you most probably need to edit in every project](#what-you-most-probably-need-to-edit-in-every-project)
  3. [Getting started](#getting-started)
  4. [Paid or Premium plugins](#paid-or-premium-plugins)
  5. [WP-CLI alias](#wp-cli-alias)

#### Background

We're constantly developing our development workflow. Honestly, we've been through hundreds of articles, tools and scripts. Went with regular WordPress structure, different wp-configs and [Dandelion](https://github.com/scttnlsn/dandelion) for a long time, but realized in some point we have to get some sense to it all. Setting up things should not be the most time consuming task when starting a new project.

We love [Bedrock](https://github.com/roots/bedrock), which is a is a modern WordPress stack that helps you get started with the best development tools and project structure. Bedrock contains the tools we've been already using, but more. In fact, we are proud to say that most of this stack is based on [Bedrock](https://github.com/roots/bedrock).

Like bedrock, dudestack saves you hours when starting a new project.

#### How it's different, why should I use this?

Well, this is mainly a toolbox for a web design/development agency for a local Finnish WordPress-company, [Digitoimisto Dude Oy](https://www.dude.fi) as well as backup purposes and to show off how we roll. You should use this **only** if you really like how we do things.

Despite the fact we love most of Bedrock, we noticed there are some things we don't like.

* Stuff were originally in `app/` by default, then in `web/`. We prefer `content/`, like it was `wp-content` for a reason. It describes it better, since we do not want this to be too programming-oriented, but more front end developer -friendly (for developing WordPress themes and functions)
* Composer modifications, for installing more packages, like Finnish based language packs etc. that are not originally part of Bedrock
* Automation. I mean composer's `create-project` is awesome, but we need more. You still need to do stuff after `create-project` and our `createproject` -starting script is designed for automating the rest.
* Baked in local server environment for Vagrant, native OS X (MAMP or homebrew LEMP)

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
 - Support for MAMP, LEMP and Vagrant development environments (mainly Vagrant supported for now)

## Requirements

* Basic knowledge about bash scripting, deployment with capistrano, npm packages, bundle, composer etc.
* Vagrant ([marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant)), but can be configured for MAMP or LEMP too (Docker in planning)
* Bitbucket account
* Unix-based OS (built for Mac OS X by default)
* Access to staging and production servers that supports sftp and git
* Projects located under $HOME/Projects
* Git
* PHP >= 5.6
* Ruby >= 2.2
* Perl

# Installation

1. Clone this repo to your ~/Projects directory
2. Go to dudestack directory and run setup script (`cd ~/Projects/dudestack && sh setup.sh`).
3. Edit `/usr/bin/createproject` to your needs. See [documentation](#documentation) and **[Getting started](#getting-started)**.

If you are using vagrant, you need to "pair" your machine with the VM (I presume you are already set up keypairs, if not, run without password: `ssh-keygen -t rsa`), marlin-vagrant example:

```shell
cat ~/.ssh/id_rsa.pub | ssh vagrant@10.1.2.4 'mkdir -p ~/.ssh && cat >> ~/.ssh/authorized_keys' && chmod -Rv 755 ~/.ssh && chmod 400 ~/.ssh/id_rsa
```

If you are starting from clean slate, better yet, run Bitbucket's tutorial [Set up SSH for Git](https://confluence.atlassian.com/display/BITBUCKET/Set+up+SSH+for+Git).

# Documentation
1. [Starting a new project with createproject bash script](#starting-a-new-project-with-createproject-bash-script)
  1. [What createproject.sh does](#what-createprojectsh-does)
2. [What you most probably need to edit in every project](#what-you-most-probably-need-to-edit-in-every-project)
3. [Getting started](#getting-started)
4. [Paid or Premium plugins](#paid-or-premium-plugins)

## Starting a new project with createproject bash script

Creating a new project has a lot of configs to do. We wanted to automate most of it by creating a bash script called `createproject.sh`. The script assumes:

- You are using staging server like customer.example.com and you store your customers' sites like customer.example.com/customerone. Your staging server user has proper permissions like making changes to /tmp
- You are using separate production server that may necessarily not have all the permissions like writing in /tmp dir
- You use [marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant) or MAMP Pro (MAMP needs extensive editing and testing, [marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant) works out of the box)
- Your repositories are stored in Bitbucket
- Your project hostname is project.dev
- You use gulp, grunt or CodeKit2+
- WordPress dependencies are controlled by composer
- Your project's name is your customer's name and also the server's account name (can be easily changed per project though, like everything else in this stack)
- Executables are stored in your server's $HOME/bin

### What createproject.sh does

When you run `createproject` it looks like this:

![createproject.sh](https://www.dude.fi/createproject.png "Screenshot")

1. First it runs `composer create-project` with dudestack settings
2. Installs default WordPress plugins and updates them
3. Creates MySQL repository automatically with project name (assumes by default that you have [marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant)) installed with default settings and paired with your host computer, for MAMP you'll need to edit createproject.sh and edit `YOURMAMPMYSQLPASSWORD`).
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
- You will need gulp or grunt, feel free to use [our devpackages - gulpfile and npm package settings etc.](https://github.com/digitoimistodude/devpackages) designed for this purpose

**Note:**
- This is a starter package without theme configs. We leave theme development up to you entirely. We have our own starter theme that can be used with dudestack, see [air](https://github.com/digitoimistodude/air).

## Getting started

1. Everything assumes your projects are in **~/Projects**. You should make sure that folder exists. You can also decide to use another folder, but then you need a lot of search&replace and using this would be quite pointless.
2. Run [marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant) (if you use MAMP Pro server, you need to edit createproject.sh accordingly)
3. Edit `createproject.sh` and `composer.json` based on your own needs.

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
        "type": "wordpress-muplugin",
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

In the similar manner you can add other plugins. I've covered with this almost every plugin we use.

When getting the new zip, I use this function in my `~/.bashrc`:

```shell
function plugin() { scp -r $@ 'username@yoursite.com:~/path/to/plugins/'; }
```

So with simple ssh-pairing (passwordless login), I can upload a plugin by simple command: `plugin gravityforms_1.8.20.5.zip` and then just change version and `composer update`. DRY, you see.

## WP-CLI alias

WP-Cli is included in dudestack per project within `composer.json` and won't work by default. You'll need this alias on your Mac or Linux `.bashrc` or `.bash_profile` file:

```shell
alias wp='ssh vagrant@10.1.2.4 "cd /var/www/"$(basename "$PWD")"; /var/www/"$(basename "$PWD")"/vendor/wp-cli/wp-cli/bin/wp"'
```

If you are using [marlin-vagrant](https://github.com/digitoimistodude/marlin-vagrant), please use IP address `10.1.2.4`, if [jolliest-vagrant](https://github.com/digitoimistodude/jolliest-vagrant), use `10.1.2.3`. After restarting Terminal or running `. ~/.bashrc` or `. ~/.bash_profile` you will be able to use `wp` command directly on your host machine without having to ssh into vagrant.

## Issues

Feel free to post any issue or question if you have one.
