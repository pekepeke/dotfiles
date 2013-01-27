Function ReadFile(path)
	Dim ret
	Dim Fso, stream
	Const ForReading = 1

	Set Fso = CreateObject("Scripting.FileSystemObject")

	If Fso.FileExists(path) Then
		Set stream = Fso.OpenTextFile(path, ForReading)
		ret = stream.ReadAll
		' Dim line
		' do while Not(stream.AtEndOfStream)
		' 	line = stream.ReadLine
		' loop
		stream.Close
	Else
		'Set stream = Fso.CreateTextFile(path, False)		' ÉtÉ@ÉCÉãçÏê¨
		ret = null
	End If
	set Fso = nothing
	set stream = nothing
	ReadFile = ret
End Function

