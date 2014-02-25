# Rolle's WP-Stack

I'm constantly developing my development workflow. Honestly, I think I've been through hundreds of articles, tools and scripts. Went with regular WordPress structure, different wp-configs and [Dandelion](https://github.com/scttnlsn/dandelion) for a long time, but realized in some point I have to get some sense to it all. Still too much hassle with setting up things.

I love [Bedrock](https://github.com/roots/bedrock), which is a is a modern WordPress stack that helps you get started with the best development tools and project structure. Bedrock contains the tools I've been already using, but more.

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

## Getting started

1. This assumes your projects are in ~/Projects. You should make sure that folder exists.
2. Run MAMP Pro server with project name as your server name
3. Clone this repo to your home directory by running `git clone git@github.com:ronilaukkarinen/wpstack-rolle.git ~/`
4. Make the bash script global `mv createproject.sh /usr/bin/createproject && sudo chmod +x /usr/bin/createproject`

To use, run `createproject` and have fun.

## Requirements

* Git
* PHP >= 5.3.2 (for Composer)
* Ruby >= 1.9 (for Capistrano)