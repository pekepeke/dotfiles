var img_true_size = function(image){
    var w = image.width
      , h = image.height
      , mem;
 
    if ( typeof image.naturalWidth !== 'undefined' ) {  // for Firefox, Safari, Chrome
        w = image.naturalWidth;
        h = image.naturalHeight;
 
    } else if ( typeof image.runtimeStyle !== 'undefined' ) {    // for IE
        var run = image.runtimeStyle;
        mem = { w: run.width, h: run.height };  // keep runtimeStyle
        run.width  = "auto";
        run.height = "auto";
        w = image.width;
        h = image.height;
        run.width  = mem.w;
        run.height = mem.h;
    } else {         // for Opera
        mem = { w: image.width, h: image.height };  // keep original style
        image.removeAttribute("width");
        image.removeAttribute("height");
        w = image.width;
        h = image.height;
        image.width  = mem.w;
        image.height = mem.h;
    }
 
    return {width:w, height:h};
};
