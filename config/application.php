<?php
$root_dir = dirname( dirname( __FILE__ ) );

/**
 * Use Dotenv to set required environment variables and load .env file in root
 */
$dotenv = new Dotenv\Dotenv( $root_dir );
if ( file_exists( $root_dir . '/.env' ) ) {
  $dotenv->load();
}
$dotenv->required( array( 'DB_NAME', 'DB_USER', 'DB_PASSWORD', 'WP_HOME', 'WP_SITEURL' ) );

/**
 * Set up our global environment constant and load its config first
 * Default: development
 */
define( 'WP_ENV', getenv( 'WP_ENV' ) ? getenv( 'WP_ENV' ) : 'development' );

$env_config = dirname( __FILE__ ) . '/environments/' . WP_ENV . '.php';

if ( file_exists( $env_config ) ) {
  require_once $env_config;
}

/**
 * Custom Content Directory
 */
define( 'CONTENT_DIR', '/content' );
define( 'WP_CONTENT_DIR', $root_dir . CONTENT_DIR );
define( 'WP_CONTENT_URL', WP_HOME . CONTENT_DIR );

/**
 * DB settings
 */
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
$table_prefix = 'wp_';

/**
 * Authentication Unique Keys and Salts
 */
define( 'AUTH_KEY',         getenv( 'AUTH_KEY' ) );
define( 'SECURE_AUTH_KEY',  getenv( 'SECURE_AUTH_KEY' ) );
define( 'LOGGED_IN_KEY',    getenv( 'LOGGED_IN_KEY' ) );
define( 'NONCE_KEY',        getenv( 'NONCE_KEY' ) );
define( 'AUTH_SALT',        getenv( 'AUTH_SALT' ) );
define( 'SECURE_AUTH_SALT', getenv( 'SECURE_AUTH_SALT' ) );
define( 'LOGGED_IN_SALT',   getenv( 'LOGGED_IN_SALT' ) );
define( 'NONCE_SALT',       getenv( 'NONCE_SALT' ) );

/**
 *  Redis object cache settings for
 *  https://wordpress.org/plugins/redis-cache/
 */
define( 'WP_CACHE_KEY_SALT',        getenv( 'DB_NAME' ) );
define( 'WP_REDIS_SELECTIVE_FLUSH', true );
define( 'WP_REDIS_MAXTTL',          43200 ); // max cache half day

if ( 'development' !== WP_ENV ) {
  define( 'WP_REDIS_PASSWORD', getenv( 'REDIS_PASSWORD' ) );
}

/**
 * Custom Settings
 */
define( 'AUTOMATIC_UPDATER_DISABLED', false );
define( 'DISABLE_WP_CRON', false );
define( 'DISALLOW_FILE_EDIT', true );
define( 'WP_POST_REVISIONS', 25 );

/**
 * Bootstrap WordPress
 */
if ( ! defined( 'ABSPATH' ) ) {
  define( 'ABSPATH', $root_dir . '/wp/' );
}
