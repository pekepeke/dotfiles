$.support.fixedPosition = (function(){
    var container = document.body;

    if (document.createElement && container && 
      container.appendChild && container.removeChild) {
      var el = document.createElement('div');

      if (!el.getBoundingClientRect) return null;

      el.innerHTML = 'x';
      el.style.cssText = 'position:fixed;top:100px;';
      container.appendChild(el);

      var org_h = container.style.height,
          originalScrollTop = container.scrollTop;

      container.style.height = '3000px';
      container.scrollTop = 500;

      var el_top = el.getBoundingClientRect().top;
      container.style.height = org_h;

      container.removeChild(el);
      container.scrollTop = originalScrollTop;

      return el_top === 100;
    }
    return null;
}());


