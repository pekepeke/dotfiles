#! /usr/local/bin/perl
# %%%{CotEditorXInput=Selection}%%%
# %%%{CotEditorXOutput=ReplaceSelection}%%%

use Encode;

my $INPUT=`cat -`;
my $THE_MARK = "#";

# **============================================================
# * 記号で揃える.
# * $THE_MARK で指定された記号を左揃えする。
# * 例：
# *  before:
# *          $int_foo = 123; # the integer Foo
# *          $string_bar = "234";  # the string Bar
# *
# *  after:
# *          $int_foo = 123;       # the integer Foo
# *          $string_bar = "234";  # the string Bar
# *
# * @author      odoru-saboten
# * @author      Tachi.K
# * @since       2011/03/02
# * @version     2011/03/02
# * @param       CotEditorXInput=Selection
# * @return      CotEditorXOutput=ReplaceSelection
# ============================================================

# ============================================================
# THE_MARK 以前の最大幅を得る
# ============================================================
$maxColumn = 0;
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /$THE_MARK/os) {
    $firstPart = $`;
    
    # 前半の長さを得る
    $firstPartEUC = $firstPart;
    Encode::from_to($firstPartEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPartEUC);
    
    # 最大値を得る
    if ($maxColumn < $lengthOfFirstPart) {
      $maxColumn = $lengthOfFirstPart;
    }
  }
}

# ============================================================
# 最大幅に従って空白を設定する
# ============================================================
foreach my $line ( split(/\n/, $INPUT)) { 
  # THE_MARK 前後を得る
  if ($line =~ /$THE_MARK/os) {
    $firstPart = $`;
    $secondPart = $&.$';
    
    # 前半の長さを得る
    $firstPartEUC = $firstPart;
    Encode::from_to($firstPartEUC, "utf8", "euc-jp" );
    $lengthOfFirstPart = length($firstPartEUC);
    
    # 必要なスペースを得る
    $lengthOfSpace = $maxColumn - $lengthOfFirstPart;
    $spc = "";
    for ($i = 0; $i < $lengthOfSpace; $i++) {
      $spc .= " ";
    }
    
    print "$firstPart$spc$secondPart\n";
  } else {
    print "$line\n";
  }
}














