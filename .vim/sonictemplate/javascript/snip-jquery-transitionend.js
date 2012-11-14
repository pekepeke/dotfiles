$.fn.transitionEnd = function(fn) {
    var that = this;
    $(that).each(function() {
        var elm = window.getComputedStyle(this, null)
            , duration = elm.webkitTransitionDuration ||
                   elm.MozTransitionDuration ||
                    elm.msTransitionDuration ||
                     elm.oTransitionDuration ||
                      elm.transitionDuration || "0s"
            , msec     = parseInt(parseFloat(duration.replace(/^.*?([\d\.]*)s$/, "$1"), 10) * 1000);
        var receiver = this
            , timer_id = null
            , is_executed = false
            , wrap_fn = function() {
                clearTimeout(timer_id);
                if (is_executed) return;
                is_executed = true;
                fn.apply(receiver, Array.prototype.slice.call(arguments, 0));
            };
            timer_id = setTimeout(wrap_fn, msec + 100);
        $(this)
            .one('webkitTransitionEnd', wrap_fn)
            .one('MozTransitionEnd', wrap_fn)
            .one('mozTransitionEnd', wrap_fn)
            .one('msTransitionEnd', wrap_fn)
            .one('oTransitionEnd', wrap_fn)
            .one('transitionEnd', wrap_fn)
            .one('transitionend', wrap_fn);
    });
};

