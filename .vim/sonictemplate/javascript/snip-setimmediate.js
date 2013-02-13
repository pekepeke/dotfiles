if (!window.setImmediate) {
  window.setImmediate = function(fn, args){
    return window.setTimeout(fn, 0, args);
  };
  window.clearImmediate = window.clearTimeout;
}

