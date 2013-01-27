Set app = CreateObject("Access.Application")
app.Visible = True
app.OpenCurrentDatabase(MdbPath)
Set db = app.CurrentDb

Set rs = db.OpenRecordset("select count(*) as CNT from " &
dbtablename)
MsgBox rs("cnt")

Set rs = db.OpenRecordset("Select * from DB Where tbl.[fld] like
""*.abc""")
Do Until rs.EOF = True
	MsgBox rs("field")
	rs.MoveNext
Loop

db.Close
app.CloseCurrentDatabase

Set records = Nothing
Set db = Nothing
Set app = Nothing

