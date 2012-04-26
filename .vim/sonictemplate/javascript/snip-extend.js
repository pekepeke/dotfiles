var extend = function(to, fr) {
    if (!fr) return to;
    for (var k in fr) {
        to[k] = fr[k];
    }
    return to;
}

