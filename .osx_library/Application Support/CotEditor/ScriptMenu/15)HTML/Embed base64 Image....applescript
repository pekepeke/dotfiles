(*

	insert base64 encoded image


[description]	
	encode selected image to base64 and insert it
	at caret position in current document on CotEditor
		
[version]	1.0
[lastmod]	2012-04-14
[author]	1024jp <http://wolfrosch.com/>
[licence]	Creative Commons Attribution-NonCommercial 3.0 Unported License
*)

-- __settings_______________________________________________________________

-- limit file size to execute wishout alert  (KB)
property maxFileSize : 50


-- __main_______________________________________________________________

-- let user to select an image
tell application "CotEditor"
	if exists front document then
		-- file selection dialog
		try
			set imagePath to choose file of type {"png", "jpg", "gif", "tiff", "svg"} with prompt "Select an Image File to Embed"
		on error
			return
		end try
	else
		return
	end if
end tell


-- get file size of the image
tell application "Finder" to set imageSize to size of file imagePath
set imageSize to imageSize / (1000) --KB

-- check image file size
if imageSize > maxFileSize then
	
	-- convert file size to human-readable
	if imageSize > 1000 then
		set HumanImageSize to imageSize / 1000 -- convert to MB
		if HumanImageSize > 10 then
			set HumanImageSize to (round HumanImageSize) & "MB"
		else
			set HumanImageSize to ((round (HumanImageSize * 10)) / 10) & "MB"
		end if
	else
		if imageSize > 10 then
			set HumanImageSize to (round imageSize) & "KB"
		else
			set HumanImageSize to ((round (imageSize * 10)) / 10) & "KB"
		end if
	end if
	
	-- alert
	try
		display alert "The image file you chose is quite large.\n(size: " & HumanImageSize & ")" message "Embedding this as base64 can cause CotEditor to slow down or at worst freeze." & return & return & "Do you really want to continue?" as warning buttons {"Cancel", "Continue"} cancel button "Cancel"
	on error
		return
	end try
end if

tell application "Finder" to set fileExtension to name extension of file imagePath

if fileExtension is "svg" then
	set imageType to "svg+xml"
	
else
	tell application "Image Events"
		set theImage to open imagePath
		set imageType to file type of theImage
	end tell
end if

-- transform imageType to lowercase
set imageType to do shell script "echo '" & imageType & "' | tr '[A-Z]' '[a-z]'"


-- base64 encode
set base64 to do shell script "openssl base64 -in " & quoted form of POSIX path of imagePath

-- add image type
set base64 to "data:image/" & imageType & ";base64," & base64
set base64 to paragraphs of base64 as text

-- insert base64 code into CotEditor document
tell application "CotEditor"
	set {loc, len} to range of selection of front document
	set contents of selection of front document to base64
	set range of selection of front document to {loc + (count of base64), 0}
end tell