function getStackTrace() {
    var callstack = [];
    var is_callstack_populated = false;
    var lines, i, len;
    try {
        i.dont.exist+=0;
    } catch(e) {
        if (e.stack) { //Firefox or latest chrome
            lines = (e.stack + "").split("\n");
            if (false) {
                for (i=0, len=lines.length; i<len; i++) {
                    if (lines[i].match(/^\s*[A-Za-z0-9\-_\$]+\(/)) {
                        callstack.push(lines[i]);
                    }
                }
            } else {
                lines.shift();
                callstack = callstack.concat(lines);
            }
            //Remove call to self
            callstack.shift();
            is_callstack_populated = true;
        } else if (window.opera && e.message) { //Opera
            lines = e.message.split('\n');
            for (i=0, len=lines.length; i<len; i++) {
                if (lines[i].match(/^\s*[A-Za-z0-9\-_\$]+\(/)) {
                    var entry = lines[i];
                    //Append next line also since it has the file info
                    if (lines[i+1]) {
                        entry += ' at ' + lines[i+1];
                        i++;
                    }
                    callstack.push(entry);
                }
            }
            //Remove call to printStackTrace()
            callstack.shift();
            is_callstack_populated = true;
        }
    }
    if (!is_callstack_populated) { //IE and Safari
        var context = arguments.callee.caller;
        while (context) {
            var fn = context.toString();
            var fname = fn.substring(fn.indexOf("function") + 8, fn.indexOf('')) || 'anonymous';
            callstack.push(fname);
            context = context.caller;
        }
    }
    return callstack.join("\n");
}

