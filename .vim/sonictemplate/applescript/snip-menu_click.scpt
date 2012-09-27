on menuClick(mList)
	local appName, topMenu, r
	
	-- Validate our input
	if mList's length < 3 then error "Menu list is not long enough"
	
	-- Set these variables for clarity and brevity later on
	set {appName, topMenu} to (items 1 through 2 of mList)
	set r to (items 3 through (mList's length) of mList)
	
	-- This overly-long line calls the menuClickRecurse function with
	-- two arguments: r, and a reference to the top-level menu
	tell application "System Events" to my menuClickRecurse(r, ((process appName)'s ¬
		(menu bar 1)'s (menu bar item topMenu)'s (menu topMenu)))
end menuClick


on menuClickRecurse(mList, parentObject)
	local f, r
	
	-- `f` = first item, `r` = rest of items
	set f to item 1 of mList
	if mList's length > 1 then set r to (items 2 through (mList's length) of mList)
	
	-- either actually click the menu item, or recurse again
	tell application "System Events"
		if mList's length is 1 then
			click parentObject's menu item f
		else
			my menuClickRecurse(r, (parentObject's (menu item f)'s (menu f)))
		end if
	end tell
end menuClickRecurse

-- tell application "Terminal" to activate
-- menuClick({"Terminal", "Shell", "New Window", "Pro"})
