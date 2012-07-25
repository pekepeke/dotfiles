#!/opt/local/bin/js
// %%%{CotEditorXInput=Selection}%%%
// %%%{CotEditorXOutput=ReplaceSelection}%%%

var l = '';
var selectedText = '';
while (l = readline()) {
    selectedText += l;
}

/*********************************************************************
/ * 各種定数定義
/ *********************************************************************/
/*
 * 文字種別
 */
CNS_NORMAL=0; // 通常種別
CNS_CHAR=1; // SQL中の文字列を表す種別「' … '」
CNS_DC=2; // SQL中の文字列を表す種別「" … "」
CNS_COMMENT_1=3; // SQL中のコメントを表す種別「/* … */」
CNS_COMMENT_2=4; // SQL中のコメントを表す種別「-- … 」
CNS_HINT=5; // SQL中のヒント句を表す種別「/*+ … */ 」
CNS_RM=-1; // 除去対象となる文字を表す種別

print (fixSQL(selectedText));

quit();

/*********************************************************************
 * 関数定義
 *********************************************************************/
/*
 * 最新バージョン取得
 */
function getLastVer() {
	var str;
	str = "Ver 1.00";
	return str;
}

/*
 * SQL整形処理実行
 */
function doExec() {
	var sqltext;

	// 整形したSQL文を取得する。
	sqltext = fixSQL(getSQLTextValue());

	// 整形したSQL文を"SQLFORM"に設定する。
	setSQLTextValue(sqltext);
}

/*
 * "SQLFORM"の記載内容を取得
 */
function getSQLTextValue() {
	return document.SQLFORM.SQLText.value;
}

/*
 * "SQLFORM"の記載内容を更新
 */
function setSQLTextValue(val) {
	document.SQLFORM.SQLText.value=val;
}

/*
 * ChangeCaseラジオボタンの選択状態取得
 */
function getChangeCase() {
    // 大文字変換
    return "UCase";
    // 小文字変換
    //return "LCase";
    // 変換なし
    //return "NOChange";
}

/*
 * CommaPosラジオボタンの選択状態取得
 */
function getCommaPos() {
	// 「,」カンマを行頭に配置する
	return "Top";
	// 「,」カンマを行末に配置する
	//return "End";
}

/*
 * AndPosラジオボタンの選択状態取得
 */
function getAndPos() {
	// WHERE句の「AND」、「OR」を行頭に配置する
	return "Top";
	// WHERE句の「AND」、「OR」を行末に配置する
	//return "End";
}

/*
 * CommentPosラジオボタンの選択状態取得
 */
function getCommentPos() {
	var ret;
	if(document.CommentRadio==undefined) {
		return "Top";
	}
	if(document.CommentRadio[0].checked==true){
		ret=document.CommentRadio[0].value;
	}else if(document.CommentRadio[1].checked==true){
		ret=document.CommentRadio[1].value;
	}
    return ret;
}

/*
 * TabSelectセレクトリストの選択状態取得
 */
function getTabSelect() {
    // タブ幅
	return 4;
}

/*
 * インデントを作成
 */
function makeTabSpace(iLevel,tabSize) {
	// ハードタブを使いたい方は以下の行をアンコメントしてください
	//return "＼t";
	var ret;
	ret="";
	for(i=0;i<(iLevel*tabSize);i++) {
		ret=ret+" ";
	}
	return ret;
}

/*
 * テキストのサイズの初期化
 */
function intTextAreaSize(textAreaName) {
	// 行数：20
	textAreaName.rows=20;
	// 列数：80
	textAreaName.cols=80;
	// テキストエリアサイズの表示
	writeTextAreaSize(textAreaName);
}

/*
 * テキストのサイズ変更
 */
function ChangeTextAreaSize(textAreaName,pRowSize,pClmSize){
	// 行数の増減
	if((textAreaName.rows+pRowSize)>=10) {
		textAreaName.rows=textAreaName.rows+pRowSize;
	}
	// 列数の増減
	if((textAreaName.cols+pClmSize)>=10) {
		textAreaName.cols=textAreaName.cols+pClmSize;
	}
	// テキストエリアサイズの表示
	writeTextAreaSize(textAreaName);
}

/*
 * SQLテキストエリアのサイズ表示
 */
function writeTextAreaSize(textAreaName){
	if(document.getElementById) {
		//e5,e6,n6,n7,m1,o7,s1用
		document.getElementById("RowColumns").innerHTML="Rows："+textAreaName.rows+"/Cols："+textAreaName.cols;
	}else if(document.all){
		//e4用
		document.all("RowColumns").innerHTML="Rows："+textAreaName.rows+"/Cols："+textAreaName.cols;
	}else if(document.layers) {
		//n4用
		with(document.layers['RowColumns'].document){
		open();
		write("Rows："+textAreaName.rows+"/Cols："+textAreaName.cols);
		close();
		}
	}
}

/*
 * メアド戻し
 */
function GettingMailAddress() {
	var str;
	str = "<a href=\"mailto:&#105nf&#111&#64&#115e&#105&#106&#105&#45t&#115ub&#111&#115ak&#105&#46net\"  TITLE=\"作者へメールします。\">メール</a>　←　ご意見・ご感想をお持ちしております。";
	return str;
}

/*
 * CopyRight作成
 */
function CopyRightString() {
	var str;
	str = "copyright(c) SEIJI TSUBOSAKI 2007 all rights reserved.";
	return str;
}

/*
 * 右端から指定文字数抜出す
 */
function substrRight(str,n) {
	var ret;
	ret=str.substr(str.length-n,n);
    return ret;
}

/*
 * 左端から指定文字数抜出す
 */
function substrLeft(str,n) {
	var ret;
	ret=str.substr(0,n);
    return ret;
}

/*
 * 文字列の一部を置換
 */
function changeStr(str1,n,str2) {
	var ret;
	ret=substrLeft(str1,n-1)+str2+substrRight(str1,str1.length-n);
    return ret;
}

/*
 * 両端の空白を除去する
 */
function trimLR(str) {
    return trimR( trimL( str ) );
}

/*
 * 左端の空白を除去する
 */
function trimL(str) {
    var x;
    for(x=0; str.charCodeAt(x) < 33 && x < str.length; x++);
    return str.substring(x, str.length);
}

/*
 * 右端の空白を除去する
 */
function trimR(str) {
    var x;
    for(x = str.length; str.charCodeAt(--x) < 33 && x > 0; );
    return str.substring(0, x + 1);
}

/*
 * n個のメンバを持つ配列を作成
 */
function makeArray(n) {
	var i;
	this.length=n;
	for(i=0;i<n;i++) {
		this[i]="";
	}
	return this;
}

/*
 * SQL文を構成する文字の属性を作成
 * chr … SQLを構成する文字そのもの
 * typ … SQLを構成する文字の文字種別
 * idtf … SQLを構成する文字のインデント情報(前)
 * idtb … SQLを構成する文字のインデント情報(後)
 */
function SQLCharAttribute(chr, typ, idtf, idtb) {
	this.chr = chr;
	this.typ = typ;
	this.idtf = idtf;
	this.idtb = idtb;
}

/*
 * SQL文を構成する文字の属性配列の拡張
 * pSqlChr … SQLを構成する文字の属性配列
 * p … 配列拡張先の番地
 * n … 配列拡張数
 */
function resizeSQLCharAttribute(pSqlChr, p, n) {
	var i;
	retSqlChr = new makeArray(pSqlChr.length+n);
	for (i=0;i<p;i++) {
		retSqlChr[i]=pSqlChr[i];
	}
	for (i=p;i<p+n;i++) {
		retSqlChr[i]=new SQLCharAttribute("", "", "", "");
	}
	for (i=p+n;i<=retSqlChr.length;i++) {
		retSqlChr[i]=pSqlChr[i-n];
	}
	return retSqlChr;
}

/*
 * SQL文を構成するキーワードの番地検索
 * pSqlChr … SQLを構成するキーワードの属性
 * typ … SQLを構成する文字の文字種別
 * s … 検索開始
 * p … 検索対象
 */
function searchSQLKeyWordPos(pSqlChr,typ,s,p) {
	var i;
	var cnt;
	cnt=0;
	if(p>0) {
		for(i=s;i<=pSqlChr.length;i++) {
			if(pSqlChr[i].typ==typ) {
				cnt=cnt+1;
				if(cnt==p) {
					return i;
				}
			}
		}
	}else {
		for (i=s;i>=1;i--) {
			if(pSqlChr[i].typ==typ) {
				cnt=cnt+1;
				if(cnt==(-1*p)) {
					return i;
				}
			}
		}
	}
	return 0;
}

/*
 * SQL文を構成するキーワードの検索
 * pSqlChr … SQLを構成するキーワードの属性
 * typ … SQLを構成する文字の文字種別
 * s … 検索開始
 * p … 検索対象
 */
function searchSQLKeyWordChr(pSqlChr,typ,s,p) {
	var i;
	var cnt;
	cnt=0;
	if(p>0) {
		for(i=s;i<=pSqlChr.length;i++) {
			if(pSqlChr[i].typ==typ) {
				cnt=cnt+1;
				if(cnt==p) {
					return pSqlChr[i].chr;
				}
			}
		}
	}else {
		for (i=s;i>=1;i--) {
			if(pSqlChr[i].typ==typ) {
				cnt=cnt+1;
				if(cnt==(-1*p)) {
					return pSqlChr[i].chr;
				}
			}
		}
	}
	return "";
}

/*
 * SQL文コマンドの番地検索
 * pSqlChr … SQLを構成するキーワードの属性
 * s … 検索開始
 * p … 検索対象
 */
function searchSQLCommandPos(pSqlChr,s,p) {
	var i;
	var cnt;
	cnt=0;
	if(p>0) {
		for(i=s;i<=pSqlChr.length;i++) {
			if(pSqlChr[i].chr.toUpperCase()=="SELECT"
				|| pSqlChr[i].chr.toUpperCase()=="INSERT"
				|| pSqlChr[i].chr.toUpperCase()=="DELETE"
				|| pSqlChr[i].chr.toUpperCase()=="UPDATE"
				|| pSqlChr[i].chr.toUpperCase()=="MERGE"
				|| pSqlChr[i].chr.toUpperCase()=="CREATE"
				|| pSqlChr[i].chr.toUpperCase()=="ALTER"
				|| pSqlChr[i].chr.toUpperCase()=="FROM") {
				cnt=cnt+1;
				if(cnt==p) {
					return i;
				}
			}
		}
	}else {
		for (i=s;i>=1;i--) {
			if(pSqlChr[i].chr.toUpperCase()=="SELECT"
				|| pSqlChr[i].chr.toUpperCase()=="INSERT"
				|| pSqlChr[i].chr.toUpperCase()=="DELETE"
				|| pSqlChr[i].chr.toUpperCase()=="UPDATE"
				|| pSqlChr[i].chr.toUpperCase()=="MERGE"
				|| pSqlChr[i].chr.toUpperCase()=="CREATE"
				|| pSqlChr[i].chr.toUpperCase()=="ALTER"
				|| pSqlChr[i].chr.toUpperCase()=="FROM") {
				cnt=cnt+1;
				if(cnt==(-1*p)) {
					return i;
				}
			}
		}
	}
	return 0;
}

/*
 * SQL文コマンドの検索
 * pSqlChr … SQLを構成するキーワードの属性
 * s … 検索開始
 * p … 検索対象
 */
function searchSQLCommandChr(pSqlChr,s,p) {
	var i;
	var cnt;
	cnt=0;
	if(p>0) {
		for(i=s;i<=pSqlChr.length;i++) {
			if(pSqlChr[i].chr.toUpperCase()=="SELECT"
				|| pSqlChr[i].chr.toUpperCase()=="INSERT"
				|| pSqlChr[i].chr.toUpperCase()=="DELETE"
				|| pSqlChr[i].chr.toUpperCase()=="UPDATE"
				|| pSqlChr[i].chr.toUpperCase()=="MERGE"
				|| pSqlChr[i].chr.toUpperCase()=="CREATE"
				|| pSqlChr[i].chr.toUpperCase()=="ALTER"
				|| pSqlChr[i].chr.toUpperCase()=="VALUES") {
				cnt=cnt+1;
				if(cnt==p) {
					return pSqlChr[i].chr;
				}
			}
		}
	}else {
		for (i=s;i>=1;i--) {
			if(pSqlChr[i].chr.toUpperCase()=="SELECT"
				|| pSqlChr[i].chr.toUpperCase()=="INSERT"
				|| pSqlChr[i].chr.toUpperCase()=="DELETE"
				|| pSqlChr[i].chr.toUpperCase()=="UPDATE"
				|| pSqlChr[i].chr.toUpperCase()=="MERGE"
				|| pSqlChr[i].chr.toUpperCase()=="CREATE"
				|| pSqlChr[i].chr.toUpperCase()=="ALTER"
				|| pSqlChr[i].chr.toUpperCase()=="VALUES") {
				cnt=cnt+1;
				if(cnt==(-1*p)) {
					return pSqlChr[i].chr;
				}
			}
		}
	}
	return "";
}

/*
 * シーケンスオブジェクト作成キーワードのチェック
 * str … キーワード
 */
function checkSequenceKey(str) {
	if(str.toUpperCase()=="INCREMENT"
		|| str.toUpperCase()=="START"
		|| str.toUpperCase()=="MAXVALUE"
		|| str.toUpperCase()=="NOMAXVALUE"
		|| str.toUpperCase()=="MINVALUE"
		|| str.toUpperCase()=="NOMINVALUE"
		|| str.toUpperCase()=="CYCLE"
		|| str.toUpperCase()=="NOCYCLE"
		|| str.toUpperCase()=="CACHE"
		|| str.toUpperCase()=="NOCACHE"
		|| str.toUpperCase()=="NOORDER") {
		return 1;
	}else {
		return 0;
	}
}


/*
 * ユーザ作成キーワードのチェック
 * str … キーワード
 */
function checkUserKey(str) {
	if(str.toUpperCase()=="IDENTIFIED"
		|| str.toUpperCase()=="DEFAULT"
		|| str.toUpperCase()=="TEMPORARY"
		|| str.toUpperCase()=="QUOTA"
		|| str.toUpperCase()=="PROFILE"
		|| str.toUpperCase()=="PASSWORD"
		|| str.toUpperCase()=="ACCOUNT") {
		return 1;
	}else {
		return 0;
	}
}

/*
 * CREATE TABLE作成キーワードのチェック
 * str … キーワード
 */
function checkCreateTableKey(str) {
	if(str.toUpperCase()=="TABLESPACE"
		|| str.toUpperCase()=="ENABLE"
		|| str.toUpperCase()=="DISABLE"
		|| str.toUpperCase()=="CHUNK"
		|| str.toUpperCase()=="PCTVERSION"
		|| str.toUpperCase()=="RETENTION"
		|| str.toUpperCase()=="FREEPOOLS"
		|| str.toUpperCase()=="CACHE"
		|| str.toUpperCase()=="NOCACHE"
		|| str.toUpperCase()=="LOGGING"
		|| str.toUpperCase()=="NOLOGGING"
		|| str.toUpperCase()=="PARTITION"
		|| str.toUpperCase()=="SUBPARTITION"
		|| str.toUpperCase()=="COMPRESS"
		|| str.toUpperCase()=="NOCOMPRESS"
		|| str.toUpperCase()=="PCTFREE"
		|| str.toUpperCase()=="PCTUSED"
		|| str.toUpperCase()=="INITRANS"
		|| str.toUpperCase()=="MAXTRANS"
		|| str.toUpperCase()=="INCLUDING") {
		return 1;
	}else {
		return 0;
	}
}

/*
 * SQL命令文直後の改行位置を決定する
 * pSqlChr … SQLを構成するキーワードの属性
 */
function judgeLineFeed(pSqlChr) {
	if(pSqlChr.typ==CNS_NORMAL
		&& (
				pSqlChr.chr.toUpperCase()=="DISTINCT"
			||  pSqlChr.chr.toUpperCase()=="UNIQUE"
			||  pSqlChr.chr.toUpperCase()=="ALL"
			||  pSqlChr.chr.toUpperCase()=="INTO" )) {
		return 0;
	}else if(pSqlChr.typ==CNS_HINT) {
		return 0;
	}else if(pSqlChr.typ==CNS_COMMENT_1) {
		return 0;
	}else {
		return 1;
	}
}

/*
 * SQL文を構成する文字の属性配列の初期化
 * pSql    … SQL文
 * pSqlChr … SQLを構成する文字の属性配列
 */
function initSQLCharAttribute(pSQL,pSqlChr) {
	var i; // 単純なループカウンタ。
	var sqlLength; // pSqlChr配列の有効サイズを表す変数
	// pSqlChr配列の有効サイズを表す変数を1で初期化する。
	sqlLength=1;
	var wkKind; // SQLの文字種別格納用変数
	// SQLの文字種別格納用変数を通常種別で初期化する。
	wkKind=CNS_NORMAL;

	// SQL文を構成する文字の属性配列をpSQLの長さで初期化する。
	pSqlChr=new makeArray(pSQL.length);

	// pSQLを一文字ずつ参照して、SQL文を構成する文字の属性配列を作成する。
	// 【ルール１】 sqlから切り出した文字が改行の場合、" "に変換する。
	// 【ルール２】 sqlから切り出した文字が"("、")"、","、";"、"+"、"-"のいずれかの場合はその前後に" "を挿入する。
	// 【ルール３】 sqlから切り出した文字が"タブ"の場合、" "に変換する。
	// 【ルール４】但し、以下の4パターンに該当する場合はルール１～３は適応しない。
	//   1)「'」に挟まれる文字列の一部である場合
	//   2)「"」に挟まれる文字列の一部である場合
	//   3)「/*」と「*/」に挟まれる文字列の一部である場合
	//   4)「--」と、その後ろに現れる最初の改行に挟まれる文字列の一部である場合
	for (i=0;i<pSQL.length;i++) {
		sqlLength=sqlLength+1;
		if(wkKind==CNS_NORMAL) {
			if(pSQL.charAt(i)=="'") {
				wkKind=CNS_CHAR;
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(pSQL.charAt(i)=="\"") {
				wkKind=CNS_DC;
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(i<(pSQL.length-2) && pSQL.charAt(i)=="/" && pSQL.charAt(i+1)=="*" && pSQL.charAt(i+2)=="+") {
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				pSqlChr[sqlLength-2]=new SQLCharAttribute(" ", wkKind, "", "");
				wkKind=CNS_HINT;
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(i<(pSQL.length-1) && pSQL.charAt(i)=="/" && pSQL.charAt(i+1)=="*") {
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				pSqlChr[sqlLength-2]=new SQLCharAttribute(" ", wkKind, "", "");
				wkKind=CNS_COMMENT_1;
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(i<(pSQL.length-1) && pSQL.charAt(i)=="-" && pSQL.charAt(i+1)=="-") {
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-2,1);
				pSqlChr[sqlLength-2]=new SQLCharAttribute(" ", wkKind, "", "");
				wkKind=CNS_COMMENT_2;
				// iは、0スタートなので、1足す。
				//pSQL=changeStr(pSQL,i+(1),"/");
				//pSQL=changeStr(pSQL,i+1+(1),"*");
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(pSQL.charAt(i)=="\r") {
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(pSQL.charAt(i)=="\n") {
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(pSQL.charAt(i)=="\t") {
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(pSQL.charAt(i)=="(" || pSQL.charAt(i)==")" || pSQL.charAt(i)=="," || pSQL.charAt(i)==";" || pSQL.charAt(i)=="/" || pSQL.charAt(i)=="+" || pSQL.charAt(i)=="-") {
				// 前後に" "を挿入してpSqlChrを作成するのでさらにサイズ拡張する。
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,2);
				// sqlLengthも+2しておく。
				sqlLength=sqlLength+2; 
				pSqlChr[sqlLength-3]=new SQLCharAttribute(" ", wkKind, "", "");
				pSqlChr[sqlLength-2]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(i<(pSQL.length-1) && pSQL.charAt(i)=="|" && pSQL.charAt(i+1)=="|") {
				// 文字連結記号"||"を検出する。
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-2,1);
				pSqlChr[sqlLength-2]=new SQLCharAttribute(" ", wkKind, "", "");
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}else if(i>1 && pSQL.charAt(i-1)=="|" && pSQL.charAt(i)=="|") {
				// 文字連結記号"||"を検出する。
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-2,1);
				pSqlChr[sqlLength-2]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else {
				pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			}
		}else {
			pSqlChr[sqlLength-1]=new SQLCharAttribute(pSQL.charAt(i), wkKind, "", "");
			if(wkKind==CNS_CHAR && i==(pSQL.length-1) && pSQL.charAt(i)=="'") {
				wkKind=CNS_NORMAL;
			}else if(wkKind==CNS_DC && pSQL.charAt(i)=="\"") {
				wkKind=CNS_NORMAL;
			}else if(wkKind==CNS_CHAR && i<(pSQL.length-1) && pSQL.charAt(i)=="'" && pSQL.charAt(i+1)!="'") {
				wkKind=CNS_NORMAL;
			}else if(wkKind==CNS_HINT && pSQL.charAt(i-1)=="*" && pSQL.charAt(i)=="/") {
				// ヒント句を意識する為に、/*+ … */の後ろに" "を挿入してpSqlChrを作成する。
				//sqlLength=sqlLength+1;
				//pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				//pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
				wkKind=CNS_NORMAL;
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(wkKind==CNS_COMMENT_1 && pSQL.charAt(i-1)=="*" && pSQL.charAt(i)=="/") {
				wkKind=CNS_NORMAL;
				sqlLength=sqlLength+1;
				pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
			}else if(wkKind==CNS_COMMENT_2 && pSQL.charAt(i)=="\n") {
				//sqlLength=sqlLength+1;
				//pSqlChr=resizeSQLCharAttribute(pSqlChr,sqlLength-1,1);
				//pSqlChr[sqlLength-1]=new SQLCharAttribute(" ", wkKind, "", "");
				//pSqlChr[sqlLength-2].chr="\r\n";
				//pSqlChr[sqlLength-1].chr="";
				pSqlChr[sqlLength-2].chr="\r\n";
				pSqlChr[sqlLength-1].chr="";
				wkKind=CNS_NORMAL;
			}
		}
	}
	// 作成したSQL文を構成する文字の属性配列を呼出元に戻す。
	return pSqlChr;
}

/*
 * SQL文を構成キーワードの属性配列の初期化
 * pSqlChr … SQLを構成する文字の属性配列
 */
function initSQLKeyWordAttribute(pSqlChr) {
	var i; // 単純なループカウンタ。
	var sqlLength; // pSqlChr配列の有効サイズを表す変数
	// pSqlChr配列の有効サイズを変数に取得する。
	sqlLength=pSqlChr.length;

	// SQL文のキーワードの属性配列を宣言する。
	sqlKeyWordChr=new makeArray(0);

	var workKeyWord; // キーワード作成用変数
	workKeyWord=""; // キーワード作成用変数の初期化

	var idx; // キーワード先頭の番地を保持する変数。
	idx=0; // キーワード先頭の番地を保持する変数の初期化

	sqlKeyWordChr[0]=new SQLCharAttribute("", "", "", "");

	// pSQLを一文字ずつ参照して、SQL文を構成する文字の属性配列を作成する。
	for (i=1;i<=sqlLength;i++) {
		if(pSqlChr[i].typ==CNS_NORMAL && pSqlChr[i].chr==" " && workKeyWord!="") {
			// キーワードの区切りの発見
			// sqlKeyWordChrのサイズ拡張する。
			sqlKeyWordChr=resizeSQLCharAttribute(sqlKeyWordChr,sqlKeyWordChr.length+1,1);
			// キーワード配列の作成
			sqlKeyWordChr[sqlKeyWordChr.length]=new SQLCharAttribute(workKeyWord, pSqlChr[idx].typ, "", "");
			// キーワード作成用変数の初期化
			workKeyWord="";
		}else if(pSqlChr[i].typ==CNS_COMMENT_2 && pSqlChr[i].chr=="\r\n" && workKeyWord!="") {
			// キーワードの区切りの発見
			// sqlKeyWordChrのサイズ拡張する。
			sqlKeyWordChr=resizeSQLCharAttribute(sqlKeyWordChr,sqlKeyWordChr.length+1,1);
			// キーワード配列の作成
			sqlKeyWordChr[sqlKeyWordChr.length]=new SQLCharAttribute(workKeyWord, pSqlChr[idx].typ, "", "\r\n");
			// キーワード作成用変数の初期化
			workKeyWord="";

		}else if(pSqlChr[i].typ!=CNS_RM){
			if(workKeyWord=="") {
				idx=i;
			}
			// キーワードを作成する。
			workKeyWord=workKeyWord+pSqlChr[i].chr;
		}
		// 半角スペースの空白、改行の無視
		if(workKeyWord==" " || workKeyWord=="\r\n"){
			workKeyWord="";
			idx=0;
		}else {
		}
	}

	if(workKeyWord!="") {
		// キーワードの区切りの発見
		// sqlKeyWordChrのサイズ拡張する。
		sqlKeyWordChr=resizeSQLCharAttribute(sqlKeyWordChr,sqlKeyWordChr.length+1,1);
		// キーワード配列の作成
		sqlKeyWordChr[sqlKeyWordChr.length]=new SQLCharAttribute(workKeyWord, pSqlChr[idx].typ, "", "");
		// キーワード作成用変数の初期化
		workKeyWord="";
	}

	// 作成したSQL文を構成する文字の属性配列を呼出元に戻す。
	return sqlKeyWordChr;
}

/*
 * 連続する" "を除去
 * pSqlChr … SQLを構成する文字の属性配列
 */
function rmSpaceFromSQLChar(pSqlChr) {
	var i; // ループ処理で使用する単純なカウンタ
	for(i=0;i<=(pSqlChr.length-1);i++) {
		if(pSqlChr[i].typ==CNS_NORMAL && pSqlChr[i+1].typ==CNS_NORMAL) {
			if(pSqlChr[i].chr==" " && pSqlChr[i+1].chr==" ") {
				pSqlChr[i].typ=CNS_RM;
			}
		}
	}
	// 作成したSQL文を構成する文字の属性配列を呼出元に戻す。
	return pSqlChr;
}

/*
 * 種別に従い大文字/小文字変換
 * pSqlChr … SQLを構成する文字の属性配列
 */
function changeCaseFromSQLChar(pSqlChr) {
	var i; // ループ処理で使用する単純なカウンタ
	for(i=0;i<=pSqlChr.length;i++) {
		if(getChangeCase()=="UCase") {
			if(pSqlChr[i].typ==CNS_NORMAL) {
				pSqlChr[i].chr=pSqlChr[i].chr.toUpperCase();
			}
		} else if(getChangeCase()=="LCase") {
			if(pSqlChr[i].typ==CNS_NORMAL) {
				pSqlChr[i].chr=pSqlChr[i].chr.toLowerCase();
			}
		}
	}
	// 作成したSQL文を構成する文字の属性配列を呼出元に戻す。
	return pSqlChr;
}

/*
 * SQLを構成する文字の属性配列の指定番地より直前の有効文字番地取得
 * pSqlChr … SQLを構成する文字の属性配列
 * pos     … 指定番地
 */
function searchPreChr(pSqlChr,pos) {
	var i; // ループ処理で使用する単純なカウンタ
	for(i=pos-3;i>=0;i--) {
		if(pSqlChr[i].typ==CNS_NORMAL && pSqlChr[i].chr!=" " && pSqlChr[i].chr!="" && pSqlChr[i].chr!="\r\n" && pSqlChr[i].chr!="\r" && pSqlChr[i].chr!="\n" && pSqlChr[i].chr!="/") {
			return i;
		}
	}
	return 0;
}

/*
 * SQLを整形
 */
function fixSQL(sql) {
	// SQLがテキストエリアに入力されていない場合は処理を中断する。
	if(sql.length==0) {
		return "SQLテキストエリアに何も入力されていません。";
	}

	var ret; // 戻り値作成用変数
	var i; var j; // ループ処理で使用する単純なカウンタ

	var wkKind; // SQLの文字種別格納用変数
	// SQLの文字種別格納用変数を通常種別で初期化する。
	wkKind=CNS_NORMAL;

	// SQL文を構成する文字の属性配列を初期化する。
	sqlChr=new makeArray();
	var sqlLength; // sqlChr配列の有効サイズを表す変数
	// sqlChr配列の有効サイズを表す変数を1で初期化する。
	sqlLength=1;

	// sqlChrにSQLテキストエリアの内容を一文字ずつ取り込む(※sqlChrの初期化)
	sqlChr=initSQLCharAttribute(sql,sqlChr);
	// SqlChr配列の有効サイズを表す変数をsqlChrのサイズにする。
	sqlLength=sqlChr.length;

	// OracleのSQL予約語を配列に作成する。
	var oracleRw=new Array();
	oracleRw=get_oracleRw();

	// 連続する" "を除去する。
	sqlChr=rmSpaceFromSQLChar(sqlChr);

	// 種別に従い大文字/小文字変換する。
	sqlChr=changeCaseFromSQLChar(sqlChr);

	var indentArr=new Array(); // インデント設定を行う為の配列

	var indCnt; // インデントレベルカウント用変数
	indCnt=0; // インデントレベルカウント用変数の初期化

	var parCnt; // 括弧"("、")"のカウント用変数
	parCnt=0; // 括弧"("、")"のカウント用変数の初期化

	var betweenflg; // BETWEENの出現を検出する為のフラグ
		betweenflg=0; // BETWEENの出現を検出する為のフラグの初期化

	var unionallflg; // UNION ALLの出現を検出する為のフラグ
		unionallflg=0; // UNION ALLの出現を検出する為のフラグの初期化

	var selectflg; // SELECTの出現を検出する為のフラグ
		selectflg=0; // SELECTの出現を検出する為のフラグの初期化

	var insertflg; // INSERTの出現を検出する為のフラグ
		insertflg=0; // INSERTの出現を検出する為のフラグの初期化

	var deleteflg; // DELETEの出現を検出する為のフラグ
	deleteflg=0; // DELETEの出現を検出する為のフラグの初期化

	var updateflg; // UPDATEの出現を検出する為のフラグ
	updateflg=0; // UPDATEの出現を検出する為のフラグの初期化

	var mergeflg; // MERGEの出現を検出する為のフラグ
		mergeflg=0; // MERGEの出現を検出する為のフラグの初期化

	var hintflg; // ヒントの出現を検出する為のフラグ
	hintflg=0; // ヒントの出現を検出する為のフラグの初期化

	var keyword; // キーワードを作成する為の変数
	keyword=""; // キーワードを作成する為の変数の初期化

	var idx; // キーワード作成時の先頭インデックスを表す変数
	idx=0; // キーワード作成時の先頭インデックスを表す変数の初期化

	var stopindent; // インデント抑止する為の変数
	stopindent=0; // インデント抑止する為の変数の初期化

	var createflg; // "CREATE"の出現を検出する為のフラグ
		createflg=0; // "CREATE"の出現を検出する為のフラグの初期化

	var createtableflg; // "CREATE TABLE"の出現を検出する為のフラグ
		createtableflg=0; // "CREATE TABLE"の出現を検出する為のフラグの初期化

	var createuserflg; // "CREATE USER"の出現を検出する為のフラグ
		createuserflg=0; // "CREATE USER"の出現を検出する為のフラグの初期化

	var sequenceflg; // "SEQUENCE"の出現を検出する為のフラグ
		sequenceflg=0; // "SEQUENCE"の出現を検出する為のフラグの初期化

	var alterflg; // "ALTER"の出現を検出する為のフラグ
	alterflg=-1; // "ALTER"の出現を検出する為のフラグの初期化

	var topKeyword; // SQL文の先頭キーワード
		topKeyword=""; // SQL文の先頭キーワードの初期化

	var mergewhenflg; // "MERGE"文のWHENの出現を検出する為のフラグ
	mergewhenflg=0; // "MERGE"文のWHENの出現を検出する為のフラグの初期化

	var mergeonusingwhenFlg; // "MERGE"文のON/USING/WHENの出現を検出する為のフラグ
		mergeonusingwhenFlg=0; // "MERGE"文のON/USING/WHENの出現を検出する為のフラグの初期化

	var joinflg; // SQL:1999構文の出現を検出する為のフラグ
		joinflg=0; // SQL:1999構文の出現を検出する為のフラグの初期化

	var continueparcnt; // 連続した"("の検出用変数
	continueparcnt=0;

	///////////////////////////////////////////////////
	// SQL文を構成するキーワードの属性配列を初期化する。
	keywordChr=new makeArray();
	var keywordLength; // keywordChr配列の有効サイズを表す変数
	// keywordChr配列の有効サイズを表す変数を1で初期化する。
	keywordLength=1;

	// keywordChrにキーワードを一つずつ設定する。)
	keywordChr=initSQLKeyWordAttribute(sqlChr);
	// keywordChr配列の有効サイズを表す変数をkeywordLengthのサイズにする。
	keywordLength=keywordChr.length;

	// SQL文キーワード配列を一つずつ参照する。
	for(i=1;i<=keywordLength;i++) {
		// ";"が検出された場合は、インデント設定のカウンタや全てのフラグを初期に戻す。
		if(
			(keywordChr[i].chr==";" && keywordChr[i].typ==CNS_NORMAL)
					|| (
							i>1
							&& (keywordChr[i].chr=="/" && keywordChr[i].typ==CNS_NORMAL)
							&& (keywordChr[i-1].chr==";" && keywordChr[i-1].typ==CNS_NORMAL)
						)
					|| (
							i>1
							&& (keywordChr[i].chr=="/" && keywordChr[i].typ==CNS_NORMAL)
							&& (keywordChr[i-1].chr=="/" && keywordChr[i-1].typ==CNS_NORMAL)
						)
		) {
			if (keywordChr[i-1].chr==";" && keywordChr[i-1].typ==CNS_NORMAL) {
				keywordChr[i].idtf="\r\n";
			}else {
				keywordChr[i].idtf="";
			}
			keywordChr[i].idtb="\r\n\r\n";
			topKeyword=""; // SQL文の先頭キーワードの初期化
			indCnt=0; // インデントレベルカウント用変数の初期化
			parCnt=0; // 括弧"("、")"のカウント用変数の初期化
			selectflg=0; // SELECTの出現を検出する為のフラグの初期化
			createflg=0; // "CREATE"の出現を検出する為のフラグの初期化
			createtableflg=0; // "CREATE TABLE"の出現を検出する為のフラグの初期化
			insertflg=0; // INSERTの出現を検出する為のフラグの初期化
			betweenflg=0; // BETWEENの出現を検出する為のフラグの初期化
			unionallflg=0; // UNION ALLの出現を検出する為のフラグの初期化
			joinflg=0; // SQL:1999構文の出現を検出する為のフラグの初期化
			sequenceflg=0; // "SEQUENCE"の出現を検出する為のフラグの初期化
			mergeflg=0; // MERGEの出現を検出する為のフラグの初期化
			mergeonusingwhenFlg=0; // "MERGE"文のON/USING/WHENの出現を検出する為のフラグの初期化
			createuserflg=0; // "CREATE USER"の出現を検出する為のフラグの初期化
		}

		// 括弧"("、")"の開始と終了をparCntで調べる。
		if(keywordChr[i].chr=="(" && keywordChr[i].typ==CNS_NORMAL) {
			parCnt=parCnt+1;
		}else if(keywordChr[i].chr==")" && keywordChr[i].typ==CNS_NORMAL) {
			parCnt=parCnt-1;
		}

		// SQL文の看板を検出する。
		if(topKeyword=="" && keywordChr[i].typ==CNS_COMMENT_1 ){
			// topKeywordが未設定の状態にあるとき、コメント「/* */」が存在していれば、前方インデント解除と、後方インデントに改行を入れる。
			keywordChr[i].idtf="";
			keywordChr[i].idtb="\r\n";
		}else if(topKeyword=="" && keywordChr[i].typ==CNS_COMMENT_2 ){
			// topKeywordが未設定の状態にあるとき、コメント「--」が存在していれば、前方インデント解除。
			keywordChr[i].idtf="";
		}
		
		// "-- …"のコメントを検出する。
		if(topKeyword!=""  && keywordChr[i].typ==CNS_COMMENT_2) {
			keywordChr[i].idtf=" ";
		}

		if(stopindent==0) {
			if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr=="("
				&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="(") {
				// 連続する括弧のインデント抑止。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="";
				continueparcnt=continueparcnt+1;
			}else if( i>0
				&& continueparcnt>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr==")"
				&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i-1,-1).toUpperCase()==")") {
				// 連続する括弧のインデント抑止。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="";
				continueparcnt=continueparcnt-1;
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr=="("
				&& searchSQLCommandChr(keywordChr,i+1,1).toUpperCase()=="SELECT"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()!="SELECT") {
				indCnt=indCnt+1;
				// 必ず後ろで改行する。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr==")"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT"
				&& searchSQLCommandChr(keywordChr,i-1,-2).toUpperCase()!="SELECT") {
				// インデント抑止。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="";
				indCnt=indCnt-1;
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr=="("
				&& searchSQLCommandChr(keywordChr,i+1,1).toUpperCase()=="SELECT"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT") {
				indCnt=indCnt+2;
				// 必ず後ろで改行する。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr==")"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT"
				&& searchSQLCommandChr(keywordChr,i-1,-2).toUpperCase()=="SELECT") {
				// インデント抑止。
				keywordChr[i].idtf="";
				keywordChr[i].idtb="";
				indCnt=indCnt-2;
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr=="("
				&& searchSQLCommandChr(keywordChr,i+1,1).toUpperCase()!="SELECT") {
				indCnt=indCnt+1;
				// 必ず後ろで改行する。
				keywordChr[i].idtf="";
				// カンマを行頭に配置するか否かで"  "の付与を決定する。
				if( getCommaPos()=="Top") {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect())+"  ";
				}else {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
			}else if( i>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr==")"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()!="SELECT") {
				// インデント抑止。
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				if(searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()!=";"
					&& searchSQLCommandChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()!="") {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}else {
					keywordChr[i].idtb="";
				}
				indCnt=indCnt-1;
			}
			
			// "SELECT"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="SELECT") {
				// topKeywordの設定
				if(topKeyword=="") {
					topKeyword="SELECT";
				}
				// topKeyword設定後の"SELECT"は、"("に挟まれていない場合に改行する。
				if(searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i-1,-1).toUpperCase()!="(" && topKeyword!="SELECT") {
					indCnt=indCnt+1;
					keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
				// "SELECT"の出現をフラグに設定する。
				selectflg=i;
			}else if(selectflg>0 && judgeLineFeed(keywordChr[i])==0) {
				// "SELECT"句の直後の改行位置は、"DISTINCT"、"ALL"、"UNIQUE"、"/*+ … */"の後ろにする。
				// "SELECT"直後の改行の位置を延長
				keywordChr[i].idtf="";
				keywordChr[i].idtb="";
				selectflg=i;
			}else if(selectflg>0 && judgeLineFeed(keywordChr[i])==1) {
				// "SELECT"直後の改行の位置が確定
				// カンマを行頭に配置するか否かで"  "の付与を決定する。
				if(getCommaPos()=="Top") {
					keywordChr[selectflg].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect())+"  ";
				}else {
					keywordChr[selectflg].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
				}
				selectflg=0;
			}

			// "CREATE"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="CREATE") {
				// topKeywordの設定
				if(topKeyword=="") {
					topKeyword="CREATE";
				}
				// "CREATE"の出現をフラグに設定する。
				createflg=i;
			}

			// "CREATE TABLE"の出現を検出する。
			if(createflg>0
				&& keywordChr[i].chr.toUpperCase()=="TABLE") {
				createtableflg=i;
			}

			// "MERGE"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="MERGE") {
				// topKeywordの設定
				if(topKeyword=="") {
					topKeyword="MERGE";
				}
				// "MERGE"の出現をフラグに設定する。
				mergeflg=i;
			}

			// "MERGE"句の"ON"、"USING"、"WHEN"インデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& (   keywordChr[i].chr.toUpperCase()=="ON"
					|| keywordChr[i].chr.toUpperCase()=="USING"
					|| keywordChr[i].chr.toUpperCase()=="WHEN")
				&& topKeyword=="MERGE") {
				// "ON"の場合は『改行+"[ON | USING | WHEN]"+改行』
				if(mergeonusingwhenFlg==0) {
					indCnt=indCnt+1;
					mergeonusingwhenFlg=i;
				}
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="";
			}
			// "MERGE"句の"INSERT"、"UPDATE"インデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& (   keywordChr[i].chr.toUpperCase()=="INSERT"
					|| keywordChr[i].chr.toUpperCase()=="UPDATE")
				&& topKeyword=="MERGE") {
				// "ON"の場合は『改行+"[INSERT | UPDATE]"+改行』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="";
			}

			// "INSERT"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="INSERT") {
				// topKeywordの設定
				if(topKeyword=="") {
					topKeyword="INSERT";
				}
				// "INSERT"の出現をフラグに設定する。
				insertflg=i;
			}
			// "INSERT"句出現後の"VALUES"句のインデント設定
			if( insertflg>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="VALUES") {
				// "VALUES"の場合は『改行+"VALUES"』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
				keywordChr[i].idtb="";
			}
			// "INSERT"句出現後の"INTO"句のインデント設定
			if( insertflg>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="INTO") {
				// "VALUES"の場合は『改行+"INTO"』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
				keywordChr[i].idtb="";
			}

			// "FROM"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="FROM") {
				// "SELECT"の"FROM"の場合は『改行+"FROM"+改行』
				if(searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT") {
					keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
					// カンマを行頭に配置するか否かで"  "の付与を決定する。
					if(getCommaPos()=="Top") {
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect())+"  ";
					}else {
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
					}
				}else {
					// 上記判定条件に合わない"FROM"の場合はノーインデント
					keywordChr[i].idtf="";
					keywordChr[i].idtb="";
				}
			}

			// "UPDATE"文の"SET"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="SET"
				&& searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="UPDATE") {
				// "UPDATE"文の"SET"句の場合は『改行+"SET"+改行』
					keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
					// カンマを行頭に配置するか否かで"  "の付与を決定する。
					if(getCommaPos()=="Top") {
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect())+"  ";
					}else {
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
					}
			}

			// "WHERE"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="WHERE") {
				// "WHERE"の場合は『改行+"WHERE"+改行』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				// WHERE句の「AND」、「OR」を行頭に配置するか否かでインデントの有無を決定する。
				if(getAndPos()=="Top") {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
				}else {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
			}

			// 集合演算子"UNION"のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="UNION") {
				// "UNION"の場合は『改行+"UNION"+改行』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				// "UNION"の直後に"ALL"が存在していないか調べる。
				if(searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="ALL") {
					unionallflg=i;
				}else {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
			}else if (unionallflg>0
						&& keywordChr[i].typ==CNS_NORMAL
						&& keywordChr[i].chr.toUpperCase()=="ALL") {
				// "UNION ALL"の後ろで改行する。
				keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
			}
			// 集合演算子"MINUS"、"INTERSECT"のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& (
						keywordChr[i].chr.toUpperCase()=="MINUS"
					||  keywordChr[i].chr.toUpperCase()=="INTERSECT")) {
				// "UNION"の場合は『改行+"MINUS | INTERSECT"+改行』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
			}

			// "CREATE TABLE"のインデント設定
			if(createtableflg>0
				&& keywordChr[i].typ==CNS_NORMAL
				&& topKeyword=="CREATE"
				&& checkCreateTableKey(keywordChr[i].chr.toUpperCase())==1) {
				// "CREATE TABLE"改行キーワードの場合は『改行+キーワード』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="";
			}

			// "ORDER BY"、"GROUP BY"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& (    keywordChr[i].chr.toUpperCase()=="ORDER"
					||  keywordChr[i].chr.toUpperCase()=="GROUP")
				&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="BY") {
				// "ORDER"、"GROUP"の場合は『改行+"ORDER | GROUP"』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
			}else if(keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="BY"
				&& (
						searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i-1,-1).toUpperCase()=="ORDER"
					||  searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i-1,-1).toUpperCase()=="GROUP")) {
				// カンマを行頭に配置するか否かで"  "の付与を決定する。
				if(getCommaPos()=="Top") {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect())+"  ";
				}else {
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
				}
			}
			// "HAVING"句ののインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="HAVING") {
				// "HAVING"の場合は『改行+"HAVING"』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="";
			}

			// "RETURNING"句ののインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="RETURNING") {
				// "RETURNING"の場合は『改行+"RETURNING"』
				keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
				keywordChr[i].idtb="";
			}

			// "AND"、"OR"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& (
						keywordChr[i].chr.toUpperCase()=="AND"
					||  keywordChr[i].chr.toUpperCase()=="OR")) {
				// "BETWEEN"句の出現を調べる。
				if(keywordChr[i].chr.toUpperCase()=="AND" && betweenflg>0) {
					// "BETWEEN"句直後はインデントしない。
				}else {
					// WHERE句の「AND」、「OR」を行頭に配置するか否かで"    "の付与を決定する。
					if(getAndPos()=="Top") {
						keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
						// "OR"は"AND"より一文字少ないので" "を補う。
						if(keywordChr[i].chr.toUpperCase()=="OR") {
							keywordChr[i].idtb="  ";
						}else {
							keywordChr[i].idtb="";
						}
					}else {
						keywordChr[i].idtf="";
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
					}
				}
				betweenflg=0;
			}

			// "INCLUDING"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="INCLUDING") {
				if(getAndPos()=="Top") {
					keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
					keywordChr[i].idtb="";
				}else {
					keywordChr[i].idtf="";
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
			}

			// "CASCADE"句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL
				&& keywordChr[i].chr.toUpperCase()=="CASCADE") {
				if(getAndPos()=="Top") {
					keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
					keywordChr[i].idtb="";
				}else {
					keywordChr[i].idtf="";
					keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
				}
			}

			// "BETWEEN"句の検出
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="BETWEEN") {
				// "BETWEEN"の場合は次に続く"AND"をノーインデントにする為フラグを設定する。
				betweenflg=i;
			}

			// "JOIN"句の検出
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()=="JOIN") {
				// SQL:1999構文の一部の"JOIN"の出現を検出する為フラグを設定する。
				joinflg=i;
			}

			// ","句のインデント設定
			if(keywordChr[i].typ==CNS_NORMAL && keywordChr[i].chr.toUpperCase()==",") {
				// カンマを行頭に配置するか否かで改行の位置を決定する。
				if(getCommaPos()=="Top") {
					if(searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT") {
						keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
						keywordChr[i].idtb=" ";
					}else if(searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="UPDATE") {
						keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
						keywordChr[i].idtb=" ";
					}else {
						keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
						keywordChr[i].idtb=" ";
					}
				}else {
					if(searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="SELECT") {
						keywordChr[i].idtf=" ";
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
					}else if(searchSQLCommandChr(keywordChr,i-1,-1).toUpperCase()=="UPDATE") {
						keywordChr[i].idtf=" ";
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt+1,getTabSelect());
					}else {
						keywordChr[i].idtf=" ";
						keywordChr[i].idtb="\r\n"+makeTabSpace(indCnt,getTabSelect());
					}
				}
			}
		}

		// シーケンスオブジェクト用
		if(keywordChr[i].chr.toUpperCase()=="SEQUENCE") {
			sequenceflg=i;
		}else if(sequenceflg>0 && checkSequenceKey(keywordChr[i].chr.toUpperCase())==1) {
			keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
		}

		// "CREATE USER"用
		if(createflg>0 && keywordChr[i].chr.toUpperCase()=="USER") {
			createuserflg=i;
		}else if(createuserflg>0 && checkUserKey(keywordChr[i].chr.toUpperCase())==1) {
			keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt,getTabSelect());
		}

		// ====== インデント抑止作業 ======
		if(stopindent==0
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="("
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,2).toUpperCase()=="+"
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,3).toUpperCase()==")") {
			// 外部結合の"(+)"を検出した場合は、"("の出現でインデント作業しないように制御する。
			stopindent=parCnt+1;
		}else if(stopindent==0
			&& keywordChr[i].chr.toUpperCase()=="IN"
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="("
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,2).toUpperCase()!="SELECT") {
			// IN演算子直後の"("が副問合せの開始を表す"("ではない場合インデント作業抑止する。
			stopindent=parCnt+1;
		}else if(oracleRw[keywordChr[i].chr.toUpperCase()]!=undefined
			&& stopindent==0
			&& i<keywordLength
			&& searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="(") {
			// 予約語の後ろに"("が現れる場合を検出する。
			// インデント抑止が行われていないなければインデント抑止する。
			stopindent=parCnt+1;
		}else if(mergeflg>0
			&& stopindent==0
			&& i<keywordLength
			&& (keywordChr[i].chr.toUpperCase()=="ON")) {
			// MERGEの"ON"のインデント抑止開始。
			stopindent=parCnt+1;
		}else if(joinflg>0
			&& stopindent==0
			&& i<keywordLength
			&& (keywordChr[i].chr.toUpperCase()=="ON" || keywordChr[i].chr.toUpperCase()=="USING")) {
			keywordChr[i].idtf="\r\n"+makeTabSpace(indCnt+2,getTabSelect());
			keywordChr[i].idtb="";
			if( searchSQLKeyWordChr(keywordChr,CNS_NORMAL,i+1,1).toUpperCase()=="(") {
				// SQL:1999構文の"ON"、"USING"句のインデント抑止開始。
				joinflg=0;
				stopindent=parCnt+1;
			}
		}else if(keywordChr[i].chr==")" && stopindent>parCnt) {
			// インデント抑止解除は、stopindentがparCntより小さくなった場合
			stopindent=0;
		}
	}
	var rrr;
	rrr="";
	for (var n=1;n<=keywordLength;n++) {
		// インデントによる連続改行を取除く。
		if(n<keywordLength
			&& substrRight(keywordChr[n].idtb,2).replace(" ","")=="\r\n"
			&& substrLeft(keywordChr[n+1].idtf,2).replace(" ","")=="\r\n"){
			keywordChr[n].idtb="";
		}
		// キーワードをインデントなしで連結しようとしている場合を抑止。
		if(n<keywordLength && keywordChr[n].idtb=="" && keywordChr[n+1].idtf==""){
			 keywordChr[n].idtb=" ";
		}
		rrr=rrr+keywordChr[n].idtf+keywordChr[n].chr+keywordChr[n].idtb;
		// デバッグ！
		//rrr=rrr+"["+n+"]"+keywordChr[n].idtf+keywordChr[n].chr+keywordChr[n].idtb+"\r\n";
	}
	
	return rrr;
}

/*
 * OracleのSQL予約語を配列に作成
 */
function get_oracleRw() {
	// 戻り値とする連想配列を宣言する。
	var oracleRw = new Array();

	// Oracleの予約語を連想配列に作成する。
	oracleRw["ABS"]="1";
	oracleRw["SIGN"]="2";
	oracleRw["MOD"]="3";
	oracleRw["ROUND"]="4";
	oracleRw["TRUNC"]="5";
	oracleRw["FLOOR"]="6";
	oracleRw["CEIL"]="7";
	oracleRw["SQRT"]="8";
	oracleRw["POWER"]="9";
	oracleRw["EXP"]="10";
	oracleRw["LN"]="11";
	oracleRw["LOG"]="12";
	oracleRw["SIN"]="13";
	oracleRw["COS"]="14";
	oracleRw["TAN"]="15";
	oracleRw["SINH"]="16";
	oracleRw["COSH"]="17";
	oracleRw["TANH"]="18";
	oracleRw["ASIN"]="19";
	oracleRw["ACOS"]="20";
	oracleRw["ATAN"]="21";
	oracleRw["ATAN2"]="22";
	oracleRw["BITAND"]="23";
	oracleRw["WIDTH_BUCKET"]="24";
	oracleRw["NANVL"]="25";
	oracleRw["REMAINDER"]="26";
	oracleRw["ASCII"]="27";
	oracleRw["CHR"]="28";
	oracleRw["NCHR"]="29";
	oracleRw["CONCAT"]="30";
	oracleRw["REPLACE"]="31";
	oracleRw["LPAD"]="32";
	oracleRw["RPAD"]="33";
	oracleRw["LTRIM"]="34";
	oracleRw["RTRIM"]="35";
	oracleRw["TRIM"]="36";
	oracleRw["REPLCAE"]="37";
	oracleRw["INSTR"]="38";
	oracleRw["INSTRB"]="39";
	oracleRw["LENGTH"]="40";
	oracleRw["LENGTHB"]="41";
	oracleRw["INITCAP"]="42";
	oracleRw["LOWER"]="43";
	oracleRw["UPPER"]="44";
	oracleRw["NLS_INITCAP"]="45";
	oracleRw["NLS_LOWER"]="46";
	oracleRw["NLS_UPPER"]="47";
	oracleRw["NLSSORT"]="48";
	oracleRw["SOUNDEX"]="49";
	oracleRw["SUBSTR"]="50";
	oracleRw["SUBSTRB"]="51";
	oracleRw["TRANSLATE"]="52";
	oracleRw["TREAT"]="53";
	oracleRw["REGEXP_INSTR"]="54";
	oracleRw["REGEXP_SUBSTR"]="55";
	oracleRw["REGEXP_REPLACE"]="56";
	oracleRw["SYSDATE"]="57";
	oracleRw["CURRENT_DATE"]="58";
	oracleRw["LOCALTIMESTAMP"]="59";
	oracleRw["CURRENT_TIMESTAMP"]="60";
	oracleRw["SYSTIMESTAMP"]="61";
	oracleRw["DBTIMEZONE"]="62";
	oracleRw["SESSIONTIMEZONE"]="63";
	oracleRw["FROM_TZ"]="64";
	oracleRw["TZ_OFFSET"]="65";
	oracleRw["NEXT_DAY"]="66";
	oracleRw["ADD_MONTHS"]="67";
	oracleRw["LAST_DAY"]="68";
	oracleRw["MONTHS_BETWEEN"]="69";
	oracleRw["NEW_TIME"]="70";
	oracleRw["TO_TIMESTAMP"]="71";
	oracleRw["TO_TIMESTAMP_TZ"]="72";
	oracleRw["EXTRACT"]="73";
	oracleRw["SYS_EXTRACT_UTC"]="74";
	oracleRw["NUMTODSINTERVAL"]="75";
	oracleRw["TO_DSINTERVAL"]="76";
	oracleRw["NUMTOYMINTERVAL"]="77";
	oracleRw["TO_YMINTERVAL"]="78";
	oracleRw["ASCIISTR"]="79";
	oracleRw["BIN_TO_NUM"]="80";
	oracleRw["CHARTOROWID"]="81";
	oracleRw["ROWIDTOCHAR"]="82";
	oracleRw["ROWIDTONCHAR"]="83";
	oracleRw["COMPOSE"]="84";
	oracleRw["DECOMPOSE"]="85";
	oracleRw["UNISTR"]="86";
	oracleRw["CONVERT"]="87";
	oracleRw["HEXTORAW"]="88";
	oracleRw["RAWTOHEX"]="89";
	oracleRw["RAWTONHEX"]="90";
	oracleRw["TO_DATE"]="91";
	oracleRw["TO_LOB"]="92";
	oracleRw["TO_CLOB"]="93";
	oracleRw["TO_NCLOB"]="94";
	oracleRw["TO_NUMBER"]="95";
	oracleRw["TO_MULTI_BYTE"]="96";
	oracleRw["TO_SINGLE_BYTE"]="97";
	oracleRw["CAST"]="98";
	oracleRw["SCN_TO_TIMESTAMP"]="99";
	oracleRw["TIMESTAMP_TO_SCN"]="100";
	oracleRw["TO_BINARY_FLOAT"]="101";
	oracleRw["TO_BINARY_DOUBLE"]="102";
	oracleRw["BFILENAME"]="103";
	oracleRw["COALESCE"]="104";
	oracleRw["DECODE"]="105";
	oracleRw["PATH"]="106";
	oracleRw["DEPTH"]="107";
	oracleRw["DUMP"]="108";
	oracleRw["EMPTY_BLOB"]="109";
	oracleRw["EMPTY_CLOB"]="110";
	oracleRw["EXISTSNODE"]="111";
	oracleRw["EXTRACTVALUE"]="112";
	oracleRw["GREATEST"]="113";
	oracleRw["LEAST"]="114";
	oracleRw["NLS_CHARSET_DECL_LEN"]="115";
	oracleRw["NLS_CHARSET_ID"]="116";
	oracleRw["NLS_CHARSET_NAME"]="117";
	oracleRw["NULLIF"]="118";
	oracleRw["NVL"]="119";
	oracleRw["NVL2"]="120";
	oracleRw["SYS_CONNECT_BY_PATH"]="121";
	oracleRw["SYS_CONTEXT"]="122";
	oracleRw["SYS_DBURIGEN"]="123";
	oracleRw["SYS_GUID"]="124";
	oracleRw["SYS_TYPEID"]="125";
	oracleRw["SYS_XMLAGG"]="126";
	oracleRw["SYS_XMLGEN"]="127";
	oracleRw["UID"]="128";
	oracleRw["UPDATEXML"]="129";
	oracleRw["USER"]="130";
	oracleRw["USERENV"]="131";
	oracleRw["VSIZE"]="132";
	oracleRw["XMLELEMENT"]="133";
	oracleRw["XMLCOLATTVAL"]="134";
	oracleRw["XMLCONCAT"]="135";
	oracleRw["XMLFOREST"]="136";
	oracleRw["XMLSEQUENCE"]="137";
	oracleRw["XMLTRANSFORM"]="138";
	oracleRw["LNNVL"]="139";
	oracleRw["ORA_HASH"]="140";
	oracleRw["AVG"]="141";
	oracleRw["COUNT"]="142";
	oracleRw["MAX"]="143";
	oracleRw["MIN"]="144";
	oracleRw["SUM"]="145";
	oracleRw["STDDEV"]="146";
	oracleRw["STDDEV_POP"]="147";
	oracleRw["STDDEV_SAMP"]="148";
	oracleRw["VARIANCE"]="149";
	oracleRw["VAR_POP"]="150";
	oracleRw["VAR_SAMP"]="151";
	oracleRw["COVAR_POP"]="152";
	oracleRw["COVAR_SAMP"]="153";
	oracleRw["CORR"]="154";
	oracleRw["CUME_DIST"]="155";
	oracleRw["RANK"]="156";
	oracleRw["DENSE_RANK"]="157";
	oracleRw["FIRST"]="158";
	oracleRw["LAST"]="159";
	oracleRw["GROUP_ID"]="160";
	oracleRw["GROUPING"]="161";
	oracleRw["GROUPING_ID"]="162";
	oracleRw["PERCENT_RANK"]="163";
	oracleRw["PERCENTILE_CONT"]="164";
	oracleRw["PERCENTILE_DISC"]="165";
	oracleRw["REGR_SLOPE"]="166";
	oracleRw["REGR_INTERCEPT"]="167";
	oracleRw["REGR_COUNT"]="168";
	oracleRw["REGR_R2"]="169";
	oracleRw["REGR_AVGX"]="170";
	oracleRw["REGR_AVGY"]="171";
	oracleRw["REGR_SXX"]="172";
	oracleRw["REGR_SYY"]="173";
	oracleRw["REGR_SXY"]="174";
	oracleRw["CORR_S"]="175";
	oracleRw["CORR_K"]="176";
	oracleRw["MEDIAN"]="177";
	oracleRw["STATS_BINOMIAL_TEST"]="178";
	oracleRw["STATS_CROSSTAB"]="179";
	oracleRw["STATS_F_TEST"]="180";
	oracleRw["STATS_KS_TEST"]="181";
	oracleRw["STATS_MODE"]="182";
	oracleRw["STATS_MW_TEST"]="183";
	oracleRw["STATS_ONE_WAY_ANOVA"]="184";
	oracleRw["STATS_T_TEST_ONE"]="185";
	oracleRw["STATS_T_TEST_PAIRED"]="186";
	oracleRw["STATS_T_TEST_INDEP"]="187";
	oracleRw["STATS_T_TEST_INDEPU"]="188";
	oracleRw["STATS_WSR_TEST"]="189";
	oracleRw["FIRST_VALUE"]="190";
	oracleRw["LAST_VALUE"]="191";
	oracleRw["LAG"]="192";
	oracleRw["LEAD"]="193";
	oracleRw["NTILE"]="194";
	oracleRw["RATIO_TO_REPORT"]="195";
	oracleRw["REGR_AVRX"]="196";
	oracleRw["ROW_NUMBER"]="197";
	oracleRw["REF"]="198";
//	oracleRw["VALUE"]="199";
	oracleRw["DEREF"]="200";
	oracleRw["REFTOHEX"]="201";
	oracleRw["MAKE_REF"]="202";
	oracleRw["CARDINALITY"]="203";
	oracleRw["COLLECT"]="204";
	oracleRw["POWERMULTISET"]="205";
	oracleRw["POWERMULTISET_BY_CARDINALITY"]="206";
//	oracleRw["SET"]="207";
	oracleRw["CV"]="208";
	oracleRw["ITERATION_NUMBER"]="209";
	oracleRw["PRESENTNNV"]="210";
	oracleRw["PRESENTV"]="211";
	oracleRw["PREVIOUS"]="212";
	oracleRw["OVER"]="213";
//	oracleRw["IN"]="214";
//	oracleRw["ANY"]="215";
//	oracleRw["SOME"]="216";
//	oracleRw["EXISTS"]="217";
	oracleRw["LIKE"]="218";
	oracleRw["VALUE"]="219";
//	oracleRw["INTO"]="220";
	oracleRw["TO_CHAR"]="221";
	oracleRw["TABLE"]="222";
	oracleRw["WITHIN"]="223";
	oracleRw["NOT"]="224";
	oracleRw["CUBE"]="225";
	oracleRw["AND"]="226";
	oracleRw["OR"]="227";

	// データ型
	oracleRw["VARCHAR2"]="1";
	oracleRw["NVARCHAR2"]="1";
	oracleRw["NUMBER"]="1";
	oracleRw["LONG"]="1";
	oracleRw["DATE"]="1";
	oracleRw["BINARY_FLOAT"]="1";
	oracleRw["BINARY_DOUBLE"]="1";
	oracleRw["TIMESTAMP"]="1";
	oracleRw["INTERVAL"]="1";
	oracleRw["YEAR"]="1";
	oracleRw["MONTH"]="1";
	oracleRw["DAY"]="1";
	oracleRw["SECOND"]="1";
	oracleRw["RAW"]="1";
	oracleRw["ROWID"]="1";
	oracleRw["UROWID"]="1";
	oracleRw["CHAR"]="1";
	oracleRw["NCHAR"]="1";
	oracleRw["CLOB"]="1";
	oracleRw["NCLOB"]="1";
	oracleRw["BLOB"]="1";
	oracleRw["LOB"]="1";
	oracleRw["BFILE"]="1";

	oracleRw["KEY"]="2";
	oracleRw["CHECK"]="2";
	oracleRw["UNIQUE"]="2";
	oracleRw["CONSTRAINT"]="2";
	oracleRw["STORAGE"]="2";

	// 連想配列を呼出し元に戻す。
	return oracleRw;
}

/*
 * シンプルな折りたたみメニューを作成
 */
allOpend=false;
function foldingMenu(obj)
{
	if(!obj.id || obj.id.indexOf("li")!=0)
	{
		return false;
	}
	if(obj.id=="allopenbutton")
	{
		allOpen();
		return false;
	}

	obj2="u"+obj.id;

	if(document.all)
	{
		if(!document.all(obj2))
		{
			return false;
		}
		obj2=document.all(obj2);
		obj2.className=obj2.className=="open" ? "close":"open";
		obj.className=obj2.className;
	}
	else if(document.getElementById)
	{
		if(!document.getElementById(obj2))
		{
			return false;
		}
		obj2=document.getElementById(obj2);
		obj2.className=obj2.className=="open" ? "close":"open";
		obj.className=obj2.className;
	}
}
