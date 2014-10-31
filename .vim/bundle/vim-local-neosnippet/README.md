local-neosnippet.vim
====

write following code in vimrc_local.vim

```vim
call local_neosnippet#source(fnamemodify("<sfile>", ":p:h:r"))
```

### commands

#### LocalNeoSnippetEdit

### variables

#### g:local_neosnippet#filename

snippet filename (default: '.&filetype.snip')

#### g:local_neosnippet#edit_method

edit snippet.(default : "split")

