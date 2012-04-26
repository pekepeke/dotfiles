var callJSONP = function(url) {
    var el = document.createElement('script');
    el.charset = 'utf-8';
    el.src = url;
    document.body.appendChild(el);
};

