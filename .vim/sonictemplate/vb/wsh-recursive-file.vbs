' usage: CScript.exe replaceStr.vbs [File] [findString] [replaceString]
	' 引数処理
	if WScript.Arguments.Count <> 3 then
		Dim m
		m=""
		m=m & "help" & vblf
		m=m & "" & vblf
		WScript.Echo m
		WScript.Quit
	end if

	'For Each argv In WScript.Arguments
	'next
	Set argv = WScript.Arguments
	set objCtl = New ClsFileReplace
	'objCtl.loglevel = 1				' Debug
	objCtl.loglevel = 5
	'objCtl.FindSubFolderFlag = False

	objCtl.findStr = argv(1)
	objCtl.ReplaceStr = argv(2)
	Call objCtl.Main( argv(0) )
	Set objCtl = Nothing


' Class 定義
Class ClsFileReplace
	Dim findStr, replaceStr
	Dim logLevel
	Dim objFso
	Dim FindSubFolderFlag
	Private bFind

	Private Sub Class_Initialize   ' Initialize イベントを設定します。
		findStr = ""
		replaceStr = ""
		Set objFso = CreateObject("Scripting.FileSystemObject")
		logLevel = 5
		FindSubFolderFlag = True
		bFind = false
	End Sub
	Private Sub Class_Terminate   ' Terminate イベントを設定します。
		Set objFs = Nothing
	End Sub

	Sub Main( argv )
		Call TraceOut(1, "Start: argv = " & argv)
		Call scanFolder( argv )

	End Sub

	Sub scanFolder( targetPath )
		Call TraceOut(2, "scanFolder,target = " & targetpath)
		if objFs.FolderExists(targetPath) then ' 存在するフォルダ名?
			Dim objSubFolder, objSrcFolder
			Dim FileName
			Set objSrcFolder = objFs.GetFolder(targetPath)			   ' 対象フォルダの指定
			Set objSubFolder = objSrcFolder.SubFolders

			' 指定のフォルダに格納された各ファイルを処理する
			For Each FileName In objSrcFolder.Files
					Call executeForFile( FileName )
			Next

			for each tmp in objsubfolder
				if FindSubFolderFlag or (FindSubFolderFlag = false And bFind = False) then
					Call scanFolder(targetPath & "\" & tmp.name)	' サブフォルダのファイル処理
				End if
			next
		else
			Call executeForFile( targetPath )
		End If
	End Sub

	Sub executeForFile( FileName )
		bFind = True
		Call TraceOut(2, "executeForFile, target = " & FileName)

		ReplaceString(FileName)
	end Sub

	Sub ReplaceString(FilePath)
		' ファイル読込
		Dim inFilePath													' ファイル読み込み
		Dim WshShell
		Dim stream
		Const ForReading = 1,ForWriting = 2, ForAppending = 8
		Const BACKUP_EXT = ".bak"

		if Len(findStr) < 0 then
			Call TraceOut(2, "ReplaceString, exit(findkey length = 0)")
			exit sub
		end if

		If Not (objFso.FileExists(FilePath)) Then
			Call TraceOut(2, "ReplaceString, exit(not found filepath)")
			Exit Sub
		End If

		Set stream = objFso.OpenTextFile(FilePath, ForReading)

		Dim readBuf
		readBuf = stream.ReadAll
		stream.Close
		set stream = Nothing

		if 0 < inStr( readbuf, findStr) then
			Dim backupFilePath
			backupFilePath = FilePath & BACKUP_EXT
			if Not(objFso.FileExists( backupFilePath )) then
				Call TraceOut(2, "ReplaceString, backup " & FilePath & "->" & backupFilePath)
				Call objFso.CopyFile(FilePath , backupFilePath)
			End if
		End if

		Dim regEx
		Set regEx = New RegExp							' 文字列検索用オブジェクトの作成
		regEx.Pattern = findStr					 ' 検索文字列を検索パターンとして指定
		regEx.Global = True							 ' 文字列全体を検索するように指定
		regEx.IgnoreCase = True						 ' 大文字・小文字は検索に影響しない
		readBuf = regEx.Replace(readBuf, replaceStr)
		//readBuf = Replace( readBuf, findStr, replaceStr)

		Dim outStream
		Set outStream = objFso.OpenTextFile(FilePath, ForWriting)
		Call outStream.Write( readBuf )
		outStream.Close

		set objFso = Nothing
		Set outStream = Nothing
	End Sub


	' ログ出力関数
	Sub TraceOut(level , msg)
	    Dim FilePath
	    Dim stream
	    Const ForReading = 1, ForWriting = 2, ForAppending = 8

	    if logLevel > level then exit sub
	    FilePath = WScript.ScriptFullName & ".log"

	    If Not (objFs.FileExists(FilePath)) Then
	        Set stream = objFs.createtextfile(FilePath, False)
	    Else
	        Set stream = objFs.OpenTextFile(FilePath, ForAppending)
	    End If
	    'stream.WriteLine (FormatDateTime(Now()) & "|" & msg)
	    stream.WriteLine msg
	End Sub

End Class

