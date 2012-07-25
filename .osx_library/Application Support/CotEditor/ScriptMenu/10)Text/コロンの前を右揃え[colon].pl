#! /usr/local/bin/perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

use Encode;

my $INPUT=`cat -`;
my $THE_MARK = ":";

# **============================================================
# * 記号で揃える.
# * $THE_MARK で指定された記号の前の単語を右揃えする。
# * 例：
# *  before:
# *           [someInstance someMessage: someParameter
# *            andMore: secondPrameter];
# *  //      ^ 一つ以上は空白を入れてください。
# *  after:
# *           [someInstance someMessage: someParameter
# *                             andMore: secondPrameter];
# *
# * @author      odoru-saboten
# * @author      Tachi.K
# * @since       2011/03/09
# * @version     2011/03/09
# * @param       CotEditorXInput=Selection
# * @return      CotEditorXOutput=ReplaceSelection
# ============================================================

# ============================================================
# THE_MARK 直前の単語の最大幅を得る
# ============================================================
$max1stColumn  = 0;
$maxWordLength = 0;
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /(^.*)(?:\s+)(.+)(${THE_MARK})(?:\s?)(.*)$/os) {
    $firstPart = $1;
    $wordPart  = $2;
    
    # 単語の長さを得る
    $wordPartEUC = $wordPart;
    Encode::from_to($wordPartEUC, "utf8", "euc-jp" );
    $lengthOfWordPart = length($wordPartEUC);
    
    # 最大値を得る
    if ($maxWordLength < $lengthOfWordPart) {
      $maxWordLength= $lengthOfWordPart;
    }
    # 単語以前の長さを得る
    $firstPatrEUC = $firstPart;
    Encode::from_to($firstPatrEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPatrEUC);
    
    # 最大値を得る
    if ($max1stColumn < $lengthOfFirstPart) {
      $max1stColumn = $lengthOfFirstPart;
    }
  }
}
$maxLength = $max1stColumn + $maxWordLength;

# ============================================================
# 最大幅に従って空白を設定する
#     $1 調整した空白 $2 $3($THE_MARK) $4
# ============================================================
$isFirstTime = 1;
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /(^.*)(?:\s+)(.+)(${THE_MARK})(?:\s?)(.*)$/os) {
    $firstPart = $1;
    $wordPath  = $2;
    $lastPart  = $4;
    
    # 一行目のみ、前半の長さを得る
    $firstPartEUC = $firstPart;
    Encode::from_to($firstPartEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPartEUC);
    
    # 単語の長さを得る
    $wordPartEUC = $wordPath;
    Encode::from_to($wordPartEUC, "utf8", "euc-jp" );
    $lengthOfWordPart = length($wordPartEUC);
    
    # 必要なスペースを得る
    $lengthOfSpace = $maxLength - ($lengthOfFirstPart + $lengthOfWordPart);
    $spc = "";
    for ($i = 0; $i < $lengthOfSpace; $i++) {
      $spc .= " ";
    }
    
    print "$firstPart $spc$wordPath$THE_MARK $lastPart\n";
  } else {
    print "$line\n";
  }
}














