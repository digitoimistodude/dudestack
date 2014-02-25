jQuery( function ( $ ) {
	$( '.switch-have-key' ).click( function() {
		var no_key = $( this ).parents().find('div.no-key');		
		var have_key = $( this ).parents().find('div.have-key');
		
		no_key.addClass( 'hidden' );
		have_key.removeClass( 'hidden' );		
		
		return false;
	});
	$( 'p.need-key a' ).click( function(){
		document.akismet_activate.submit();
	});
	$('.akismet-status').each(function () {
		var thisId = $(this).attr('commentid');
		$(this).prependTo('#comment-' + thisId + ' .column-comment div:first-child');
	});
	$('.akismet-user-comment-count').each(function () {
		var thisId = $(this).attr('commentid');
		$(this).insertAfter('#comment-' + thisId + ' .author strong:first').show();
	});
	$('#the-comment-list tr.comment .column-author a[title ^= "http://"]').each(function () {
 		var thisTitle = $(this).attr('title');
 		    thisCommentId = $(this).parents('tr:first').attr('id').split("-");
 		
 		$(this).attr("id", "author_comment_url_"+ thisCommentId[1]);
 		
 		if (thisTitle) {
 			$(this).after(' <a href="#" class="remove_url" commentid="'+ thisCommentId[1] +'" title="Remove this URL">x</a>');
 		}
 	});
 	$('.remove_url').live('click', function () {
 		var thisId = $(this).attr('commentid');
 		var data = {
 			action: 'comment_author_deurl',
			_wpnonce: WPAkismet.comment_author_url_nonce,
 			id: thisId
 		};
 		$.ajax({
		    url: ajaxurl,
		    type: 'POST',
		    data: data,
		    beforeSend: function () {
		        // Removes "x" link
	 			$("a[commentid='"+ thisId +"']").hide();
	 			// Show temp status
		        $("#author_comment_url_"+ thisId).html('<span>Removing...</span>');
		    },
		    success: function (response) {
		        if (response) {
	 				// Show status/undo link
	 				$("#author_comment_url_"+ thisId).attr('cid', thisId).addClass('akismet_undo_link_removal').html('<span>URL removed (</span>undo<span>)</span>');
	 			}
		    }
		});

 		return false;
 	});
 	$('.akismet_undo_link_removal').live('click', function () {
 		var thisId = $(this).attr('cid');
		var thisUrl = $(this).attr('href').replace("http://www.", "").replace("http://", "");
 		var data = {
 			action: 'comment_author_reurl',
			_wpnonce: WPAkismet.comment_author_url_nonce,
 			id: thisId,
 			url: thisUrl
 		};
		$.ajax({
		    url: ajaxurl,
		    type: 'POST',
		    data: data,
		    beforeSend: function () {
	 			// Show temp status
		        $("#author_comment_url_"+ thisId).html('<span>Re-adding…</span>');
		    },
		    success: function (response) {
		        if (response) {
	 				// Add "x" link
					$("a[commentid='"+ thisId +"']").show();
					// Show link
					$("#author_comment_url_"+ thisId).removeClass('akismet_undo_link_removal').html(thisUrl);
	 			}
		    }
		});
 		
 		return false;
 	});
 	$('a[id^="author_comment_url"]').mouseover(function () {
		var wpcomProtocol = ( 'https:' === location.protocol ) ? 'https://' : 'http://';
		// Need to determine size of author column
		var thisParentWidth = $(this).parent().width();
		// It changes based on if there is a gravatar present
		thisParentWidth = ($(this).parent().find('.grav-hijack').length) ? thisParentWidth - 42 + 'px' : thisParentWidth + 'px';
		if ($(this).find('.mShot').length == 0 && !$(this).hasClass('akismet_undo_link_removal')) {
			var thisId = $(this).attr('id').replace('author_comment_url_', '');
			$('.widefat td').css('overflow', 'visible');
			$(this).css('position', 'relative');
			var thisHref = $.URLEncode($(this).attr('href'));
			$(this).append('<div class="mShot mshot-container" style="left: '+thisParentWidth+'"><div class="mshot-arrow"></div><img src="'+wpcomProtocol+'s0.wordpress.com/mshots/v1/'+thisHref+'?w=450" width="450" class="mshot-image_'+thisId+'" style="margin: 0;" /></div>');
			setTimeout(function () {
				$('.mshot-image_'+thisId).attr('src', wpcomProtocol+'s0.wordpress.com/mshots/v1/'+thisHref+'?w=450&r=2');
			}, 6000);
			setTimeout(function () {
				$('.mshot-image_'+thisId).attr('src', wpcomProtocol+'s0.wordpress.com/mshots/v1/'+thisHref+'?w=450&r=3');
			}, 12000);
		} else {
			$(this).find('.mShot').css('left', thisParentWidth).show();
		}
	}).mouseout(function () {
		$(this).find('.mShot').hide();
	});
	$('.checkforspam:not(.button-disabled)').on('click', function(e) { 
	 	$('.checkforspam:not(.button-disabled)').addClass('button-disabled'); 
	 	$('.checkforspam-spinner').show(); 
	 	akismet_check_for_spam(0, 50); 
	 	e.preventDefault(); 
 	});

	// Ajax "Check for Spam" 
	function akismet_check_for_spam( offset, limit ) { 
		$.post( 
			ajaxurl, 
			{
				'action': 'akismet_recheck_queue',
				'offset': offset,
				'limit': limit
			}, 
			function ( result ) {
				if ( result.processed < limit ) {
					window.location.reload();
				}
				else { 
					akismet_check_for_spam( offset + limit, limit );
				}
			}
		);
	}
});

// URL encode plugin
jQuery.extend({URLEncode:function(c){var o='';var x=0;c=c.toString();var r=/(^[a-zA-Z0-9_.]*)/;
  while(x<c.length){var m=r.exec(c.substr(x));
    if(m!=null && m.length>1 && m[1]!=''){o+=m[1];x+=m[1].length;
    }else{if(c[x]==' ')o+='+';else{var d=c.charCodeAt(x);var h=d.toString(16);
    o+='%'+(h.length<2?'0':'')+h.toUpperCase();}x++;}}return o;}
});
// Preload mshot images after everything else has loaded
jQuery(window).load(function() {
	var wpcomProtocol = ( 'https:' === location.protocol ) ? 'https://' : 'http://';
	jQuery('a[id^="author_comment_url"]').each(function () {
		jQuery.get(wpcomProtocol+'s0.wordpress.com/mshots/v1/'+jQuery.URLEncode(jQuery(this).attr('href'))+'?w=450');
	});
});
