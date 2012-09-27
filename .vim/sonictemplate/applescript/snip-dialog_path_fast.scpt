display dialog GetParentPath((choose file with prompt "Display path of:"))

on GetParentPath(myPath)
  set oldDelimiters to AppleScript's text item delimiters -- always preserve original delimiters
  set AppleScript's text item delimiters to {":"}
  set pathItems to text items of (myPath as text)
  if last item of pathItems is "" then set pathItems to items 1 thru -2 of pathItems -- its a folder
  set parentPath to ((reverse of the rest of reverse of pathItems) as string) & ":"
  (* The above line works better than the more obvious set parentPath to ((items 1 thru -2 of pathItems) as string) & ":"
     because it will not return an error when passed a path for a volume, i.e., "Macintosh HD:", but rather will return ":"
     indicating the desktop is the root of the given path. Andy Bachorski <andyb@APPLE.COM> *)
  set AppleScript's text item delimiters to oldDelimiters -- always restore original delimiters
  return parentPath
end GetParentPath
