#! /usr/local/bin/perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

use Encode;

my $INPUT=`cat -`;
my $THE_MARK=',';
my $ADD_SPC='';

# **============================================================
# * カンマを揃える
# * CSV ファイルの整形等に便利です。
# * $THE_MARK で指定された記号で桁揃えをします。
# * 
# * 例：
# *  before:
# *           Steve,Paul,Jobs,1955-2011
# *           Stephen,Gary,Wozniak,1950-
# *           William,Henry,Gates,1955-
# *  after:
# *           Steve,  Paul, Jobs,   1955-2011
# *           Stephen,Gary, Wozniak,1950-
# *           William,Henry,Gates,  1955-
# *
# * もしもう少し見やすく以下のようにしたければ、...
# *           Steve,   Paul,  Jobs,    1955-2011
# *           Stephen, Gary,  Wozniak, 1950-
# *           William, Henry, Gates,   1955-
# * ...冒頭の変数 $ADD_SPC に空白を一つ入れてください。
# * @author      odoru-saboten
# * @author      Tachi.K
# * @since       2011/10/06
# * @version     2011/10/06
# * @param       CotEditorXInput=Selection
# * @return      CotEditorXOutput=ReplaceSelection
# ============================================================

# ============================================================
# 最大のカラム数を得る
# ============================================================
$maxColumns = 0;
foreach my $line ( split(/\n/, $INPUT)) { 

  # カンマの出現回数を得る
  @list = split(/$THE_MARK/, $line);
  $length = @list;
  
  # 回数（カラム数）を記録する
  if ($maxColumns < $length) {
    $maxColumns = $length;
  }

}

# ============================================================
# それぞれの最大幅を取得し、配列に保存する
# ============================================================
@colWidths = ();
$#colWidths = $maxColumns - 1;
for ($i = 0; $i < $maxColumns; $i++) {
  $colWidths[$i] = 0;
}
foreach my $line ( split(/\n/, $INPUT)) { 

  # 最大幅を記録する
  $i = 0;
  foreach my $item ( split(/$THE_MARK/, $line)) {

    # 単語の長さを得る
    $itemEUC = $item;
    Encode::from_to($itemEUC, "utf8", "euc-jp" );
    $lengthOfItem = length($itemEUC);
    
    # 最大幅を記録する
    if ($colWidths[$i] < $lengthOfItem) {
      $colWidths[$i] = $lengthOfItem;
    } 
    $i++;
  }
}

# ============================================================
# 最大幅に従って空白を設定する
#     単語,（調整した空白）単語, ...
# ============================================================
foreach my $line ( split(/\n/, $INPUT)) { 
  $i = 0;
  $replaceLine = "";
  foreach my $item ( split(/$THE_MARK/, $line)) {
    # 単語の長さを得る
    $itemEUC = $item;
    Encode::from_to($itemEUC, "utf8", "euc-jp" );
    $lengthOfItem = length($itemEUC);

    # 必要なスペースを得る
    $lengthOfSpace = $colWidths[$i] - $lengthOfItem;
    $spc = "";
    for ($j = 0; $j < $lengthOfSpace; $j++) {
      $spc .= " ";
    }
    
    # 置き換え文字列を作成する
    if ($i < $maxColumns -1) {
      $replaceLine .= $item ."," .$spc .$ADD_SPC;
    } else {
      $replaceLine .= $item;
    }
    
    $i++;
  }
  
  #出力
  print "$replaceLine\n";
}














