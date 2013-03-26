(function($) {
  'use strict';
  $.<%= substitute(expand('%:t:r'), '\.jquery$', '', 'e') %> = function(element, options) {
    this.options = $.extend({}, this.options, options);
    this.$element = $(element);
    this._init();
  };
  $.extend($.<%= substitute(expand('%:t:r'), '\.jquery$', '', 'e') %>.prototype, {
    options: {
    },
    _init: function() {
    }
  });

  $.fn.<%= substitute(expand('%:t:r'), '\.jquery$', '', 'e') %> = function(options) {
    return this.each(function() {
      new $.<%= substitute(expand('%:t:r'), '\.jquery$', '', 'e') %>(this, options);
    });
  };
})(jQuery);
