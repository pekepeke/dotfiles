Sub Log(msg)
	Dim LogPath
	Dim Fso, stream
	Const ForReading = 1, ForWriting = 2, ForAppending = 8

	LogPath = WScript.ScriptFullName & ".log"

	Set Fso = CreateObject("Scripting.FileSystemObject")

	If Not (Fso.FileExists(LogPath)) Then
		Set stream = Fso.createtextfile(LogPath, False)
	Else
		Set stream = Fso.OpenTextFile(LogPath, ForAppending)
	End If
	stream.WriteLine (FormatDateTime(Now()) & "|" & msg)
End Sub

