Const HKEY_CLASSES_ROOT  = &H80000000
Const HKEY_CURRENT_USER  = &H80000001
Const HKEY_LOCAL_MACHINE = &H80000002
Const HKEY_USERS         = &H80000003

' Object used to get StdRegProv Namespace
Set wmiLocator = CreateObject("WbemScripting.SWbemLocator")

' Object used to determine local machine name
Set wshNetwork = CreateObject("WScript.Network")

' Registry Provider (StdRegProv) lives in root\default namespace.
Set wmiNameSpace = wmiLocator.ConnectServer(wshNetwork.ComputerName, "root\default")
Set objRegistry = wmiNameSpace.Get("StdRegProv")

' Example Deletion of Value
sPath = "SOFTWARE\ABC"

lRC = DeleteRegEntry(HKEY_LOCAL_MACHINE, sPath)

Function DeleteRegEntry(sHive, sEnumPath)
	' Attempt to delete key.  If it fails, start the subkey
	' enumration process.
	lRC = objRegistry.DeleteKey(sHive, sEnumPath)

	' The deletion failed, start deleting subkeys.
	If (lRC <> 0) Then

		' Subkey Enumerator
		On Error Resume Next

		lRC = objRegistry.EnumKey(sHive, sEnumPath, sNames)

		For Each sKeyName In sNames
			If Err.Number <> 0 Then Exit For
			lRC = DeleteRegEntry(sHive, sEnumPath & "\" & sKeyName)
		Next

		On Error Goto 0

		' At this point we should have looped through all subkeys, trying
		' to delete the registry key again.
		lRC = objRegistry.DeleteKey(sHive, sEnumPath)

	End If
End Function

