var params = function(name) {
    if (!this.params) {
        var url = window.location.href;
        var p = url.indexOf('?');
        var arr = p != -1 ? url.substring(p+1, url.length).split('&') : [];
        this.params = {};
        for (var i=0, l=arr.length; i<l ; i++) {
            var v = arr[i].split('=');
            this.params[v[0]] = v[1];
        }
    }
    return typeof name == 'undefined' ? this.params : this.params[name];
};

