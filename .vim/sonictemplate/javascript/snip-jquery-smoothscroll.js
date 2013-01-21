(function($) {
    var name = 'smoothScroll';
    $.fn[name] = function(options) {
        var $els = this
        , opts = $.extend({
              duration : 300
            , fps : 60
        }, options)
        ,  data_name = name + "_rel";

        var scroll_fn = function() {
          var q = $(this).data(data_name)
          , msec = 1000 / (opts.fps || 60);

          if (!q.match(/^#/)) {
            return true;
          }

          var $target = $([q, 'a[name="' + q.replace(/^#/, '') + '"]'].join(','));
          if ($target.length <= 0) {
            return false;
          }

          var offset = $target.offset()
          , end = offset.top
          , d_h = document.documentElement.scrollHeight
          , w_h = window.innterHeight
             || document.documentElement.clientHeight;

          if ( (d_h - w_h) < end) {
            end = d_h - w_h;
          }

          var start = window.pageYOffset ||
            document.documentElement.scrollTop ||
            document.body.scrollTop || 0
            , is_upto = end < start ? true : false;


           if (end == start) {
           		return false;
           }
           var dy = Math.abs(end - start) / (opts.duration / msec);
           if (dy <= 0) {
             dy = 1;
           }
           var motion_fn = function(start, end) {
               setTimeout(function() {
               	   var prev_start = start
                   , is_fin = false;
                   if (is_upto && start >= end) {
                       start = start - dy;
                       if (start <= end) {
                         start = end;
                         is_fin = true;
                       }
                       window.scrollTo(0, start);
                   } else if (!is_upto && start <= end) {
                       start = start + dy;
                       if (start >= end) {
                         start = end;
                         is_fin = true;
                       }
                       window.scrollTo(0, start);
                   } else {
                       window.scrollTo(0, end);
                       return false;
                   }
                   if (is_fin || start == prev_start) {
                     return false;
                   }
                   motion_fn(start, end);
               }, msec);
           };
           motion_fn.call(this, start, end);
           return false;
        };

        $els.each(function() {
            $(this)
               .data(data_name, $(this).attr('href'))
               .click(scroll_fn);
        });
    };
    return this;
})(jQuery);

