let s:save_cpo = &cpo
set cpo&vim

let b:surround_{char2nr('1')} = "<h1>\r</h1>"
let b:surround_{char2nr('2')} = "<h2>\r</h2>"
let b:surround_{char2nr('3')} = "<h3>\r</h3>"
let b:surround_{char2nr('4')} = "<h4>\r</h4>"
let b:surround_{char2nr('5')} = "<h5>\r</h5>"
let b:surround_{char2nr('6')} = "<h6>\r</h6>"

let b:surround_{char2nr('p')} = "<p>\r</p>"
let b:surround_{char2nr('u')} = "<ul>\r</ul>"
let b:surround_{char2nr('o')} = "<ol>\r</ol>"
let b:surround_{char2nr('l')} = "<li>\r</li>"
let b:surround_{char2nr('a')} = "<a href=\"\">\r</a>"
let b:surround_{char2nr('A')} = "<a href=\"\r\"></a>"
let b:surround_{char2nr('i')} = "<img src=\"\r\" alt=\"\" />"
let b:surround_{char2nr('I')} = "<img src=\"\" alt=\"\r\" />"
let b:surround_{char2nr('d')} = "<div>\r</div>"
let b:surround_{char2nr('D')} = "<div class=\"selection\">\r</div>"

let &cpo = s:save_cpo
