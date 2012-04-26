var include = function (assetURL) {
    var script = document.createElement('script');
    script.src = assetURL;
    script.type = "text/javascript";
    script.defer = true;
    document.getElementsByTagName('head').item(0).appendChild(script);
};

