<?php

/**
 * Class Easy_carousel_admin
 */
class Easy_carousel_admin {


	/**
	 * @var string
	 */
	public static $text_domain = 'easy_carousel';
	/**
	 * @var string
	 */
	public static $nonce_name = 'easy_carousel';


	/**
	 * @var
	 */
	public static $post_meta;

	/**
	 * @var
	 */

	public static $post_type;


	/**
	 *
	 * Initialize plugin
	 *
	 * @return void
	 *
	 */

	public static function init(){
		self::$post_type = Easy_carousel::$post_type;
		add_action( 'load-post.php', array( __CLASS__, 'post_meta_boxes_setup' ) );
		add_action( 'load-post-new.php', array( __CLASS__, 'post_meta_boxes_setup' ) );
		self::$post_meta = array(
			array(
				'name'=>'content_color',
				'sanitize'=>'sanitize_hex_color',
				'description'=>'Caption background color'
			)

		);
	}

	/**
	 *
	 * Set up metaboxes
	 *
	 * @return void
	 *
	 */
	public static function post_meta_boxes_setup() {

		/* Add meta boxes on the 'add_meta_boxes' hook. */
		add_action( 'add_meta_boxes', array( __CLASS__, 'add_post_meta_boxes' ) );

		/* Save post meta on the 'save_post' hook. */
		add_action( 'save_post', array( __CLASS__, 'save_post_class_meta' ), 10, 2 );
	}

	/**
	 *
	 * Add meta boxes
	 *
	 * @return void
	 *
	 */
	public static function add_post_meta_boxes() {
		add_meta_box( 'easy-carousel', esc_html__( 'Easy Carousel Settings', self::$text_domain ), array( __CLASS__, 'post_class_meta_box' ), self::$post_type, 'normal', 'default' );
	}

	/**
	 *
	 * Output meta elements
	 *
	 * @param $post
	 * @return void
	 *
	 */
	public static function post_class_meta_box( $post ) { ?>

		<?php wp_nonce_field( basename( __FILE__ ), self::$nonce_name ); ?>
		<?php foreach ( self::$post_meta as $meta ) : ?>
			<p>
				<label for="<?php echo $meta['name']; ?>"><?php echo $meta['description']; ?></label>
				<br />
				<input class="widefat" type="text" name="<?php echo $meta['name']; ?>" id="<?php echo $meta['name']; ?>" value="<?php echo esc_attr( get_post_meta( $post->ID, $meta['name'], true ) ); ?>" size="30" />
			</p>
		<?php endforeach; ?>
	<?php }


	/**
	 *
	 * Hook onto save action
	 *
	 * @param $post_id
	 * @param $post
	 *
	 * @return bool
	 */
	public static function save_post_class_meta( $post_id, $post ) {

		/* Verify the nonce before proceeding. */
		if ( !isset( $_POST[ self::$nonce_name ] ) || ! wp_verify_nonce( $_POST[ self::$nonce_name ], basename( __FILE__ ) ) )
			return $post_id;

		/* Get the post type object. */
		$post_type = get_post_type_object( $post->post_type );

		/* Check if the current user has permission to edit the post. */
		if ( !current_user_can( $post_type->cap->edit_post, $post_id ) )
			return $post_id;



		foreach ( self::$post_meta as $meta ) :
			/* Get the posted data and sanitize it for use as an HTML class. */

			$new_meta_value = ( isset( $_POST[ $meta['name'] ] ) ? call_user_func( $meta['sanitize'], $_POST[ $meta['name'] ] ) : '' );
			/* Get the meta value of the custom field key. */
			$meta_value = get_post_meta( $post_id, $meta['name'], true );

			/* If a new meta value was added and there was no previous value, add it. */
			if ( $new_meta_value && '' == $meta_value ){
				add_post_meta( $post_id, $meta['name'], $new_meta_value, true );
			}

			/* If the new meta value does not match the old value, update it. */
			elseif ( $new_meta_value && $new_meta_value != $meta_value ){
				update_post_meta( $post_id, $meta['name'], $new_meta_value );
			}

			/* If there is no new meta value but an old value exists, delete it. */
			elseif ( '' == $new_meta_value && $meta_value ) {
				delete_post_meta( $post_id, $meta['name'], $meta_value );
			}
		endforeach;

		return true;
	}


}