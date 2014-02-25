=== Easy Responsive Carousel ===
Contributors: matstars
Tags: custom post types, CPT, post, types, post type, order post types
Requires at least: 3.5
Tested up to: 3.7.1
Stable tag: 0.4.5
License: GPLv2

Adds an Image Carousel post type and shortcode. Note your theme MUST include & enqueue bootstrap 3+

== Description ==

Creates a post type called Easy Carousel. It's hierarchical - parent post is the main post and the children are the slideshow slides. Upload a featured image to each child post. Each image needs to be the same size.

N.B. Your theme must have 'post-thumbnails' enabled ( see http://codex.wordpress.org/Function_Reference/add_theme_support for more information ).

Adds a shortcode [easy_carousel id=N ] with the required variables:

- id => ID of the parent Easy Carousel Post

...and the optional variables:

- timeout => milliseconds to pause in between slides (default: 5000)
- pause => if set to true - the slideshow will pause on hover; set to false - the carousel does not pause on hover. (default: false)
- effect => "slide" or "fade" (default: none)
- orderby => what to order the children posts (default: menu_order)
- order => direction to order the posts (default: asc)
- mobile => will hide on mobile if true (default: true)
- caption => show caption of slide, which is the post's content (default: true)
- caption_opacity => opacity for background of caption (default: 0.8)
- indicators => show indicator dots on slideshow (default: true)
- arrows => show arrows on slideshow (default: true)

    

== Changelog ==

= 0.4.4 =

* Linted JS, standardized include directory name


= 0.4.3 =

* Add ability to drag and drop the sort slide functionality from within the parent Easy Carousel post.

= 0.4 =

Remove support for Bootstrap < 3
Add indicators, optional within shortcode
Add arrows, optional within shortcode, filterable via class on easy_responsive_carousel_left_arrow and easy_responsive_carousel_right_arrow
Fix for positioning issues and responsive issues

= 0.3 =

Added post meta into its own class
Moved carousel into its own class
Added instantiation to main file

= 0.2 =

Added LESS support
Added fade as an effect for transitions

= 0.1.1 =

Bug fixes

= 0.1 =

Initial release