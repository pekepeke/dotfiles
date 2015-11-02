## テーブル存在チェック

```
=LEFT(A2, SEARCH(".", A2)-1)
=MID(A2, SEARCH(".", A2)+1, LEN(A2))
=IF(D1<>"", "UNION ALL ",  "")&"select '"&A2&"' name, COUNT(*) cnt from information_schema.tables WHERE table_schema = '"&B2&"' AND table_name = '"&C2&"'"
```

## VBA
### Join 系

```
Function JoinRange(delimiter As String,  rng As Range) As String
	Dim arr
	Dim i As Long
	i = 0
	For Each col In rng
		arr(i) = col.Text
		i = i + 1
	Next
	JoinRange = Join(delimiter,  arr)
End Function


Function ConcatRange(rng As Range) As String
	Dim ret As String
	For Each col In rng
		ret = ret & col.Text
	Next
	ConcatRange = ret
End Function

```

