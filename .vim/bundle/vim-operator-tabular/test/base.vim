let s:save_cpo = &cpo
set cpo&vim

"#base  {{{1
describe 'test #base'
  let base = operator#tabular#base#new()
  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  Expect base.render(list) is ""
  Expect [5, 4, 11] == base.layout()

  let list = [
        \ ]
  Expect base.render(list) is ""
  Expect [] == base.layout()
  " echo list
end

" #markdown {{{1
describe 'test #markdown'
  let base = operator#tabular#markdown#new()
  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  let expected = [
        \ "aaa  |bbb |cc         ",
        \ "-----|----|-----------",
        \ "aiueo|kaki|kukekosashi",
        \ ]
  Expect base.render(list) is join(expected, "\n")

  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  Expect base.restore_from_lines(expected) == list

  let list = [
        \ ["aaaあ", "bbb", "あいうえおc", ],
        \ ["aiueo", "あいうえki", "kekosashi", ]
        \ ]
  let expected = [
        \ 'aaaあ|bbb       |あいうえおc',
        \ '-----|----------|-----------',
        \ 'aiueo|あいうえki|kekosashi  ',
        \ ]

  call base.render(list)
  " Expect base.render(list) is join(expected, "\n")

  call base.restore_from_lines(expected)
  " echo base.restore_from_lines(expected)

end

" #textile {{{1
describe 'test #textile'
  let base = operator#tabular#textile#new()
  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  let expected = [
        \ "aaa  |bbb |cc         ",
        \ "aiueo|kaki|kukekosashi",
        \ ]
  Expect base.render(list) is join(expected, "\n")

  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  Expect base.restore_from_lines(expected) == list

  let list = [
        \ ["aaaあ", "bbb", "あいうえおc", ],
        \ ["aiueo", "あいうえki", "kekosashi", ]
        \ ]
  let expected = [
        \ 'aaaあ|bbb       |あいうえおc',
        \ 'aiueo|あいうえki|kekosashi  ',
        \ ]

  call base.render(list)
  " Expect base.render(list) is join(expected, "\n")

  call base.restore_from_lines(expected)
  " echo base.restore_from_lines(expected)

end

" #backlog {{{1
describe 'test #backlog'
  let base = operator#tabular#backlog#new()
  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  let expected = [
        \ "|aaa  |bbb |cc         |h",
        \ "|aiueo|kaki|kukekosashi|",
        \ ]
  Expect base.render(list) is join(expected, "\n")

  let list = [
        \ ["aaa", "bbb", "cc", ],
        \ ["aiueo", "kaki", "kukekosashi", ]
        \ ]
  Expect base.restore_from_lines(expected) == list

  let list = [
        \ ["aaaあ", "bbb", "あいうえおc", ],
        \ ["aiueo", "あいうえki", "kekosashi", ]
        \ ]
  let expected = [
        \ '|aaaあ|bbb       |あいうえおc|h',
        \ '|aiueo|あいうえki|kekosashi  |',
        \ ]

  call base.render(list)
  " Expect base.render(list) is join(expected, "\n")

  call base.restore_from_lines(expected)
  " echo base.restore_from_lines(expected)

end

let &cpo = s:save_cpo
" __END__ " {{{1
