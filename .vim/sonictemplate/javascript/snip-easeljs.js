!function($, G) {
  var ns = $.extend({}, {
    init : init
    , stop : stop
    , tick : tick
  });

  var canvas, stage;
  var rad_unit = Math.PI / 180;
  var g, bg;
  function init() {
    canvas = $('#canvas').get(0);
    stage = new Stage(canvas);
    Ticker.setFPS(32);
    Ticker.addListener(ns);

    g = new Graphics();
    g.beginFill("#000000")
      .drawRect(0,0,canvas.width,canvas.height)
      .endFill();
    bg = new Shape(g);
    bg.x = 0;
    bg.y = 0;
    stage.addChild(bg);

    stage.update();
  }
  function tick() {
    stage.update();
  }
  function stop() {
    Ticker.removeListener(ns);
  }

  function circlarArc(g, center_x, center_y, r, deg1, deg2) {
    var rad1 = deg1 * rad_unit, rad2 = deg2 * rad_unit, diff_rad = (deg2 - deg1) * rad_unit;
    var a_x = r * Math.cos(rad1), a_y = r * Math.sin(rad1);
    var b_x = r * Math.cos(rad2), b_y = r * Math.sin(rad2);
    var rc = r / Math.cos(diff_rad);
    var c_x = rc * Math.cos(rad1 - diff_rad / 2), c_y = rc * Math.cos(rad1 + diff_rad / 2);
    g.moveTo(center_x, center_y)
      .lineTo(a_x, a_y)
      .curveTo(b_x, b_y, c_x, c_y)
      .lineTo(center_x, center_y);
 }

  $(init);
}(jQuery, this);
