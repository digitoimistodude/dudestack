/*jslint browser: true*/
/*global $, jQuery*/
jQuery(document).ready(function ($) {
    "use strict";
    if (typeof jQuery.wp === 'object' && typeof jQuery.wp.wpColorPicker === 'function') {
        $("#content_color").wpColorPicker();
    }
});
