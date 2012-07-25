#! /usr/local/bin/perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

use Encode;

my $INPUT=`cat -`;
my $THE_MARK = '¥'; 

# **============================================================
# * 記号の後ろで右揃えする.
# * $THE_MARK で指定された記号の後ろ側を右揃えする。
# * 例：
# *  before:
# *          iMac ¥108,800
# *          iPod shuffle  ¥4,800
# *
# *  after:  iMac          ¥108,800
# *          iPod shuffle    ¥4,800
# *
# * @author      odoru-saboten
# * @author      Tachi.K
# * @since       2011/03/02
# * @version     2011/03/02
# * @param       CotEditorXInput=Selection
# * @return      CotEditorXOutput=ReplaceSelection
# ============================================================

# ============================================================
# THE_MARK 前後の文字列の最大幅を得る
# ============================================================
$maxWidthOf1stColumn = 0;
$maxWidthOf2ndColumn = 0;
$minWidthOf2ndColumn = -1;
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /$THE_MARK */os) {
    $firstPart  = $`;
    $secondPart = $&.$';
    
    # 前半の長さを得る
    $firstPartEUC = $firstPart;
    Encode::from_to($firstPartEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPartEUC);
    
    # 後半の長さを得る
    $secondPartEUC = $secondPart;
    Encode::from_to($secondPartEUC, "utf8", "euc-jp" );
    $lengthOfSecondPart = length($secondPartEUC);
    
    # 最大値を得る
    if ($maxWidthOf1stColumn < $lengthOfFirstPart) {
      $maxWidthOf1stColumn = $lengthOfFirstPart;
    }
    if ($maxWidthOf2ndColumn < $lengthOfSecondPart) {
      $maxWidthOf2ndColumn = $lengthOfSecondPart;
    }
  }
}

# ============================================================
# 最大幅に従って空白を設定する
# ============================================================
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /$THE_MARK */os) {
    $firstPart  = $`;
    $secondPart = $&.$';
    
    # 前半の長さを得る
    $firstPartEUC = $firstPart;
    Encode::from_to($firstPartEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPartEUC);
    
    # 後半の長さを得る
    $secondPartEUC = $secondPart;
    Encode::from_to($secondPartEUC, "utf8", "euc-jp" );
    $lengthOfSecondPart = length($secondPartEUC);
    
    # 必要なスペースを得る
    $lengthOfSpace1 = $maxWidthOf1stColumn - $lengthOfFirstPart;
    $lengthOfSpace2 = $maxWidthOf2ndColumn - $lengthOfSecondPart;
    $lengthOfSpace  = $lengthOfSpace1 + $lengthOfSpace2;
    $spc = "";
    for ($i = 0; $i < $lengthOfSpace; $i++) {
      $spc .= " ";
    }
    
    print "$firstPart$spc$secondPart\n";
  } else {
    print "$line\n";
  }
}














