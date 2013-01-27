Dim sRet
Do While true
	inputStr = inputbox("•¶š“ü—Í(“ü—Í‚È‚µ‚Ìê‡‚ÍI—¹)", "", sRet)
	If isEmpty(inputStr) Then Exit Do
	If inputStr = "" Then Exit Do
	sRet = test(inputStr)
Loop

Function test( inStr )
	Dim sRet
	test = sRet
End Function

