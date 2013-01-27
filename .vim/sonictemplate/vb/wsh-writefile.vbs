Function WriteFile(path, text)
	Dim Fso, stream
	Const ForReading = 1, ForWriting = 2, ForAppending = 8

	Set Fso = CreateObject("Scripting.FileSystemObject")

	Set stream = Fso.CreateTextFile(path, True)			' 強制新規ファイル作成
	Call stream.Write( text )
	stream.Close

	Set Fso = Nothing
	set stream = Nothing
End Function

