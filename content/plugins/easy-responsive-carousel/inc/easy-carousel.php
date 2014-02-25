<?php


/**
 * Class easy_carousel
 */
class Easy_carousel {

	/**
	 * @var string
	 */
	public static $post_type = 'easy_carousel';
	/**
	 * @var string
	 */
	public static $file_name = 'easy-carousel';
	/**
	 * @var string
	 */
	public static $shortcode = 'easy_carousel';
	/**
	 * @var int
	 */
	public static $incrementer = 0;
	/**
	 * @var string
	 */
	public static $ver = '0.4.5';





	/**
	 * initialize the plugin
	 *
	 * @return void
	 *
	 */
	public static function init(){
		add_action( 'init', array( __CLASS__, 'register_post_type' ) );
		add_action( 'wp_footer', array( __CLASS__, 'print_script' ) );

		add_action( 'wp_enqueue_scripts', array( __CLASS__, 'enqueue' ) );
		add_action( 'admin_print_scripts-post-new.php', array( __CLASS__, 'admin_enqueue' ), 11 );
		add_action( 'admin_print_scripts-post.php', array( __CLASS__, 'admin_enqueue' ), 11 );
		add_shortcode( self::$shortcode, array( __CLASS__, 'shortcode' ) );

	}

	/**
	 *
	 * Register the post type
	 *
	 * @return void
	 *
	 */
	public static function register_post_type(){
		$labels = array(
			'name'               => 'Easy Carousel',
			'singular_name'      => 'Easy Carousel',
			'add_new'            => 'Add New',
			'add_new_item'       => 'Add New Carousel',
			'edit_item'          => 'Edit Carousel',
			'new_item'           => 'New Carousel',
			'all_items'          => 'All Carousels',
			'view_item'          => 'View Carousel',
			'search_items'       => 'Search Carousels',
			'not_found'          => 'No Carousels found',
			'not_found_in_trash' => 'No Carousels found in Trash',
			'parent_item_colon'  => '',
			'menu_name'          => 'Easy Carousel'
		);

		$args = array(
			'labels'             => $labels,
			'public'             => true,
			'hierarchical'       => true,
			'has_archive'        => true,
			'rewrite'            => false,
			'supports'           => array( 'title', 'editor', 'thumbnail', 'page-attributes' ),
		);

		register_post_type( self::$post_type, $args );
	}

	/**
	 *
	 * Shortcode method
	 * Filters:
	 *  easy_responsive_carousel_left_arrow - able to change to CSS class (e.g. different glyphicon)
	 *  easy_responsive_carousel_right_arrow - able to change to CSS class (e.g. different glyphicon)
	 *
	 *    example:
	 *       function function_easy_responsive_carousel_left_arrow ($g){
	 *            return 'glyphicon-arrow-left';
	 *       };
	 *
	 * 	     add_filter('easy_responsive_carousel_right_arrow', 'function_easy_responsive_carousel_right_arrow');
	 *
	 *
	 * @param $atts
	 *
	 * @return string
	 */
	public static function shortcode( $atts ) {

		/* initialize variables */
		$id = $timeout = $pause = $effect = $orderby = $order = $mobile = $caption = $caption_opacity = $indicators = $arrows = null;
		extract( shortcode_atts( array(
			'id' => -1,
			'timeout' => 5000,
			'pause' => false,
			'effect' => '',
			'orderby' => 'menu_order',
			'order' => 'asc',
			'mobile' => true,
			'caption' => true,
			'caption_opacity' => '0.8',
			'indicators' => true,
			'arrows' => true
		), $atts) );
		if ( ! $mobile && wp_is_mobile() ) {
			return false;
		} 
		static::$incrementer++;
		$inner_html = $pre_outer_html = $post_outer_html = $html = $pause_att = '';
		$counter = 0;
		if ( $effect ) {
			$effect = ' ' . $effect;
		}
		if ( ! $pause ) {
			$pause_att = ' "pause" : false ';
		}
		if ( $id == -1 || !get_post( $id ) ) {
			return false;
		}
		if ( ! self::$post_type == get_post_type( $id ) ) {
			return false;
		}

		$pre_outer_html .= '<div class="easy-responsive-carousel clearfix carousel' . $effect . '" id="carousel-' . static::$incrementer . '" data-ride="carousel">';
		if ( $indicators ):
			$pre_outer_html .= '<ol class="carousel-indicators">';
		endif;
		
		$children = get_posts( array( 'post_type' => self::$post_type, 'post_parent' => $id, 'orderby' => $orderby, 'order' => $order ) );

		foreach( $children as $post ) : setup_postdata($post);
			$active = '';
			if ( $counter === 0 ) :
				$active = ' active';
			endif;
			if ( $indicators ) :
				$pre_outer_html .= '<li data-target="#carousel-' . static::$incrementer . '" data-slide-to="' . $counter . '" class="' . $active . '"></li>';
			endif;
			$counter++;
			$inner_html .= '<div class="item' . $active . '">';
			$inner_html .= get_the_post_thumbnail( $post->ID, $size = 'full' );
			if ( $caption && get_the_content() ) {
				$hex_color = get_post_meta( $post->ID, 'content_color', true );
				$rgb = hex2rgb( $hex_color );
				$color_style = 'rgba(' . $rgb[0] . ',' . $rgb[1] . ',' . $rgb[2] . ', ' . $caption_opacity . ')';

				$inner_html .= '<div class="content" style="background:' . $color_style . ';">';
				$inner_html .= get_the_content();
				$inner_html .= '</div>';
			}
			$inner_html .= '</div>';
            wp_reset_postdata();
        endforeach;
		if ( $indicators ):
			$pre_outer_html .= '</ol>';
		endif;
		$pre_outer_html .= '<div class="carousel-inner">';
		$post_outer_html .= '</div> <!-- close carousel-inner  -->';
		if ( $arrows ):
			$left_arrow = apply_filters('easy_responsive_carousel_left_arrow', 'glyphicon-chevron-left');
			$right_arrow = apply_filters('easy_responsive_carousel_right_arrow', 'glyphicon-chevron-right');

			$post_outer_html .= '<a class="left carousel-control" href="#carousel-' . static::$incrementer . '" data-slide="prev"><span class="glyphicon ' . $left_arrow . '"></span></a>';
			$post_outer_html .= '<a class="right carousel-control" href="#carousel-' . static::$incrementer . '" data-slide="next"><span class="glyphicon ' . $right_arrow . '"></span></a>';
		endif;


		$post_outer_html .= '</div><div class="clearfix"></div>';
		$post_outer_html .= '<script>';
		$post_outer_html .= 'jQuery(".carousel#carousel-' . static::$incrementer . '").carousel( { "interval" : ' . $timeout . ', ' . $pause_att . '} );';
		$post_outer_html .= 'carousel_width(jQuery(".carousel#carousel-' . static::$incrementer . '"))';
		$post_outer_html .= '</script>';

		$html = $pre_outer_html . $inner_html . $post_outer_html;
		return $html;
	}



	/**
	 *
	 * Enqueue scripts
	 *
	 * @return void
	 *
	 */
	static function enqueue(){
		global $post;
		if ( !empty( $post ) && has_shortcode( $post->post_content, self::$shortcode ) ){
			wp_enqueue_style( self::$file_name, plugins_url('css/' .self::$file_name .'.css', dirname( __FILE__ ) ), false, self::$ver );
			wp_enqueue_script( self::$file_name, plugins_url('js/' .self::$file_name .'.js', dirname( __FILE__ ) ), array( 'jquery' ), self::$ver );


		}
	}

	/**
	 *
	 * Enqueue scripts on backend
	 *
	 * @return void
	 *
	 */
	static function admin_enqueue(){
		global $post_type;
		if( self::$post_type != $post_type ) return;
			wp_enqueue_style( 'wp-color-picker' );
			wp_enqueue_script( 'wp-color-picker' );
		wp_enqueue_script( self::$file_name . '-admin', plugins_url('js/' .self::$file_name .'-admin.js', dirname( __FILE__ ) ), array( 'jquery', 'wp-color-picker' ), self::$ver );


	}



}

