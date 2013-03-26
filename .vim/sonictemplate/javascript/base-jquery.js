!function($) {
  'use strict';
  var log = function() {
    if (typeof console != 'undefined') {
      console.log(Array.prototype.slice.call(arguments, 0));
    }
  };
  $.{{_expr_:substitute(expand('%:t:r'), '\.jquery$', '', 'e') }} = function(element, options) {
    this.options = $.extend({}, this.options, options);
    this.$element = $(element);
    this._init();
  };
  $.extend($.{{_expr_:substitute(expand('%:t:r'), '\.jquery$', '', 'e') }}.prototype, {
    options: {
    },
    _init: function() {
    }
  });

  $.fn.{{_expr_:substitute(expand('%:t:r'), '\.jquery$', '', 'e') }} = function(options) {
    return this.each(function() {
      new $.{{_expr_:substitute(expand('%:t:r'), '\.jquery$', '', 'e') }}(this, options);
    });
  };
  {{_cursor_}}
}(jQuery);

