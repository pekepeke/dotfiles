#!/usr/bin/make -f

#----------------------------------------------------------------------
#
# javaScript
#
COFFEE      := coffee
COFFEEFLAGS := -b
TARGETS     += ${patsubst %.coffee, %.js, ${wildcard *.coffee}}

.SUFFIXES : .js .coffee

%.js : %.coffee
	${COFFEE} ${COFFEEFLAGS} -c $<

#----------------------------------------------------------------------
#
# HTML/XHTML/GOML
#
HAML        := haml
HAMLFLAGS   := -q
XHAMLFLAGS  := ${HAMLFLAGS}
GHAMLFLAGS  := ${HAMLFLAGS}
MARKDOWN    := markdown
MDFLAGS     :=
TARGETS     += ${patsubst %.haml,  %.html,  ${wildcard *.haml}}     \
			   ${patsubst %.md,    %.html,  ${wildcard *.md}}       \
			   ${patsubst %.xhaml, %.xhtml, ${wildcard *.xhaml}}    \
			   ${patsubst %.ghaml, %.goml,  ${wildcard *.ghaml}}

.SUFFIXES : .html  .haml    \
					.md     \
			.xhtml .xhaml   \
			.goml  .ghaml

%.html : %.haml
	${HAML} ${HAMLFLAGS} $< $@

%.xhtml : %.xhaml
	${HAML} -f xhtml ${XHAMLFLAGS} $< $@

%.goml : %.ghaml
	${HAML} ${GHAMLFLAGS} $< $@

%.html : %.md
	echo '<!DOCTYPE html>'           >$@
	echo '<meta charset="UTF-8">'   >>$@
	echo '<title></title>'          >>$@
	echo ''                         >>$@
	${MARKDOWN} ${MDFLAGS} $<       >>$@

#
# CSS
#
LESSC       := lessc
LESSFLAGS   :=
SASS        := sass
SCSSFLAGS   :=
SASSFLAGS   := ${SCSSFLAGS}
TARGETS     += ${patsubst %.less, %.css, ${wildcard *.less}}    \
			   ${patsubst %.scss, %.css, ${wildcard *.scss}}

.SUFFIXES : .css .less  \
			.scss

%.css : %.less
	${LESSC} ${LESSFLAGS} $< $@

%.css : %.scss
	${SASS} ${SASSFLAGS} $<:$@

#----------------------------------------------------------------------
#
# Erlang
#
ERLC        := erlc
ERLFLAGS    :=
TARGETS     += ${patsubst %.erl, %.beam, ${wildcard *.erl}}

.SUFFIXES : .beam .erl

%.beam : %.erl
	${ERLC} ${ERLFLAGS} $<

#----------------------------------------------------------------------
#
# Haskell
#
GHC         := ghc
GHCFLAGS    :=
TARGETS     += ${patsubst %.hs, %, ${wildcard *.hs}}

.SUFFIXES : .hs

% : %.hs
	${GHC} ${GHCFLAGS} -o $@ $<

#
# OCaml
#
OCAMLC      := ocamlc
OCAMLFLAGS  :=
TARGETS     += ${patsubst %.ml, %, ${wildcard *.ml}}

.SUFFIXES : .ml

% : %.ml
	${OCAMLC} ${OCAMLFLAGS} -o $@ $<

#----------------------------------------------------------------------
#
# C/C++
#
TARGETS     += ${patsubst %.c,   %, ${wildcard *.c}}    \
			   ${patsubst %.cpp, %, ${wildcard *.cpp}}

.SUFFIXES : .c  \
			.cpp

#----------------------------------------------------------------------
#
# D
#
GDC         := gdc
GDCFLAGS    :=
TARGETS     += ${patsubst %.d, %, ${wildcard *.d}}

.SUFFIXES : .d

% : %.d
	${GDC} ${GDCFLAGS} -o $@ $<

#----------------------------------------------------------------------
#
# Objective-C
#
OBJCC       := gcc
OBJCFLAGS   :=
TARGETS     += ${patsubst %.m, %, ${wildcard *.m}}

.SUFFIXES : .m

% : %.m
	${OBJCC} ${OBJCFLAGS} -o $@ $<

#----------------------------------------------------------------------
#
# Java/Scala
#
JAVAC       := javac
JAVAFLAGS   :=
SCALAC      := scalac
SCALAFLAGS  :=
TARGETS     += ${patsubst %.java,  %.class, ${wildcard *.java}} \
			   ${patsubst %.scala, %.class, ${wildcard *.scala}}

.SUFFIXES : .class .java    \
			.scala

%.class : %.java
	${JAVAC} ${JAVAFLAGS} $<

%.class : %.scala
	${SCALAC} ${SCALAFLAGS} $<

#----------------------------------------------------------------------
#
# Verilog
#
IVERILOG        := iverilog
IVERILOGFLAGS   :=
TARGETS         += ${patsubst %.v, %, ${wildcard *.v}}

.SUFFIXES : .v

% : %.v
	${IVERILOG} ${IVERILOGFLAGS} -o $@ $<

#----------------------------------------------------------------------
#
# C#/F# (.mono)
#
DMCS        := dmcs
DMCSFLAGS   :=
FSHARPC     := fsharpc
FSHARPFLAGS :=
TARGETS     += ${patsubst %.cs, %.exe, ${wildcard *.cs}}    \
			   ${patsubst %.fs, %.exe, ${wildcard *.fs}}

.SUFFIXES : .exe .cs    \
	             .fs
%.exe : %.cs
	${DMCS} ${DMCSFLAGS} $<

%.exe : %.fs
	${FSHARPC} ${FSHARPFLAGS} $<

#----------------------------------------------------------------------
#
# Graphviz
#
DOT         := dot
DOTFLAGS    :=
TARGETS     += ${patsubst %.dot, %.png, ${wildcard *.dot}}

.SUFFIXES : .png .dot

%.png : %.dot
	${DOT} ${DOTFLAGS} -Tpng -o $@ $<

#----------------------------------------------------------------------
#
# Racc
#
RACC        := racc
RACCFLAGS   := -g
TARGETS     += ${patsubst %.ry, %.rb, ${wildcard *.ry}}

.SUFFIXES : .ry .rb

%.rb : %.ry
	${RACC} ${RACCFLAGS} -o $@ $<

#======================================================================
#
# dependencies
#
.PHONY: build clean

build : ${TARGETS}

clean :
	${RM} ${TARGETS}
