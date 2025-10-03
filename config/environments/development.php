<?php
/**
 * Configuration overrides for WP_ENV === 'development'
 */

use Roots\WPConfig\Config;

$root_dir = dirname( dirname( __DIR__ ) );

Config::define( 'SAVEQUERIES', true );
Config::define( 'WP_DEBUG', true );
Config::define( 'WP_DEBUG_DISPLAY', true );
Config::define( 'WP_DEBUG_LOG', $root_dir . '/logs/wp-debug.log' );
Config::define( 'WP_DISABLE_FATAL_ERROR_HANDLER', true );
Config::define( 'SCRIPT_DEBUG', true );
Config::define( 'FS_METHOD', 'direct' );
Config::define( 'PLL_CACHE_HOME_URL', false );
Config::define( 'WP_DEVELOPMENT_MODE', 'all' );

ini_set( 'display_errors', '1' ); // phpcs:ignore
ini_set( 'log_errors', '1' ); // phpcs:ignore
ini_set( 'error_log', $root_dir . '/logs/wp-debug.log' ); // phpcs:ignore
ini_set( 'date.timezone', 'Europe/Helsinki' ); // phpcs:ignore
ini_set( 'log_errors_max_len', '0' ); // phpcs:ignore
date_default_timezone_set( 'Europe/Helsinki' ); // phpcs:ignore WordPress.DateTime.RestrictedFunctions.timezone_change_date_default_timezone_set

// Enable plugin and theme updates and installation from the admin
Config::define( 'DISALLOW_FILE_MODS', false );
