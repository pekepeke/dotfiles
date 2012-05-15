$.fn.extend({
  naturalWidth : function() {
    return $(this).naturalSize().w;
  }
  , naturalHeight : function() {
    return $(this).naturalSize().h;
  }
  , naturalSize : function() {
    var img = this.get(0)
      , w, h, org;
    if (typeof img.naturalWidth !== 'undefined') {
      w = img.naturalWidth;
      h = img.naturalHeight;
    } else if (typeof img.runtimeStyle !== 'undefined') { // ie
      var rtm = img.runtimeStyle;
      org = { w : rtm.width, h : rtm.height };
      rtm.width = 'auto';
      rtm.height = 'auto';
      w = img.width;
      h = img.height;
      rtm.width = org.w;
      rtm.height = org.h;
    } else { // opera
      org = { w : img.width, h : img.height };
      img.removeAttribute('width');
      img.removeAttribute('height');
      w = img.width;
      h = img.height;
      img.width = org.w;
      img.height = org.h;
    }
    return { w : w, h : h };
  }
});
