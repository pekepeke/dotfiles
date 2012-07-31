#!/usr/bin/perl

use strict;
use warnings;

my $src = <<EOM
set app_name to "CotEditor"
set menu_name to "スクリプト"
set submenu_item to "Dev"

tell application app_name
	activate
end tell

tell application "System Events"
	tell process app_name
		tell menu bar 1
			tell menu bar item menu_name
				tell menu menu_name
					click
					click menu item submenu_item
				end tell
			end tell
		end tell
	end tell
end tell
EOM
;

system "osascript -e '$src'";