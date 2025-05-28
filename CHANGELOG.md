### 2.5.6: 2025-05-28

* Fix build, update CI workflow ubuntu to ubuntu-22.04

### 2.5.5: 2025-04-30

* Add Dude ASCII art logo to scripts
* Fix version number not outputting properly
* Bump WordPress to 6.8.0

### 2.5.4: 2025-03-25

* Fix --existing flag throws error when not inside the repo, Fixes D-16

### 2.5.3: 2025-01-24

* Add ACF Content Analysis for Yoast SEO plugin (T-23997)

### 2.5.2: 2025-01-15

* Fix mistake in exporting createproject script version number

### 2.5.1: 2025-01-09

* Bump WordPress to 6.7.1
* Change from wpackagist-plugin/so-clean-up-wp-seo to digitoimistodude/so-clean-up-wp-seo

### 2.5.0: 2024-12-12

* Fix illegal option errors in `--existing` flag of the createproject script
* Include dudestack version and date in start in the macos version of the createproject script

### 2.4.9: 2024-11-18

* Add checks to commands and symlinks
* Bump WordPress to 6.6.2
* Fix mkcert installation for macOS
* Remove the deactivation of gravity-forms-wcag-20-form-fields
* Bump WordPress to 6.7.0

### 2.4.8: 2024-06-25

* Fix fatal error with unexisting function countPlugins()
* Bump WordPress to 6.5.5

### 2.4.7: 2024-06-20

* Update bedrock-autoloader.php
* Remove wrong option from Redis config

### 2.4.6: 2024-06-20

* Use High performance Redis settings by default

### 2.4.5: 2024-06-11

* Remove Koko Analytics and WCAG 2.0 form fields for Gravity Forms from default plugins
* Remove vagrant keyword
* Bump WordPress to 6.5.4

### 2.4.4: 2024-05-03

* Fix check for existing if the project is found on GitHub

### 2.4.3: 2024-05-02

* Bump composer.json PHP from 8.2 to 8.3

### 2.4.2: 2024-04-19

* Re-add missing wpackagist-plugin/query-monitor back to require-dev

### 2.4.1: 2024-04-17

* Ensure php.conf exists

### 2.4.0: 2024-04-16

* Add self-updater

### 2.3.9: 2024-04-15

Please note: This version contains breaking change, if you are using older macos-lemp-setup and still have PHP 7.4 installed.

* Add PHP 8.3 and macos-lemp-setup 1.0.8 support

### 2.3.8: 2024-04-03

* Remove leftover workflow

### 2.3.7: 2024-04-03

* Ensure $DIR_TO_FILE is set in createproject init
* Bump WordPress to 6.5
* Do not remove root phpcs.xml in cleanups
* Remove travis from cleanups

### 2.3.6: 2024-03-12

* Allow .editorconfig to be exported
* PHP 8.3 support
* Fix PHP_CodeSniffer rules for 8.3
* Add PHP_CodeSniffer and WPCS composer packages
* Add unit tests
* Fix implode() in bedrock Installer.php for PHP 8.3

### 2.3.5: 2024-02-23

* Remove wps

### 2.3.4: 2024-02-14

* Add two factor authentication to default plugins
* Bump WordPress to 6.4.3

### 2.3.3: 2024-01-18

* Add new http2 syntax for nginx vhosts

### 2.3.2: 2024-01-16

* Bump WordPress to 6.4.2
* Add tiny-compress-images and png-to-jpg to stack

### 2.3.1: 2023-12-04

* Fix a mysql cmd syntax regression presented in 2.2.8

### 2.3.0: 2023-12-04

* Add script support for Pop!_OS #16 (thanks @raikasdev!)

### 2.2.9: 2023-12-04

* Ensure initial branch is master

### 2.2.8: 2023-12-04

* Make mysql CREATE DATABASE command safer by adding IF NOT EXISTS + backslashes to cmd

### 2.2.7: 2023-09-12

* Start script --existing: Add link to remote media setup

### 2.2.6: 2023-09-12

* Bump WordPress to 6.3.1

### 2.2.5: 2023-05-17

* Make sure main branch is master with git commands
* Bump WordPress to 6.2.1

### 2.2.4: 2023-05-12

* Add .editorconfig
* Fix github doc link

### 2.2.3: 2023-05-09

* Add `"default_branch": "master"` to github API call

### 2.2.2: 2023-05-08

* Remove old unused gem dependencies

### 2.2.1: 2022-18-04

* Bump WordPress to 6.2.0
* Remove double variable in variables.sh
* Add support for --existing option in createproject script for macOS

### 2.2.0: 2022-12-05

* Add .env-e to cleanups
* Bump WordPress to 6.1.1

### 2.1.9: 2022-09-26

* Change SEO Framework to Yoast SEO + Hide SEO Bloat
* Bump WordPress to 6.0.2

### 2.1.8: 2022-06-29

* Add the newest version of wp-languages
* Remove imagify

### 2.1.7: 2021-04-19

* Activate all plugins on new project startup
* Deactivate certain non-production plugins by default

### 2.1.6: 2021-04-11

* Bump WordPress to 5.9.3

### 2.1.5: 2022-03-21

* Require devgeniem/wp-sanitize-accented-uploads since core's similar feature doesn't do enough

### 2.1.4: 2021-11-09

* Generate Diffie-Hellman 4096-bit key with less time

### 2.1.3: 2021-10-11

* Change .env default host back to localhost

### 2.1.2: 2021-08-24

* Remove Classic Editor from default plugins as these things are nowadays defined by theme

### 2.1.1: 2021-08-24

* Fix GitHub repository init in start script

### 2.1.0: 2021-06-21

* Bump WordPress to 5.7.2

### 2.0.9: 2021-06-21

* Change default mysql host back to 127.0.0.1 instead of localhost as [macos-lemp-stack](https://github.com/digitoimistodude/macos-lemp-setup) and newest brew mariadb updates seem to depend on it

### 2.0.8: 2021-05-19

* Change default mysql host to localhost instead of 127.0.0.1

### 2.0.7: 2021-05-04

* Ensure github repo is created
* Export variables

### 2.0.6: 2021-05-03

* Fix EOL settings

### 2.0.5: 2021-05-03

* Fix getting WP_ENV from .env, Fixes #14

### 2.0.4: 2021-04-15

* Improved laragon support, see PR #13 (Huge thanks to @divn!)

### 2.0.3: 2021-04-14

* Add laragon support (bin/laragon.bat, huge thanks to @divn)

### 2.0.2: 2021-04-14

Project start scripts have been refactored completely.
See [pull request #11](https://github.com/digitoimistodude/dudestack/pull/11).

### Changes:

- Deprecated docker and vagrant - they are horribly outdated and we can't support them no longer. [dudestack-docker](https://github.com/digitoimistodude/dudestack-docker) has been retired.
- Add working WSL support ([documentation](https://rolle.design/local-server-on-windows-10-for-wordpress-theme-development)), linked also to [windows-lemp-setup](https://github.com/digitoimistodude/windows-lemp-setup)
- Modularize bash scripts, add files as partials. From now on we need to edit files under bin/tasks and no need to touch main files macos.sh and wsl.sh
- Beautiful formatting and instructions to start script
- Prevent running directly with bash or sh to prevent possible issues with them
- Variable all the things - no need to search and replace stuff
- Fix typos
- Fix WP-CLI commands, there were couple of issues with it
- Fix cleanups - we had wp-cli.yml credentials left saved to project - oops!
- Add some checks (is git found, are certs created, is mkcert found etc.)
- Add extra notifications that these scripts need dudestack and dev servers to work
- Move everything to .env_createproject in $HOME. No more setup.sh or complicated generate scripts, everything should work directly from dudestack repo WITH updates in the future

### 2.0.1: 2021-02-19

* Fix updating wp option current_theme, value is needed, on osxlemp createproject script, [0c19c31](https://github.com/digitoimistodude/dudestack/commit/0c02b56fd8100b1e5ab164a34e740e606300b6bf)
* Change ga-in plugin to koko-analytics, [0c02b56](https://github.com/digitoimistodude/dudestack/commit/0c23137bb8182d214a04c8685a36598faab75663)
* Add the new WP_ENVIRONMENT_TYPE environment variable that WP core uses in wp_get_environment_type function, [0c23137](https://github.com/digitoimistodude/dudestack/commit/f832c884ab92d815ba13de780b8e6604bf6013ad)
### 2.0.0: 2021-02-18

* Major dudestack version update - Moving to PHP dotenv 5.3, roots/wp-config, oscarotero/env, [#4](https://github.com/digitoimistodude/dudestack/pull/4)
* HTTPS support, [#5](https://github.com/digitoimistodude/dudestack/pull/5)
### 1.8.6: 2021-02-16

* Start changelog
