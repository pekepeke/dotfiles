let s:save_cpo = &cpo
set cpo&vim

describe 'test table#base'
  let base = csvutil#table#base#new()
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

describe 'test table#markdown'
  let base = csvutil#table#markdown#new()
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
        \ ["aaaあ", "bbb", "あいうえおc", ],
        \ ["aiueo", "あいうえki", "kekosashi", ]
        \ ]
  let expected = [
        \ "aaaあ|bbb       |あいうえおc",
        \ "-----|----------|-----------",
        \ "aiueo|あいうえki|kekosashi  ",
        \ ]
  " echo base.render(list)
  call base.render(list)
  " echo join(expected, "\n")
  " Expect base.render(list) is join(expected, "\n")

end

let &cpo = s:save_cpo
