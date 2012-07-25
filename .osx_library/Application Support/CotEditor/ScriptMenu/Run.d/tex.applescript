(* written by satomacoto *)
on run {thispath}
	--set theposix to "/Applications/pTeX.app/"
	set theposix to "/Applications/UpTeX.app/"
	
	if (thispath is not "") then
		set thecom1 to (do shell script "PLATEX='platex';CLASS=`sed -n '/documentclass/p' " & thispath & " | sed '/%.*documentclass/d' | sed -n '1p'`;case $CLASS in	*{u*)	PLATEX='uplatex'	;;	esac;echo $PLATEX")
		set thisbase to (do shell script "/usr/bin/basename " & thispath)
		set thisdir to (do shell script "/usr/bin/dirname " & thispath)
		set thisbase1 to (do shell script "/usr/bin/basename " & thispath & " .tex")
		set thecode to (do shell script theposix & "teTeX/bin/nkf -g " & thispath)
		if thecode = "UTF-8" then
			set thecode to " -kanji=utf8 "
		else if thecode = "EUC-JP" then
			set thecode to " -kanji=euc "
		else if thecode = "ISO-2022-JP" then
			set thecode to " -kanji=jis "
		else if thecode = "Shift_JIS" then
			set thecode to " -kanji=sjis "
		else
			set thecode to " "
		end if
		
		tell application "Terminal"
			activate
			do script with command "cd " & thisdir & ";" & theposix & "teTeX/bin/" & thecom1 & thecode & thisbase & ";" & theposix & "teTeX/bin/jbibtex" & thecode & thisbase1 & ";" & theposix & "teTeX/bin/" & thecom1 & thecode & thisbase & ";" & theposix & "teTeX/bin/" & thecom1 & thecode & thisbase & ";" & theposix & "teTeX/bin/dvipdfmx " & thisbase1 & ".dvi;open -g -a Preview.app " & thisbase1 & ".pdf;exit;"
		end tell
	end if
	activate
end run
