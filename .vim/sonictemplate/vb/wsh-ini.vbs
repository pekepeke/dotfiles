Function GetProfileString( strPath, strSection, strEntry )

	Dim objHandle,aData,bFound,strWork,aWork,I

	Set objHandle = Fso.OpenTextFile( strPath, 1 )
	aData = Split( objHandle.ReadAll, vbCrLf )
	objHandle.Close

	GetProfileString = Empty

	bFound = False
	For I = 0 to Ubound( aData )-1
		if bFound then
			if Left( aData( I ), 1 ) = "[" then
				Exit For
			end if

			strWork = LTrim( aData( I ) )
			if Left( strWork, Len(strEntry)) = strEntry then
				aWork = Split( strWork, "=" )
				if Trim(aWork(0)) = strEntry then
					if Ubound( aWork ) = 1 then
						GetProfileString = Trim( aWork( 1 ) )
						Exit For
					end if
				end if
			end if
		end if

		if aData(I) = "[" & strSection & "]" then
			bFound = True
		end if

	Next

End Function

Function WriteProfileString( strPath, strSection, strEntry, strValue )

	Dim objHandle,aData,bFound,strWork,aWork,I,nSection,bReplace

	Set objHandle = Fso.OpenTextFile( strPath, 1 )
	aData = Split( objHandle.ReadAll, vbCrLf )
	objHandle.Close

	bReplace = False

	bFound = False
	For I = 0 to Ubound( aData )-1
		if bFound then
			if Left( aData( I ), 1 ) = "[" then
				Exit For
			end if

			strWork = LTrim( aData( I ) )
			if Left( strWork, Len(strEntry)) = strEntry then
			  aWork = Split( strWork, "=" )
			    if Trim(aWork(0)) = strEntry then
			      if Ubound( aWork ) = 1 then
			        strWork = Trim( aWork( 1 ) )
			        aData( I ) = Replace( aData( I ), strWork, strValue )

			        strWork = Join( aData, vbCrLf )
			        Set objHandle = Fso.OpenTextFile( strPath, 2, True )
			        objHandle.Write strWork
			        objHandle.Close

			        bReplace = True
			      Exit For
			    end if
			  end if
			end if
		end if

		if aData(I) = "[" & strSection & "]" then
			nSection = I
			bFound = True
		end if

	Next

	if not bReplace then
		' セクションはあったが、エントリは無かった
		if bFound then
			aData(nSection) = aData(nSection) & _
				vbCrLf & strEntry & "=" & strValue
			strWork = Join( aData, vbCrLf )
			Set objHandle = Fso.OpenTextFile( strPath, 2, True )
			objHandle.Write strWork
			objHandle.Close

		else
		' セクションも、エントリも無かった
			aData(Ubound( aData )-1) = aData(Ubound( aData )-1) & _
				vbCrLf & "[" & strSection & "]" & _
				vbCrLf & strEntry & "=" & strValue
			strWork = Join( aData, vbCrLf )
			Set objHandle = Fso.OpenTextFile( strPath, 2, True )
			objHandle.Write strWork
			objHandle.Close

		end if
	end if

End Function


