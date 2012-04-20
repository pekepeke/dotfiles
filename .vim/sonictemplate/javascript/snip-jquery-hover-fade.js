// hover fadeIn/Out
$('.pageTop a').hover(function() {
	var $el = $('img:nth(1)', this);
	$el.is(':animated') && $el.stop();
	$el.hide().fadeIn('slow');
}, function() {
	var $el = $('img:nth(1)', this);
	$el.is(':animated') && $el.stop();
	$el.css('opacity', 1).fadeOut('slow');
});

