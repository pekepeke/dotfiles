(function() {   // fallbacks
  // @see http://code.jquery.com/jquery-1.8.3.js
  if (!$.browser) {
    var matched, browser;

    var detect = function( ua ) {
      ua = ua.toLowerCase();

      var match = /(chrome)[ \/]([\w.]+)/.exec(ua) ||
        /(webkit)[ \/]([\w.]+)/.exec(ua) ||
        /(opera)(?:.*version|)[ \/]([\w.]+)/.exec(ua) ||
        /(msie) ([\w.]+)/.exec(ua) ||
        ua.indexOf("compatible") < 0 && /(mozilla)(?:.*? rv:([\w.]+)|)/.exec(ua) ||
        [];

      return {
        browser: match[1] || "",
        version: match[2] || "0"
      };
    };

    matched = detect(navigator.userAgent);
    browser = {};

    if (matched.browser) {
      browser[matched.browser] = true;
      browser.version = matched.version;
    }

    if (browser.chrome) { // Chrome is Webkit, but Webkit is also Safari.
      browser.webkit = true;
    } else if (browser.webkit) {
      browser.safari = true;
    }
    $.uaMatch = $.uaMatch || detect;
    $.browser = browser;
  }
  if (!$.fn.live) {
    $.fn.live = function(types, data, fn) {
      $(this.context).on(types, this.selector, data, fn);
      return this
    }
  }
  if (!$.fn.bind) {
    $.fn.bind = function(e,t,n) { return this.on(e, null, t, n); };
  }
})(jQuery);
