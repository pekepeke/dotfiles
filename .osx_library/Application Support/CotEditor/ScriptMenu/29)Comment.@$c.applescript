(*

	Multi Comment Macro


[description]
	add/remove comment delimiters in the selection intelligently

[version] 1.1
[lastmod] 2012-03-10
[author] 1024jp <http://wolfrosch.com/>
[license] Creative Commons Attribution-NonCommercial 3.0 Unported License

[default key assign]
	Command + Shift + C
	
[supported languages] 
	- default syntax styles on CotEdito 1.3.1
	- Apache, XML, HTML5, SVG, SQL,  Markdown, AppleScript, Go, Scheme, gnuplot, ImageJ, R and ReVIEW
*)



-- __settings___________________________________________________________________

-- characters to insert between selection and comment delimiters
property spacer : " "

-- minimum number of lines to use block comment on languages that have both inline and block comment style
property minBlockCommentLines : 10

-- number of lines to enable loose select mode (disable -> 0)
property looseSelect : 0

-- proportion of commented lines for switching to the uncomment function
property commentLinesRate : 2/ 3


-- __mode_settings_______________________________________________________________

-- toggle mode intelligently
property toggleMode : true

-- set mode to uncomment
property uncomment : false


-- __main_______________________________________________________________________

tell application "CotEditor"
	if exists front document then
		tell front document
			
			
			-- __comment_styles__________________________________________________
			
			-- initialize
			set beginDelimiter to "" -- begin delimiter of block comment
			set endDelimiter to "" -- end delimiter of block comment
			set lineDelimiter to "" -- begin delimiter of line comment
			set allowMiddleOfLine to true -- whether line comments are allowed at the middle of a line
			
			if coloring style is in {"C, C++, Objective-C", "Java", "JavaScript", "PHP", "Go"} then
				set lineDelimiter to "//"
				set beginDelimiter to "/*"
				set endDelimiter to "*/"
				
			else if coloring style is "CSS" then
				set beginDelimiter to "/*"
				set endDelimiter to "*/"
				
			else if coloring style is in {"Perl", "Python", "gnuplot", "R"} then
				set lineDelimiter to "#"
				
			else if coloring style is in {"Shell Script", "Apache"} then
				set lineDelimiter to "#"
				set allowMiddleOfLine to false
				
			else if coloring style is "Ruby" then
				set lineDelimiter to "#"
				-- set beginDelimiter to "=begin" -- only at the beginning of a line
				-- set endDelimiter to "=end"
				
			else if coloring style is in {"XML", "HTML", "HTML5", "HTML5'", "SVG", "Markdown"} then
				set beginDelimiter to "<!--"
				set endDelimiter to "-->"
				
			else if coloring style is "LaTeX" then
				set lineDelimiter to "%"
				
			else if coloring style is "eRuby" then
				set beginDelimiter to "<%#"
				set endDelimiter to "#>"
				
			else if coloring style is "Haskell" then
				set lineDelimiter to "--"
				set beginDelimiter to "{-"
				set endDelimiter to "-}"
				
			else if coloring style is "AppleScript" then
				set lineDelimiter to "--"
				set beginDelimiter to "(*"
				set endDelimiter to "*)"
				
			else if coloring style is "Scheme" then
				set lineDelimiter to ";"
				
			else if coloring style is "SQL" then
				set lineDelimiter to "--"
				
			else if coloring style is "ImageJ" then
				set lineDelimiter to "//"
				
			else if coloring style is "ReVIEW" then
				set lineDelimiter to "#@"
				
				-- (insert additional syntax here)
				
			else
				return
			end if
			
			
			
			-- __body_______________________________________________________________
			
			-- save default AppleScript's delimiters
			set appleDelimiters to AppleScript's text item delimiters
			
			-- get selection's positional data
			set {locLength, selectionLength} to range of selection
			set {locLines, selectionLines} to line range of selection
			
			-- whole lines select
			if not allowMiddleOfLine or ((looseSelect is not 0) and (selectionLines is greater than or equal to looseSelect as number)) then
				set line range of selection to {locLines, selectionLines}
				set {locLength, selectionLength} to range of selection
			end if
			
			-- ignore last line break
			if contents of selection ends with "\n" then set range of selection to {locLength, selectionLength - 1}
			
			-- get contents
			set theSelection to contents of selection
			
			
			
			-- comment-out/uncomment toggle
			set blockUncomment to false
			if (toggleMode or uncomment) and Â
				(theSelection starts with beginDelimiter and theSelection ends with endDelimiter) then
				set blockUncomment to true -- simple block uncomment
				
				
			else if toggleMode and lineDelimiter is not "" then
				set uncomment to false
				
				-- count comment lines
				set AppleScript's text item delimiters to ("\n" & lineDelimiter)
				set commentLines to count (text items of theSelection) -- number of lines +1
				if theSelection starts with lineDelimiter then set commentLines to commentLines + 1
				
				-- evaluate
				if commentLines - 1 > commentLinesRate * selectionLines then
					set uncomment to true
				end if
			end if
			
			
			
			if blockUncomment then -- block uncomment
				-- remove delimiters
				set outStr to my removeHead(theSelection, beginDelimiter, spacer)
				set outStr to my removeTail(outStr, endDelimiter, spacer)
				
				-- set cursor position
				set moveLength to count of character of outStr
				
				
			else if uncomment then -- line uncomment
				-- remove delimiters
				set outStr to ""
				repeat with lineStr in paragraphs of theSelection
					set outStr to outStr & return & my removeHead(lineStr, lineDelimiter, spacer)
				end repeat
				
				-- remove first return
				try
					set outStr to text 2 through -1 of outStr
				on error
					set outStr to ""
				end try
				
				-- set cursor position
				set moveLength to count of character of outStr
				
				
			else if (lineDelimiter is "") or (beginDelimiter is not "" and selectionLines is not less than minBlockCommentLines) then -- block comment-out
				-- add delimiters
				set outStr to beginDelimiter & spacer & theSelection & spacer & endDelimiter
				
				-- set cursor position
				if (selectionLength > 0) then -- has selection
					set moveLength to count of character of outStr
				else -- no selection
					set moveLength to count of character of (beginDelimiter & spacer)
				end if
				
				
			else -- line comment-out
				-- add delimiters
				set AppleScript's text item delimiters to (return & lineDelimiter & spacer)
				set outStr to lineDelimiter & spacer & paragraphs of theSelection
				
				-- set cursor position
				set moveLength to count of character of outStr
			end if
			
			
			-- insert result into front document
			set contents of selection to outStr
			set range of selection to {locLength + moveLength, 0}
			
			-- reset AppleScript's delimiters
			set AppleScript's text item delimiters to appleDelimiters
		end tell
	end if
end tell



-- __subroutines_______________________________________________________________________

on removeHead(theStr, delimiter, spacer)
	try
		if theStr starts with (delimiter & spacer) then
			set theStr to text (1 + (count of character of (delimiter & spacer))) through -1 of theStr
		else if theStr starts with delimiter then
			set theStr to text (1 + (count of character of delimiter)) through -1 of theStr
		end if
	on error
		set theStr to ""
	end try
	
	return theStr
end removeHead


on removeTail(theStr, delimiter, spacer)
	try
		if theStr ends with (spacer & delimiter) then
			set theStr to text 1 through -(1 + (count of character of (delimiter & spacer))) of theStr
		else if theStr ends with delimiter then
			set theStr to text 1 through -(1 + (count of character of delimiter)) of theStr
		end if
	on error
		set theStr to ""
	end try
	
	return theStr
end removeTail
