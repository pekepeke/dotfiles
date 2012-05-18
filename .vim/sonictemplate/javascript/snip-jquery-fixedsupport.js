jQuery.ready(function() {

    /**
     * position:fixedサポートの機能的判別 for iOS
     */
    var supported;

    if (typeof document.body.scrollIntoViewIfNeeded === 'function') {

        (function () {
            var container     = document.body,
                el          = document.createElement('div'),
                org_h     = container.style.height,
                org_sctop  = window.pageYOffset,
                test_sctop = 20;

            el.style.cssText = 'position:fixed;top:0px;height:10px;';

            container.appendChild(el);
            container.style.height = '2048px';

            window.setTimeout(function() {
                el.scrollIntoViewIfNeeded();
                supported = !!(window.pageYOffset === test_sctop) || !!(window.pageYOffset === test_sctop+1);

                container.removeChild(el);
                container.style.height = org_h;

                window.scrollTo(0, org_sctop);
            }, 50);
            window.scrollTo(0, test_sctop);
        }());

    } else {
        // scrollIntoViewIfNeededをサポートしないブラウザでの通常判定
        // isSupported = testee();
    }
});

