(function (w, r, c) {
  w['r'+r] = w['r'+r] || w['webkitR'+r] || w['mozR'+r] || w['msR'+r] || w['oR'+r] || function(f){ w.setTimeout(f, 1000 / 60); };
  w['c'+c] = w['c'+c] || w['webkitC'+c] || w['mozC'+c] || w['msC'+c] || w['oC'+c] || function(t){ w.clearTimeout(t); };
})(window, 'equestAnimationFrame', 'ancelRequestAnimationFrame');

