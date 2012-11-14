$.fn.lazy = function(fn) {
  var that = this;
  setTimeout(function() {
    fn.apply(that, arguments);
  }, 0);
};
