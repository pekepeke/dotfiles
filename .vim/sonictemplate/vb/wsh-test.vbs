Dim sRet
Do While true
	inputStr = inputbox("文字入力(入力なしの場合は終了)", "", sRet)
	If isEmpty(inputStr) Then Exit Do
	If inputStr = "" Then Exit Do
	sRet = test(inputStr)
Loop

Function test( inStr )
	Dim sRet
	test = sRet
End Function

