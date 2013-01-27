	Dim xls
	Dim fso

	Set xls = CreateObject("Excel.Application")
	Set fso = CreateObject("Scripting.FileSystemObject")

	If Not(fso.FileExists(FileName)) then exit sub
	xls.Workbooks.Open filename

	For Each ws In xls.activeworkbook.worksheets
		lastrow = ws.cells.SpecialCells(xlCellTypeLastCell).End(xlDown).Row
	next
	xls.ActiveWorkbook.saved = true
	xls.ActiveWorkbook.close
	xls.quit
	set xls = nothing

