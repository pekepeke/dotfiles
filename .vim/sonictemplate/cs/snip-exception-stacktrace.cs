StackTrace trace = new StackTrace(ex, true); //第二引数のtrueがファイルや行番号をキャプチャするため必要
foreach(var frame in trace.GetFrames){
	Console.WriteLine(frame.GetFileName());     //filename
	Console.WriteLine(frame.GetFileLineNumber());   //line number
	Console.WriteLine(frame.GetFileColumnNuber());  //column number
}

