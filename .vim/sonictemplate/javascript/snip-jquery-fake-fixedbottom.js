var $el = $balloon
  , orient = 1
  , heights = {}
  , get_height = function() {
      var visible = $el.is(':visible')
        , h = $el.show().outerHeight(true); //.height();
      if (!visible) $el.hide();
      return h;
    }
  , get_win_h = function() { 
      return window.innerHeight ? window.innerHeight : $(window).height();
    }
  , adjust = function() {
      $el.css('top', get_win_h() + $(window).scrollTop() - heights[orient]);
    };

heights[orient] = get_height();
$(window)
  .bind('orientationchange', function() {
      orient = orient * -1;
      heights[orient] = get_height();
      adjust.apply(this, $.makeArray(arguments));
  })
  .bind('resize', adjust)
  .scroll(adjust)
  .trigger('resize');

var timer_id = null;
$(document).bind('touchstart', function(e) {
    clearTimeout(timer_id);
    $el.hide();
}).bind('touchend', function(e) {
    timer_id = setTimeout(function() {
        adjust();
        $el.show();
    }, 2000);
});

