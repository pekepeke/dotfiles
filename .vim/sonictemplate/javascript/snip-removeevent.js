var removeEvent = function(obj, type, func){
    if (obj.removeEventListener) obj.removeEventListener(type, func, false);
    else if (obj.detachEvent) obj.detachEvent('on' + type, func);
};

