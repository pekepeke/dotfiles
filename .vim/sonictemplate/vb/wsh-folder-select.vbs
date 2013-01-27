Function BrowseFolder(root)
	Dim folder

	' フォルダ選択ダイアログを表示
	Set folder = CreateObject("Shell.Application") _
			.BrowseForFolder(0, "Select Folder", 1, root)

	' 選択内容を取得
	If Not (folder Is Nothing) Then
		BrowseFolder = folder.Items.Item.Path
		Set folder = Nothing
	End If

End Function

