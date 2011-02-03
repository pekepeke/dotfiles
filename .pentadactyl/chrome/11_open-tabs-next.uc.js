/* Open Tabs Next
 *   nanto_vi (TOYAMA Nao), 2006-12-30
 *
 * Open a new tab at the next of the current tab.
 */

(function OpenTabsNext() {

var mOffset = 1;
var mIsOpening = false;

gBrowser.addEventListener("TabOpen", function OTN_onTabOpen(aEvent) {
  mIsOpening = true;
  this.moveTabTo(aEvent.originalTarget, this.selectedTab._tPos + mOffset++);
  mIsOpening = false;
}, false);

gBrowser.addEventListener("TabMove", function OTN_onTabMove(aEvent) {
  if (!mIsOpening)
    mOffset = 1;
}, false);

gBrowser.addEventListener("TabSelect", function OTN_onTabSelect(aEvent) {
  mOffset = 1;
}, false);

gBrowser.addEventListener("TabClose", function OTN_onTabClose(aEvent) {
  var difference = aEvent.originalTarget._tPos - this.selectedTab._tPos;
  if (0 < difference && difference < mOffset)
    mOffset--;
}, false);

})();
