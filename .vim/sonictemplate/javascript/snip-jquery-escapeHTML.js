$.escapeHTML = function(val) {
  return $('<div>').text(val).html();
};
$.unescapeHTML = function (val) {
  return $('<div>').html(val).text();
};
