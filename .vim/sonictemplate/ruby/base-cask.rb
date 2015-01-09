cask :v1 => '{{_expr_:expand('%:p:t:r')}}' do
  version ''
  sha256 ''
  # no_checksum

  url 'http://path/to.zip'
  homepage 'http://'

  name '{{_expr_:substitute(substitute(expand('%:p:t:r'), '\w\+', '\u\0', ''), '-\(\w\)', '\u\1', 'g')}}.app'
  app '{{_expr_:substitute(substitute(expand('%:p:t:r'), '\w\+', '\u\0', ''), '-\(\w\)', '\u\1', 'g')}}.app'
end

