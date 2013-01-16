jQuery(function($) {
  var DEBUG = true
  , $window = $(window)
  , $scene1 = $('.scene1');

  var $L = {
    newPos : function get_ypos(x, windowHeight, pos, adjuster, inertia){
      return x + "% " + (-((windowHeight + pos) - adjuster) * inertia)  + "px";
    }
  };

  $('.scene').on('inview', function(e, visible) {
    if (visible) {
      $(this).addClass('inview');
    } else {
      $(this).removeClass('inview');
    }
  });

  function on_move() {
    if ($scene1.hasClass("inview")) {
      // do something
      {{_cursor_}}
    }
  }

  $window.on('resize', function() {
    on_move();
  }).on('scroll', function() {
    on_move();
  });

  function newPos(x, windowHeight, pos, adjuster, inertia){
    return x + "% " + (-((windowHeight + pos) - adjuster) * inertia)  + "px";
  }
  function debug(msg){
    if(DEBUG && 'console' in window && 'log' in window.console){
      console.log(msg);
    }
  }
});

