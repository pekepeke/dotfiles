let s:save_cpo = &cpo
set cpo&vim

"#base  {{{1
describe 'tabular#base methods'
  it 'should run without errors'
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
  end

  it 'should format strings'
    let base = operator#tabular#base#new()
    let base._layout = [5, 5]
    let expected = ["a    ", "bbb  "]
    Expect expected == base.fill_items(["a", "bbb"])

    let expected = ['-----', '-----']
    Expect expected == base.make_separator('-')

    let expected = ['+++++', '+++++']
    Expect expected == base.make_separator('+')
  end
end

" #markdown {{{1
describe 'tabular#markdown methods'
  it 'should run without errors'
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
  end

  it 'should run without errors if received input is multibyte strings'
    let base = operator#tabular#markdown#new()

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

end

" #textile {{{1
describe 'tabular#textile methods'
  it 'should run without errors'
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
  end

  it 'should run without errors if received input is multibyte strings'
    let base = operator#tabular#textile#new()

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
end

" #backlog {{{1
describe 'tabular#backlog'
  it 'should run without errors'
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
  end

  it 'should run without errors if received input is multibyte strings'
    let base = operator#tabular#backlog#new()
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

end

let &cpo = s:save_cpo
" __END__ " {{{1
