function getElementsByClassName(target, el){
  el = el || document;
  if (typeof el.getElementsByClassName === 'function') {
    return el.getElementsByClassName(target);
  }
  var founds = []
    , all = el.all ? el.all : el.getElementsByTagName('*')
    , e, re = new RegExp('(^|\s)' + target + '($|\s)');
  for (var i=0, len=all.length ; i<len ; i++) {
    e = all[i];
    if (re.test(e.className)) founds.push(e);
  }
  return founds;
}

