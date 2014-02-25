/*jslint browser: true*/
/*global $, jQuery*/
jQuery(document).ready(function ($) {
    "use strict";
    function carousel_width($parent) {
        var width = 0;
        $parent.find('.item').each(function () {
            width = Math.max(width, jQuery(this).width());
        });
        $parent.css('max-width', width + 'px');
        return;
    }
    setTimeout(function () {
        carousel_width($('.easy-responsive-carousel'));
    }, 1);
});
