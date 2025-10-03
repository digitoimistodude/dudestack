<?php
/**
 * Your base production configuration goes in this file. Environment-specific
 * overrides go in their respective config/environments/{{WP_ENV}}.php file.
 *
 * A good default policy is to deviate from the production config as little as
 * possible. Try to define as much of your configuration in this file as you
 * can.
 */

use Roots\WPConfig\Config;
use function Env\env;

/**
 * Directory containing all of the site's files
 *
 * @var string
 */
$root_dir = dirname( __DIR__ );

/**
 * Document Root
 *
 * @var string
 */
$webroot_dir = $root_dir;

/**
 * Use Dotenv to set required environment variables and load .env file in root
 */
$dotenv = Dotenv\Dotenv::createUnsafeImmutable( $root_dir );
if ( file_exists( $root_dir . '/.env' ) ) {
  $dotenv->load();
  $dotenv->required( [ 'WP_HOME', 'WP_SITEURL' ] );
  if ( ! env( 'DATABASE_URL' ) ) {
    $dotenv->required( [ 'DB_NAME', 'DB_USER', 'DB_PASSWORD' ] );
  }
}

/**
 * Set up our global environment constant and load its config first
 * Default: production
 */
Config::define( 'WP_ENVIRONMENT_TYPE', env( 'WP_ENV' ) ?: 'production' ); // new way
Config::define( 'WP_ENV', env( 'WP_ENV' ) ?: 'production' ); // backward compatibility fallback

/**
 * URLs
 */
Config::define( 'WP_HOME', env( 'WP_HOME' ) );
Config::define( 'WP_SITEURL', env( 'WP_SITEURL' ) );

/**
 * Custom Content Directory
 */
Config::define( 'CONTENT_DIR', '/content' );
Config::define( 'WP_CONTENT_DIR', $webroot_dir . Config::get( 'CONTENT_DIR' ) );
if ( isset( $_SERVER['HTTP_HOST'] ) ) {
  Config::define( 'WP_CONTENT_URL', 'https://' . $_SERVER['HTTP_HOST'] . Config::get( 'CONTENT_DIR' ) );
} else {
  Config::define( 'WP_CONTENT_URL', Config::get( 'WP_HOME' ) . Config::get( 'CONTENT_DIR' ) );
}

/**
 * DB settings
 */
Config::define( 'DB_NAME', env( 'DB_NAME' ) );
Config::define( 'DB_USER', env( 'DB_USER' ) );
Config::define( 'DB_PASSWORD', env( 'DB_PASSWORD' ) );
Config::define( 'DB_HOST', env( 'DB_HOST' ) ?: 'localhost' );
Config::define( 'DB_CHARSET', 'utf8mb4' );
Config::define( 'DB_COLLATE', '' );
$table_prefix = env( 'DB_PREFIX' ) ?: 'wp_';

if ( env( 'DATABASE_URL' ) ) {
  $dsn = (object) parse_url( env( 'DATABASE_URL' ) );

  Config::define( 'DB_NAME', substr( $dsn->path, 1 ) );
  Config::define( 'DB_USER', $dsn->user );
  Config::define( 'DB_PASSWORD', isset( $dsn->pass ) ? $dsn->pass : null );
  Config::define( 'DB_HOST', isset( $dsn->port ) ? "{$dsn->host}:{$dsn->port}" : $dsn->host );
}

/**
 * Authentication Unique Keys and Salts
 */
Config::define( 'AUTH_KEY', env( 'AUTH_KEY' ) );
Config::define( 'SECURE_AUTH_KEY', env( 'SECURE_AUTH_KEY' ) );
Config::define( 'LOGGED_IN_KEY', env( 'LOGGED_IN_KEY' ) );
Config::define( 'NONCE_KEY', env( 'NONCE_KEY' ) );
Config::define( 'AUTH_SALT', env( 'AUTH_SALT' ) );
Config::define( 'SECURE_AUTH_SALT', env( 'SECURE_AUTH_SALT' ) );
Config::define( 'LOGGED_IN_SALT', env( 'LOGGED_IN_SALT' ) );
Config::define( 'NONCE_SALT', env( 'NONCE_SALT' ) );

/**
 * Custom Settings
 */
Config::define( 'AUTOMATIC_UPDATER_DISABLED', false );
Config::define( 'DISABLE_WP_CRON', env( 'DISABLE_WP_CRON' ) ?: false );
Config::define( 'DISALLOW_FILE_EDIT', true ); // Disable the plugin and theme file editor in the admin
Config::define( 'DISALLOW_FILE_MODS', false ); // Disable plugin and theme updates and installation from the admin
Config::define( 'WP_POST_REVISIONS', env( 'WP_POST_REVISIONS' ) ?: 15 ); // Limit the number of post revisions that WordPress stores
Config::define( 'MAILGUN_USEAPI', true );

/**
 * Debugging Settings
 */
Config::define( 'WP_DEBUG_DISPLAY', false );
Config::define( 'WP_DEBUG_LOG', env( 'WP_DEBUG_LOG' ) ?? false );
Config::define( 'SCRIPT_DEBUG', false );
ini_set( 'display_errors', '0' ); // phpcs:ignore

/**
 *  Redis object cache settings for
 *  https://objectcache.pro/docs/configuration-options/
 */
Config::define( 'WP_REDIS_CONFIG', [
  'token'             => env( 'REDIS_TOKEN' ),
  'host'              => '127.0.0.1',
  'port'              => 6379,
  'password'          => env( 'REDIS_PASSWORD' ),
  'prefix'            => env( 'DB_NAME' ),
  'database'          => env( 'REDIS_DATABASE' ) ?: 0,
  'maxttl'            => 43200, // Max cache half day
  'timeout'           => 0.5,
  'read_timeout'      => 0.5,
  'retry_interval'    => 10,
  'retries'           => 3,
  'backoff'           => 'smart',
  'compression'       => 'zstd',
  'serializer'        => 'igbinary',
  'async_flush'       => true,
  'split_alloptions'  => true,
  'prefetch'          => true,
  'strict'            => true,
  'debug'             => false,
  'save_commands'     => false,
] );

if ( 'production' === getenv( 'WP_ENV' ) ) {
  Config::define( 'WP_REDIS_DISABLED', false );
} else {
  Config::define( 'WP_REDIS_DISABLED', true );
}

/**
 * Allow WordPress to detect HTTPS when used behind a reverse proxy or a load balancer
 * See https://codex.wordpress.org/Function_Reference/is_ssl#Notes
 */
if ( isset( $_SERVER['HTTP_X_FORWARDED_PROTO'] ) && $_SERVER['HTTP_X_FORWARDED_PROTO'] === 'https' ) {
  $_SERVER['HTTPS'] = 'on';
}

$env_config = __DIR__ . '/environments/' . env( 'WP_ENV' ) . '.php';

if ( file_exists( $env_config ) ) {
  require_once $env_config;
}

Config::apply();

/**
 * Bootstrap WordPress
 */
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', $webroot_dir . '/wp/' );
}
