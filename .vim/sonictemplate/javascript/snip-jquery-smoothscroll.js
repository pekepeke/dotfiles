(function($) {
  var speeds = {
    "fast" : 200
    , "normal" : 400
    , "slow" : 600
  };
  var TimerID = null;
  function linear(x, t, b, c, d) {
    return c*t/d + b;
  }
  $.fn.smoothScroll = function(options) {
    clearTimeout(TimerID);
    var $els = this
    , opts = $.extend({
      duration : 400
      , easing : 'linear'
      , fps : 36
      , offset : 0
      , on_start : function() { }
      , on_finish : function() { }
    }, options)
    , fire = function(ev, el) {
      if (typeof opts[ev] === 'function') { opts[ev].call(el); }
    };
    if (typeof speeds[opts.duration] !== 'undefined') {
      opts.duration = speeds[opts.duration];
    }

    var scroll_fn = function() {
      var q = $(this).attr('href')
      , self = this
      , tick = 1000 / (opts.fps || 60);

      if (!q.match(/^#/)) { return true; }

      var $target = $([q, 'a[name="' + q.replace(/^#/, '') + '"]'].join(','));
      if ($target.length <= 0) { return false; }

      var end = $target.offset().top + (opts.offset || 0)
      , start = window.pageYOffset || document.documentElement.scrollTop || document.body.scrollTop || 0
      , d_h = document.documentElement.scrollHeight
      , w_h = window.innterHeight || document.documentElement.clientHeight
      , screen_h = d_h - w_h;

      if ( screen_h < end) { end = screen_h; }
      if (end == start) { return false; }

      var t = 0 , sy = 0 , ey = Math.abs(end - start)
      , is_upto = (end >= start ? true : false)
      , prev_scroll = -1
      , ease_fn = null;

      ease_fn = opts.easing == 'linear' ? linear : $.easing[opts.easing];

      if (typeof ease_fn !== 'function') { ease_fn = linear; }

      var motion_fn = function() {
        TimerID = setTimeout(function() {
          t += tick;
          var dy = ease_fn(null, t, sy, ey, opts.duration) * (is_upto ? 1 : -1)
          , scroll = start + dy
          , is_end = scroll == prev_scroll;

          if (opts.duration < t) {
            is_end = true;
            scroll = end;
          } else if ((is_upto && end <= scroll) || (!is_upto && end >= scroll)) {
            is_end = true;
            scroll = end;
          }

          window.scrollTo(0, scroll);

          if (is_end) {
            fire('on_finish', self);
            return false;
          }
          prev_scroll = scroll;
          motion_fn();
        }, tick);
      };
      fire('on_start', self);
      motion_fn.call(self, start, end);
      return false;
    };

    $els.each(function() {
      $(this)
      .click(scroll_fn);
    });
    return this;
  };
})(jQuery);

