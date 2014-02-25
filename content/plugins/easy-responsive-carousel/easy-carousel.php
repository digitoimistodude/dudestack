<?php
/*
  Plugin Name: Easy Responsive Carousel
  Plugin URI: http://matgargano.com
  Description: Adds an Image Carousel *Note* your theme MUST include & enqueue bootstrap 3+
  Version: 0.4.5
  Author: matstars
  Author URI: http://matgargano.com
  License: GPL2

*/


foreach ( glob( plugin_dir_path(__FILE__) . "inc/*.php" ) as $filename ) include $filename;

Easy_carousel::init();
Easy_carousel_admin::init();





if ( !function_exists('has_shortcode') ) {
	/**
	 *
	 * if < WP 3.6 let's add in has_shortcode
	 *
	 * @param $content
	 * @param $tag
	 *
	 * @return bool
	 */
	function has_shortcode( $content, $tag ) {
         if ( shortcode_exists( $tag ) ) {
                 preg_match_all( '/' . get_shortcode_regex() . '/s', $content, $matches, PREG_SET_ORDER );
                 if ( empty( $matches ) )
                         return false;

                 foreach ( $matches as $shortcode ) {
                         if ( $tag === $shortcode[2] )
                                 return true;
                 }
         }
         return false;
	}
}






if ( ! function_exists( 'sanitize_hex_color' ) ) {
	/**
	 *
	 * From WP 3.8 alpha
	 *
	 * @param $hex_color
	 *
	 * @return string or null
	 */
	function sanitize_hex_color( $color ) {
		if ( '' === $color )
			return '';

		// 3 or 6 hex digits, or the empty string.
		if ( preg_match('|^#([A-Fa-f0-9]{3}){1,2}$|', $color ) )
			return $color;

		return null;
	}
}

/**
 * helper function (source: http://bavotasan.com/2011/convert-hex-color-to-rgb-using-php/)
 * @param $hex
 *
 * @return array
 */
if ( ! function_exists('hex2rgb') ) {
	function hex2rgb($hex) {
		$hex = str_replace("#", "", $hex);

		if(strlen($hex) == 3) {
			$r = hexdec(substr($hex,0,1).substr($hex,0,1));
			$g = hexdec(substr($hex,1,1).substr($hex,1,1));
			$b = hexdec(substr($hex,2,1).substr($hex,2,1));
		} else {
			$r = hexdec(substr($hex,0,2));
			$g = hexdec(substr($hex,2,2));
			$b = hexdec(substr($hex,4,2));
		}
		$rgb = array($r, $g, $b);

		return $rgb;
	}
}
