<?php
/* Development */
define('DB_NAME', getenv('DB_NAME'));
define('DB_USER', getenv('DB_USER'));
define('DB_PASSWORD', getenv('DB_PASSWORD'));
define('DB_HOST', getenv('DB_HOST') ? getenv('DB_HOST') : 'localhost');

define('WP_HOME', getenv('WP_HOME'));
define('WP_SITEURL', getenv('WP_SITEURL'));

define('FS_METHOD', 'direct');

define('SAVEQUERIES', true);
define('WP_DEBUG', true);
define('SCRIPT_DEBUG', true);
define('WP_DISABLE_FATAL_ERROR_HANDLER', true);

define( 'PLL_CACHE_HOME_URL', false );
