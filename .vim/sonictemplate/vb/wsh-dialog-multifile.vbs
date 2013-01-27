Function ShowMultiSelectDialog()
	Dim comDlg
	Dim retAry, aryFile, arySize
	Dim i

	Set comDlg = CreateObject("MSComDlg.CommonDialog")
	comDlg.MaxFileSize = 256
	'複数のファイル選択＆エクスプローラ風
	comDlg.Flags = &H0200 or &H080000
	'comDlg.DialogTitle = "CSVファイルを指定"
	'comDlg.Filter = "CSVファイル(*.csv)|*.csv|MS-Office ファイル(*.xls)(*.doc)|*.xls;*.doc|全ファイル(*.*)|*.*"
	'comDlg.InitDir = CreateObject("WScript.Shell").CurrentDirectory

	comDlg.ShowOpen()

	aryFile = split(comDlg.FileName, chr(0))
	arySize = UBound(aryFile) - 1
	If arySize < 0 Then
		arySize = 0
		ReDim retAry(0)
		retAry(0) = comDlg.Filename
	Else
		ReDim retAry(arySize)
		retAry(LBound(retAry)) = aryFile(LBound(aryFile))
		For i = LBound(aryFile) + 1 To UBound(aryFile)
			retAry(i - 1) = aryFile(LBound(aryFile)) & "\" & aryFile(i)
		Next
	End If

	ShowMultiSelectDialog = retAry
	'for i = lbound(retary) to ubound(retary)
	'	msg = msg & retary(i) & vblf
	'next
	'msgbox msg
End Function

