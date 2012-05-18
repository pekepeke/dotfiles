var can_fixed = (function() {
  var ua = navigator.userAgent
    , is_ios = !!ua.match(/iPhone|iPad|iPod/)
    , is_android = !!ua.match(/Android/)
    , vers = [];
  if (ua.match(/(OS|Android) ([\d\._]+)/)) {
    vers = RegExp.$1.split(/[\._]/);
  }
  return (is_ios && vers[0] >= 5)
    || (is_android && vers[0] > 2)
    || (is_android && vers[0] == 2 && vers[1] >= 2);
})();

