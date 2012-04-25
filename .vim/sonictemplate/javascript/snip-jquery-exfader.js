var slice = Array.prototype.slice;
$.fn.exFadeIn = function() {
    var args = slice.apply(arguments);
    if (!$.support.opacity) {
        $(this).show();
        for (var i=0, l=args.length; i<l; i++) {
            if (typeof args[i] === "function") {
                args[i].call(this);
                break;
            }
        }
    } else {
        $(this).fadeIn.apply(this, args);
    }
    return this;
};
$.fn.exFadeIn = function() {
    var args = slice.apply(arguments);
    if (!$.support.opacity) {
        $(this).hide();
        for (var i=0, l=args.length; i<l; i++) {
            if (typeof args[i] === "function") {
                args[i].call(this);
                break;
            }
        }
    } else {
        $(this).fadeOut.apply(this, args);
    }
    return this;
};

