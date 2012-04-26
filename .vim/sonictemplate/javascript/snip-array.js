var Arrays = {
    range : function(from, to) {
        var arr = []
        for (var i=(from<to ? from : to), l=(from < to ? to : from);i<=l;i++) arr.push(i);
        return arr;
    },
    each : function(items, callback) {
        for (var i=0, l = items.length;i<l;i++) {
            callback.call(items, items[i], i);
        }
    },
    map : function(items, callback) {
        var arr = [];
        for (var i=0, l=items.length;i<l;i++) {
            arr.push(callback.call(items, items[i], i));
        }
        return arr;
    },
    some : function(items, callback) {
        for (var i=0, l = items.length;i<l;i++) {
            if (callback.call(items, items[i], i)) return items[i];
        }
    },
    filter : function(items, callback) {
        var arr = [];
        for (var i=0, l = items.length;i<l;i++) {
            if (callback.call(items, items[i], i)) arr.push(items[i]);
        }
        return arr;
    },
    every : function(items, callback) {
        for (var i=0,  l = items.length; i<l ;i++) {
            if (!callback.call(items, items[i], i)) {
                return false;
            }
        }
        return true;
    },
    reduce : function(items, callback) {
        var i, l = items.length, cur;

        if ((l <= 0 || l === null) && arguments.length <= 2) {
            throw new Error("invalid arguments", arguments);
        }
        if (arguments.length <= 2) {
            cur = items[0]; i = 1;
        } else {
            cur = arguments[2];
        }

        for (var i= i || 0; i < l; i++) {
            cur = callback.call(items, cur, items[i], i, items);
        }
        return cur;
    },
    shuffle : function(items, callback) {
        var r = Array.prototype.slice.call(items, 0);
        for (var i=0, l=r.length; i<l ;i++) {
            var j = Math.floor(Math.random() * l);
            if (j==i) continue;
            var tmp = r[j]; r[j] = r[i]; r[i] = tmp;
        }
    }
};

