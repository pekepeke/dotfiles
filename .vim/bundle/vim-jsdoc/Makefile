NAME=vim-jsdoc
	VERSION = 0.0.1

TESTFILES = test/*.vim
.PHONY: test doc

test: $(TESTFILES)
	vspec ${TESTFILES}

doc: check_vim_helpfile $(NAME).txt

$(NAME).txt:
	vim-helpfile README.md > doc/$(NAME).txt

check_vim_helpfile:
	-@which vim-helpfile >/dev/null 2>&1
