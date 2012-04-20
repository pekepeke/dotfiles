$.extend({
    range:  function() {
        if (!arguments.length) { return []; }
        var min, max, step, tmp, a = [];
        if (arguments.length == 1) {
            min  = 0;
            max  = arguments[0] - 1;
            step = 1;
        } else {
            min  = arguments[0];
            max  = arguments[1] - 1;
            step = arguments[2] || 1;
        }
        // convert negative steps to positive and reverse min/max
        if (step < 0 && min >= max) {
            step *= -1;
            tmp = min; min = max; max = tmp;
            min += ((max-min) % step);
        }
        for (var i = min; i <= max; i += step) { a.push(i); }
        return a;
    }
});
