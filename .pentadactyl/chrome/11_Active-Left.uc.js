/* ------------------------------------
 * script : Active-Left
 * author : sasa+1
 * xyzzy  : -*- Encoding: utf8n -*-
 * --------------------------------- */

(function()
{
    gBrowser.removeTabAnother = gBrowser.removeTab;
    gBrowser.removeTab = function(aTabElement)
    {
        if (aTabElement.selected)
        {
            gBrowser.mTabContainer.advanceSelectedTab(-1, false);
        }

        gBrowser.removeTabAnother(aTabElement);
    }
})();

