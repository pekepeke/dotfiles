// Adds HTTP headers to the :pageinfo command.
// Requires the LiveHTTPHeaders extension.
// :set pageinfo <Tab>
//  h   Request Headers
//  H   Response Headers
//
// @author Kris Maglione <maglione.k at Gmail>
// @version 0.1

/* Why so complicated? */
function getHeaders(type) {
    let doc = content.document;
    let win = doc.defaultView;
    let headers;

    // Look to see if the minimum requirement is there
    if ("defaultView" in doc && "controllers" in win) {
        if ("_liveHttpHeaders" in win)
            headers = win._liveHttpHeaders;
        else {
            let controllers = win.controllers;
            while (controllers.wrappedJSObject)
                controllers = controllers.wrappedJSObject;
            try {
              let controller = controllers.getControllerForCommand("livehttpheaders");
            } catch (e) {
              yield ['CONSTRAINT', 'httpheaders.js need livehttpheaders add-on.'];
              yield ['INSTALL', 'from https://addons.mozilla.org/ja/firefox/addon/3829'];
              return;
            }

            // The controller might be wrapped multiple times
            while (controller && !("headers" in controller))
                controller = controller.wrappedJSObject;
            if (controller && controller.url == win.location.href)
                headers = controller.headers;
        }
    }

    if (!headers)
        return;
    yield [type.toUpperCase(), headers[type]];
    for (let [k, v] in Iterator(headers[type + "Headers"]))
        for (let [,val] in Iterator(v.split("\n")))
            yield [k, val];
}

buffer.addPageInfoSection("h", "Request Headers", function (verbose) {
      if (verbose) return getHeaders('request');
});

buffer.addPageInfoSection("H", "Response Headers", function (verbose) {
      if (verbose) return getHeaders('response');
});

