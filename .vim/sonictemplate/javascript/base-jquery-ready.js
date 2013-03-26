/*global console: true */
jQuery(function($) {
  'use strict';
  var log = function() {
    if (typeof console != 'undefined') {
      console.log(Array.prototype.slice.call(arguments, 0));
    }
  };
  {{_cursor_}}
});
