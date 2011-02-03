(function(Global){
  var log = function() {
    if (typeof console != 'undefined')
      console.log(Array.prototype.slice.call(arguments, 0));
  };
  if (typeof alert == 'undefined')
    alert = function(m) { (typeof print != 'undefined')? print(m) : WScript.Echo(m); };
  // code
})(this);
