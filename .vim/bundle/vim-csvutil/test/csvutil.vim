let s:save_cpo = &cpo
set cpo&vim

describe 'test reader'
  let s = "a,b,c\nd,e,f\n\n"
  let expected = [
        \   ['a', "b", 'c'],
        \   ['d', 'e', 'f']
        \ ]
  let csv = csvutil#csv_reader()
  let list = csv.parse_from_string(s)
  Expect len(list[0]) is 3
  Expect len(list[1]) is 3
  Expect list == expected

  let s = "a,\"b\",c\nd,e,f\n\n"
  let expected = [
        \   ['a', "b", 'c'],
        \   ['d', 'e', 'f']
        \ ]
  let csv = csvutil#csv_reader()
  let list = csv.parse_from_string(s)
  Expect len(list[0]) is 3
  Expect len(list[1]) is 3
  Expect list == expected

  let s = "a,\"b\na\"\"b\",c\nd,e,f\n\n"
  let expected = [
        \   ['a', "b\na\"b", 'c'],
        \   ['d', 'e', 'f']
        \ ]
  let csv = csvutil#csv_reader()
  let list = csv.parse_from_string(s)

  Expect len(list[0]) is 3
  Expect len(list[1]) is 3
  Expect list == expected
  " Expect list[0] == ['a', "b\na\"b", 'c']
  " Expect list[1] == ['d', 'e', 'f']
  " for i in range(0, len(list) -1, 1)
  "   Expect list[i] == expected[i]
  " endfor
end

describe 'test writer'
  let csv = csvutil#csv_writer()
  call csv.add('a').add('"a').add("a\n").add("a,")
  let s = join(['a,"""a","a', '","a,"'], "\n")
  Expect csv.render() == s
end

let &cpo = s:save_cpo
