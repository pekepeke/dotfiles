class {{_expr_:substitute(substitute(expand('%:p:t:r'), '\w\+', '\u\0', ''), '-\(\w\)', '\u\1', 'g')}} < Cask
  url 'http://path/to.zip'
  homepage 'http://'
  version ''
  sha256 ''
  # no_checksum
  link '{{_expr_:substitute(substitute(expand('%:p:t:r'), '\w\+', '\u\0', ''), '-\(\w\)', '\u\1', 'g')}}.app'
end

