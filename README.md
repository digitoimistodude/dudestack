# Dudestack
[![Packagist](https://img.shields.io/packagist/v/ronilaukkarinen/dudestack.svg?style=flat-square)](https://packagist.org/packages/ronilaukkarinen/dudestack) [![Build Status](https://img.shields.io/travis/com/digitoimistodude/dudestack.svg?style=flat-square)](https://travis-ci.com/digitoimistodude/dudestack)

Dudestack is a modern WordPress toolkit that helps you get started with the best development tools and project structure - just like [Bedrock](https://github.com/roots/bedrock).

The idea is to have just one command for starting the project. Saves dozens of hours easily in each project start when DRY (*Dont-Repeat-Yourself*) stuff are fully automated!

After setting up, you can start a new project just by running:

```` bash
createproject
````

**TL;DR:** You can test dudestack right away in just two minutes by following our [Air starter theme instructions](https://github.com/digitoimistodude/air#air-development).

**Please note: The main focus of dudestack is on how it works for our company and staff. This means it may not work for you without tweaking. Please ask a question by addressing an [issue](https://github.com/digitoimistodude/dudestack/issues) if something goes south.**

## Documentation & guides

- See [Wiki](https://github.com/digitoimistodude/dudestack/wiki)
- Currently we have only comprehensive written tutorial In English and for [Windows (WSL)](https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development)

## Table of contents

1. [Background](#background)
2. [How it's different, why should I use this?](#how-its-different-why-should-i-use-this)
3. [Features](#features)
4. [Requirements](#requirements)
5. [Installation](#installation)
6. [Documentation](#documentation)
    1. [Starting a new project with createproject bash script](#starting-a-new-project-with-createproject-bash-script)
    2. [What createproject.sh does](#what-createprojectsh-does)
    3. [What you most probably need to edit in every project](#what-you-most-probably-need-to-edit-in-every-project)
    4. [Getting started](#getting-started)
    5. [Paid or Premium plugins](#paid-or-premium-plugins)
        1. [Advanced Custom Fields Pro](#advanced-custom-fields-pro)
        2. [Object Cache Pro](#object-cache-pro)
        3. [Polylang Pro](#polylang-pro)
        4. [Relevanssi](#relevanssi)
    6. [WP-CLI alias](#wp-cli-alias)
    7. [SEO Plugin](#seo-plugin)
    8. [Issues](#issues)

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
* Baked in local server environment settings for our [native macOS LEMP server](https://github.com/digitoimistodude/macos-lemp-setup)

## Features

 - HTTPS support
 - Designed for pure WordPress development
 - Fast and easy templates for development and deployment
 - Customizable bash script for creating new WordPress project automation
 - Automatic Github repo initialization
 - Automatic MySQL-database generation
 - Automatic Project-related host settings for development server
 - Cleaning default WordPress stuff with wp-cli
 - [Capistrano 3](http://capistranorb.com/) deployment templates bundled in bin/createproject.sh
 - [Composer](https://getcomposer.org/) to take care of WordPress installation and plugin dependencies and updates
 - [Dotenv](https://github.com/vlucas/phpdotenv)-environments for development, staging and production
 - Supports local LEMP ([macOS](https://github.com/digitoimistodude/macos-lemp-setup) / [Windows](https://github.com/digitoimistodude/windows-lemp-setup)) development environments

## Requirements

* [mkcert](https://github.com/FiloSottile/mkcert)
* [Composer](https://getcomposer.org/) v2
* Basic knowledge about bash scripting, deployment with capistrano, npm packages, bundle, composer etc.
* Local server environment [macos-lemp](https://github.com/digitoimistodude/macos-lemp-setup). Can possibly be configured for MAMP or even Docker (we have no experience or support for 3rd party environments).
* GitHub account
* Unix-based OS or Windows [WSL](https://docs.microsoft.com/en-us/windows/wsl/install-win10)
* Optional: Access to staging and production servers that supports sftp and git
* Projects located under $HOME/Projects
* Git
* PHP >= 7.2
* Ruby >= 2.6
* Perl

# Installation

1. Install prequisites, `xcode-select --install` and [homebrew](https://brew.sh/) with latest updates
2. Install latest [Composer](https://getcomposer.org/) and [mkcert](https://github.com/FiloSottile/mkcert)
3. Clone this repo to your ~/Projects directory, `mkdir -p ~/Projects && cd ~/Projects && git clone https://github.com/digitoimistodude/dudestack`
4. Go to dudestack directory and run setup script (`cd ~/Projects/dudestack/bin && bash macos.sh`, or wsl.sh if you use Windows etc.).

# Documentation
## Starting a new project with createproject bash script

Creating a new project has a lot of configs to do. We wanted to automate most of it by creating a bash script called `createproject.sh`. The script assumes:

- You are using staging server like customer.example.com and you store your customers' sites like customer.example.com/customerone. Your staging server user has proper permissions like making changes to /tmp
- You are using separate production server that may necessarily not have all the permissions like writing in /tmp dir
- You use [native macOS LEMP](https://github.com/digitoimistodude/macos-lemp-setup)
- Your repositories are stored in GitHub
- Your project hostname is project.test
- You are fine with gulp, npm and webpack
- WordPress dependencies are controlled by composer

### What createproject.sh does

When you run `createproject` it looks like this:

![createproject.sh](https://www.dude.fi/createproject.png "Screenshot")

1. First it runs `composer create-project` with dudestack settings
2. Installs our default WordPress plugins and updates them
3. Creates MySQL repository automatically with project name (assumes by default that you have [macos-lemp](https://github.com/digitoimistodude/macos-lemp-setup) installed)
4. Installs capistrano deployment tool
5. Generates default capistrano configs (config/deploy.rb, config/deploy/staging.rb, config/deploy/production.rb) with your GitHub project details and paths
6. Sets up WordPress configs (wp-config credentials to .env) and salts automatically
7. Installs WordPress under its own subdirectory /wp (thus, admin located in example.test/wp/wp-admin)
8. Sets up default admin user as not "admin" for security (extra users can be configured in bin/createproject.sh)
9. Removes default WordPress posts, themes and plugins and everything else not so useful
10. Activates default plugins, timezones, permalinks
11. Flushes rewrites, adds support for permalinks and webfonts
12. Sets up file permissions
13. Inits a GitHub repository
14. Creates a HTTPS certificate
15. Sets up a virtual host for development environment
16. Updates /etc/hosts file
17. Restarts development server

### What you most probably need to edit in every project

- After running `createproject` you should run newtheme.sh under [air-light](https://github.com/digitoimistodude/air-light)/bin. This will generate the WordPress theme and import latest [devpackages](https://github.com/digitoimistodude/devpackages) that contain gulp, stylelint, webpack, etc. for modern WordPress Theme development
- To release your project staging/production: Production server SSH-credentials and paths in config/deploy/production.rb because they are usually different in every project. If you have the same directory structure on your servers, you can edit bin/createproject.sh so you don't repeat yourself in every project.
- You will need gulp or grunt so if you are not using our starter theme [air-light](https://github.com/digitoimistodude/air-light), feel free to use [our devpackages - gulpfile and npm package settings etc.](https://github.com/digitoimistodude/devpackages) designed for this purpose

**Please note:**
- Dudestack is only a starter package without ANY theme configs. We leave theme development up to you entirely. We have our own starter theme that can be used with dudestack, see [air-light](https://github.com/digitoimistodude/air-light).

## Getting started

1. Everything assumes your projects are in **~/Projects**. You should make sure that folder exists. You can also decide to use another folder, but then you need a lot of search&replace and using this would be quite pointless.
2. Run [macos-lemp-stack](https://github.com/digitoimistodude/macos-lemp-setup#) (if you use other development environment like MAMP Pro server, you need to edit bin/createproject.sh accordingly. **We don't provide support for all environments**)
3. Edit `createproject.sh` and `composer.json` based on your own needs.

To start a new project, run `createproject` and have fun.

## Paid or Premium plugins

Edit your `composer.json` and add these lines inside respository, separated by commas:

### Advanced Custom Fields Pro

As per [pivvenit/acf-composer-bridge](https://github.com/pivvenit/acf-composer-bridge), add to "repositories" section:

```json
    {
      "type": "composer",
      "url": "https://pivvenit.github.io/acf-composer-bridge/composer/v3/wordpress-plugin/"
    },
```

Then to "requires":

```json
    "advanced-custom-fields/advanced-custom-fields-pro": "*",
```

### Gravity Forms

As per [gtap-dev/gravityforms-composer-installer](https://github.com/gtap-dev/gravityforms-composer-installer), add to "repositories" section (remember to update to the latest version from [here](https://docs.gravityforms.com/gravityforms-change-log/)):

```json
{
  "type": "package",
  "package": {
    "name": "gravityforms/gravityforms",
    "version": "2.5.14.3",
    "type": "wordpress-plugin",
    "dist": {
      "type": "zip",
      "url": "https://www.gravityhelp.com/wp-content/plugins/gravitymanager/api.php?op=get_plugin&slug=gravityforms&key={%WP_PLUGIN_GF_KEY}"
    },
    "require": {
      "composer/installers": "^1.4",
      "gotoandplay/gravityforms-composer-installer": "^2.3"
    }
  }
},
```

Then to "requires":

```json
    "gravityforms/gravityforms": "*",
```

### Object Cache Pro

You will need Redis and PHP Redis installed in order to install this package.

Add to "repositories":

```json
{
  "type": "composer",
  "url": "https://xxx-organization-xxx:xxx-token-xxx@rhubarbgroup.repo.packagist.com/xxx-organization-xxx/"
}
```

Then to "requires":

```json
"rhubarbgroup/object-cache-pro": "^1.13.0"
```

### Relevanssi

Add to "repositories":

```json
{
      "type": "package",
      "package": {
        "name": "relevanssi/relevanssi-premium",
        "version": "2.15",
        "type": "wordpress-plugin",
        "dist": {
          "type": "zip",
          "url": "https://www.relevanssi.com/update/get_version.php?api_key=xxx&version=2.15"
        }
      }
    },
```

Then to "requires":

```json
    "relevanssi/relevanssi-premium": "2.15",
```

### Polylang Pro (and others that don't have a repo)

Add to "repositories":

```json
,
    {
      "type": "package",
      "package": {
        "name": "polylang/polylang-pro",
        "type": "wordpress-plugin",
        "version": "2.7.4",
        "dist": {
          "type": "zip",
          "url": "https://xxxxxxxxx:xxxxxxxx@plugins.dude.fi/polylang-pro_2.7.4.zip"
        }
      }
    },
```

Then to "requires":

```json
    "polylang/polylang-pro": "2.7.4",
```

In the similar manner you can add other paid plugins that don't have composer repository. We've covered with this almost every such plugin we use.

When getting the new zip, I use this function in my `~/.bashrc`:

```shell
function plugin() { scp -r $@ 'username@yoursite.com:~/path/to/plugins/'; }
```

So with simple ssh-pairing (passwordless login), I can upload a plugin by simple command: `plugin gravityforms_1.8.20.5.zip` and then just change version and `composer update`. DRY, you see.

## WP-CLI alias

WP-Cli is included in dudestack per project via `composer.json` and won't work by default globally. You'll need this alias on your Mac or Linux `.bashrc` or `.bash_profile` file:

```shell
alias wp='./vendor/wp-cli/wp-cli/bin/wp'
```

## SEO Plugin

Our default choice for the SEO plugin is [The SEO Framework](https://wordpress.org/plugins/autodescription/) whihc is nice, clean and simple solution that suits most of the projects.

In case client is familiar with Yoast, requests it or the project is blog-centric, switching to Yoast SEO is possible. In that case, replace the `wpackagist-plugin/autodescription` package in `composer.json` with `wpackagist-plugin/wordpress-seo`. It's also highly recommended to install `wpackagist-plugin/so-clean-up-wp-seo` to clean the bloat from UI.

## Issues

Feel free to post any issue or question if you have one.
