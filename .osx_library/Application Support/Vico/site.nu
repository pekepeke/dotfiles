(set $textwidth 80)
(set $clipboard 1)

((ViMap insertMap) setKey:"<c-f>" toMotion:"move_right:")
((ViMap insertMap) setKey:"<c-b>" toMotion:"move_left:")
((ViMap insertMap) setKey:"<c-a>" toMotion:"move_first_char:")
((ViMap insertMap) setKey:"<c-e>" toEditAction:"append_eol:")
; don't work??
((ViMap insertMap) setKey:"<c-h>" toAction:"input_backspace:")

; like replace.vim
((ViMap normalMap) map:"_iw" to:"viwPyiw")
((ViMap normalMap) map:"_aw" to:"vawPyiw")
((ViMap visualMap) map:"_" to:"P")

; comment/uncomment selection
;;((ViMap visualMap) map:"<cmd-\\>" to:":\'<,\'>s/^/#/<ENTER>")
;;((ViMap normalMap) map:"<cmd-\\>" to:"V:\'<,\'>s/^/#/<ENTER>" )
;;((ViMap visualMap) map:"<cmd-|>" to:":\'<,\'>s/^#//<ENTER>")
;;((ViMap normalMap) map:"<cmd-|>" to:"V:\'<,\'>s/^#//<ENTER>")
((ViMap visualMap) map:"gc" to:"<cmd-/>")
((ViMap normalMap) map:"gc" to:"<cmd-/>")

(load "console")
(global console ((NuConsoleWindowController alloc) init))

