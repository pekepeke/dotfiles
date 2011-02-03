var INFO = 
<plugin name="unfuck-google-code" version="0.5"
        href="http://ticket.vimperator.org/111"
        summary="Unfuck Google Code"
        xmlns="http://vimperator.org/namespaces/liberator">
    <author email="maglione.k@gmail.com">Kris Maglione</author>
    <license href="http://opensource.org/licenses/mit-license.php">MIT</license>
    <project name="Vimperator" minVersion="2.0"/>
    <p>
        This plugin unfucks Google Code. In particular, it fixes the mime
        types of certain common attachment and download types, so they may be
        viewed in the browser or externally without first saving them to disk.
    </p>
    <item>
	<tags>plugins.unfuckGoogleCode.extensionTypes</tags>
	<spec>plugins.unfuckGoogleCode.extensionTypes[<a>extension</a>]=<a>mime-type</a></spec>
	<description>
            <html:div style="clear: both" xmlns:html={XHTML}/>
            <p>
                An associative array of mappings between file
                extensions and their mime types. Allows the
                user to override the default mime types for
                certain file extensions.
            </p>
	</description>
    </item>
    <item>
	<tags>plugins.unfuckGoogleCode.patterns</tags>
	<spec>plugins.unfuckGoogleCode.patterns.push(<a>regexp</a>)</spec>
	<description>
            <stut/>
            <p>
                An array of URI patterns for which mime types
                should be updated. The regular expression
                should return one match group, the name of
                the file.
            </p>
	</description>
    </item>
</plugin>;

function HttpFilter(name, store) {
    const TOPIC = "http-on-examine-response";
    const observerService = services.get("observer");
    const mimeService = Cc["@mozilla.org/mime;1"].getService(Ci.nsIMIMEService);

    this.extensionTypes = {
        "vimp":"text/plain",
        "patch":"text/plain",
        "diff":"text/plain",
    };

    this.patterns = [
        RegExp("http://[^\.]+\\.googlecode\\.com/issues/attachment?(?:.*&name|name)=([^&]+)"),
        RegExp("http://[^\.]+\\.googlecode\\.com/files/([^?]+)"),
    ];

    this.observe = function observe(subject, topic, data) {  
        if (topic != TOPIC)
            return;
        let channel = subject.QueryInterface(Ci.nsIHttpChannel);
        for (let [,pattern] in Iterator(this.patterns)) {
            if (m = pattern.exec(channel.name)) {
                m = /\.([^.]*)$/.exec(m[1]) || [0, ".txt"];
                let type = this.extensionTypes[m[1]];
                if (!type)
                    try {
                        type = mimeService.getTypeFromExtension(m[1])
                    } catch (e) {
                        type = "text/plain";
                    }

                if (/^text\//.test(type) && type != 'text/html')
                    type = "text/plain; charset=UTF-8";
                channel.setResponseHeader("Content-Disposition", "inline", false);
                channel.contentType = type;
            };
        }
    };

    this.unregister = function unregister() {
        try {
            observerService.removeObserver(this, TOPIC);
        }
        catch (e) {}
    };
    this.register = function register() {
        observerService.addObserver(this, TOPIC, false);
    };

    this.register();
};

if('http-filter' in storage)
    storage['http-filter'].unregister();

__proto__ = storage.newObject("http-filter", HttpFilter, { store: false, reload: true });

// vim:se sts=4 sw=4 et:
