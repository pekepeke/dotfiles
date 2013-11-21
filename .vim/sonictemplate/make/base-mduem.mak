# Makefile for usual Vim plugin
# command : git submodule add https://github.com/kana/mduem.git mduem

REPOS_TYPE := vim-script
INSTALLATION_DIR := $(HOME)/.vim
TARGETS_STATIC = $(filter %.vim %.txt,$(all_files_in_repos))
TARGETS_ARCHIVED = $(all_files_in_repos) mduem/Makefile




include mduem/Makefile

# __END__
