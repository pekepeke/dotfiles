var mouseEvent = function(id, event_name) {
    var el = document.getElementById(id);
    if (typeof el.fireEvent === 'function') {
        el.fireEvent('on' + event_name);
    } else {
        var event = document.createEvent('MouseEvents');
        event.initEvent(event_name, false, true);
        el.dispatchEvent(event);
    }
};

var keyEvent = function(id, event, keycode) {
    var el = document.getElementById(id);
    if (typeof document.createEventObject === 'function') {
        var event = document.createEventObject();
        event.keyCode = keycode;
        el.fireEvent('on' + event_name, event);
    } else {
        var event = document.createEvent('KeyboardEvent');
        event.initKeyEvent(event_name, true, true, null, false, false, false, false, keycode, 0);
        el.dispatchEvent(event);
    }
};

