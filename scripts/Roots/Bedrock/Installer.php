<?php
/**
 * Installer
 *
 * Description: Bedrock installer.
 *
 * @Author: Roni Laukkarinen
 * @Date: 2022-06-28 13:14:24
 * @Last Modified by:   Roni Laukkarinen
 * @Last Modified time: 2024-03-12 15:34:00
 *
 * @package dudestack
 * @link https://github.com/roots/bedrock
 */

namespace Roots\Bedrock;

use Composer\Script\Event;

class Installer {
  public static $keys = [
    'AUTH_KEY',
    'SECURE_AUTH_KEY',
    'LOGGED_IN_KEY',
    'NONCE_KEY',
    'AUTH_SALT',
    'SECURE_AUTH_SALT',
    'LOGGED_IN_SALT',
    'NONCE_SALT',
  ];

  public static function addSalts(Event $event) { // phpcs:ignore
		$root = dirname( dirname( dirname( __DIR__ ) ) );
		$composer = $event->getComposer();
		$io = $event->getIO();

		if ( ! $io->isInteractive() ) {
		  $generate_salts = $composer->getConfig()->get( 'generate-salts' );
		} else {
		  $generate_salts = $io->askConfirmation( '<info>Generate salts and append to .env file?</info> [<comment>Y,n</comment>]? ', true );
		}

		if ( ! $generate_salts ) {
		  return 1;
		}

		$salts = array_map( function ( $key ) {
		  return sprintf( "%s='%s'", $key, Installer::generateSalt() );
		}, self::$keys);

		$env_file = "{$root}/.env";

		if ( copy( "{$root}/.env.example", $env_file ) ) {
		  file_put_contents( $env_file, implode( "\n", $salts ), FILE_APPEND | LOCK_EX ); // phpcs:ignore WordPress.WP.AlternativeFunctions.file_system_operations_file_put_contents
		} else {
		  $io->write( '<error>An error occured while copying your .env file</error>' );
		  return 1;
		}
  }

  /**
   * Slightly modified/simpler version of wp_generate_password
   * https://github.com/WordPress/WordPress/blob/cd8cedc40d768e9e1d5a5f5a08f1bd677c804cb9/wp-includes/pluggable.php#L1575
   */
  public static function generateSalt( $length = 64 ) { // phpcs:ignore
		$chars  = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
		$chars .= '!@#$%^&*()';
		$chars .= '-_ []{}<>~`+=,.;:/?|';

		$salt = '';
		for ( $i = 0; $i < $length; $i++ ) {
		  $salt .= substr( $chars, rand( 0, strlen( $chars ) - 1 ), 1 ); // phpcs:ignore
		}

		return $salt;
  }
}
