#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

require 'erb'

contents = `markdown #{ARGV[0]}`
# begin
  # require 'rubygems'
  # require 'kramdown'
  # contents = Kramdown::Document.new(File.read(ARGV[0])).to_html
# rescue LoadError => ex
  # contents = `markdown #{ARGV[0]}`
# end
puts ERB.new(DATA.read).run(binding)

__END__
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8">
<style type="text/css">
*{margin:0;padding:0;}
html,body{height:100%;color:black;}
body{background-color:white;font:13.34px helvetica,arial,freesans,clean,sans-serif;*font-size:small;}
table{font-size:inherit;font:100%;}
input[type=text],input[type=password],input[type=image],textarea{font:99% helvetica,arial,freesans,sans-serif;}
select,option{padding:0 .25em;}
optgroup{margin-top:.5em;}
input.text{padding:1px 0;}
pre,code{font:12px Monaco,"Courier New","DejaVu Sans Mono","Bitstream Vera Sans Mono",monospace;}
body *{line-height:1.4em;}
p{margin:1em 0;}
img{border:0;}
abbr{border-bottom:none;}
.clearfix:after{content:".";display:block;height:0;clear:both;visibility:hidden;}
* html .clearfix{height:1%;}
.clearfix{display:inline-block;}
.clearfix{display:block;}
html{overflow-y:scroll;}
a{color:#4183c4;text-decoration:none;}
a:hover{text-decoration:underline;}
h2,h3{margin:1em 0;}
.sidebar h4{margin:15px 0 5px 0;font-size:11px;color:#666;text-transform:uppercase;}
* html .hfields{height:1%;}
* html .htabs{height:1%;}
div.content{font-size:14px;color:#333;}
.content h2{margin:40px 0 -10px 0;font-size:18px;color:#000;}
.feature-content h2{margin:0 0 -10px 0;font-size:18px;}
.content h2:first-child,.content .rule+h2{margin-top:0;}
.content h3{color:#000;margin:1.5em 0 -0.5em 0;}
.content h3:first-child{margin-top:5px;}
.content .figure{margin:15px 0;padding:1px;border:1px solid #e5e5e5;}
.content .figure:first-child{margin-top:0;}
.content ul{margin:25px 0 25px 25px;}
.content ul ul{margin-top:10px;margin-bottom:10px;}
.content .quote{margin:25px 30px;}
.content .quote blockquote{margin:0;font-family:Georgia,Times,serif;font-style:italic;color:#666;}
.content .quote cite{display:block;font-size:12px;font-weight:bold;font-style:normal;color:#333;text-align:right;}
pre.terminal{padding:10px 10px 10px 23px;color:#fff;background:url(/images/modules/features/terminal_sign.png) 10px 50% no-repeat #333;-webkit-border-radius:4px;-moz-border-radius:4px;border-radius:4px;}
.wikistyle h1,.wikistyle h2,.wikistyle h3,.wikistyle h4,.wikistyle h5,.wikistyle h6{border:0!important;}
.wikistyle h1{font-size:170%!important;border-top:4px solid #aaa!important;padding-top:.5em!important;margin-top:1.5em!important;}
.wikistyle h1:first-child{margin-top:0!important;padding-top:.25em!important;border-top:none!important;}
.wikistyle h2{font-size:150%!important;margin-top:1.5em!important;border-top:4px solid #e0e0e0!important;padding-top:.5em!important;}
.wikistyle h3{margin-top:1em!important;}
.wikistyle p{margin:1em 0!important;line-height:1.5em!important;}
.wikistyle a.absent{color:#a00;}
.wikistyle ul,#wiki-form .content-body ul{margin:1em 0 1em 2em!important;}
.wikistyle ol,#wiki-form .content-body ol{margin:1em 0 1em 2em!important;}
.wikistyle ul li,#wiki-form .content-body ul li,.wikistyle ol li,#wiki-form .content-body ol li{margin-top:.5em;margin-bottom:.5em;}
.wikistyle ul ul,.wikistyle ul ol,.wikistyle ol ol,.wikistyle ol ul,#wiki-form .content-body ul ul,#wiki-form .content-body ul ol,#wiki-form .content-body ol ol,#wiki-form .content-body ol ul{margin-top:0!important;margin-bottom:0!important;}
.wikistyle blockquote{margin:1em 0!important;border-left:5px solid #ddd!important;padding-left:.6em!important;color:#555!important;}
.wikistyle dt{font-weight:bold!important;margin-left:1em!important;}
.wikistyle dd{margin-left:2em!important;margin-bottom:1em!important;}
.wikistyle table{margin:1em 0!important;}
.wikistyle table th{border-bottom:1px solid #bbb!important;padding:.2em 1em!important;}
.wikistyle table td{border-bottom:1px solid #ddd!important;padding:.2em 1em!important;}
.wikistyle pre{margin:1em 0!important;font-size:12px!important;background-color:#f8f8ff!important;border:1px solid #dedede!important;padding:.5em!important;line-height:1.5em!important;color:#444!important;overflow:auto!important;}
.wikistyle pre code{padding:0!important;font-size:12px!important;background-color:#f8f8ff!important;border:none!important;}
.wikistyle code{font-size:12px!important;background-color:#f8f8ff!important;color:#444!important;padding:0 .2em!important;border:1px solid #dedede!important;}
.wikistyle a code,.wikistyle a:link code,.wikistyle a:visited code{color:#4183c4!important;}
.wikistyle img{max-width:100%;}
.wikistyle pre.console{margin:1em 0!important;font-size:12px!important;background-color:black!important;padding:.5em!important;line-height:1.5em!important;color:white!important;}
.wikistyle pre.console code{padding:0!important;font-size:12px!important;background-color:black!important;border:none!important;color:white!important;}
.wikistyle pre.console span{color:#888!important;}
.wikistyle pre.console span.command{color:yellow!important;}
.wikistyle .frame{margin:0;display:inline-block;}
.wikistyle .frame img{display:block;}
.wikistyle .frame>span{display:block;border:1px solid #aaa;padding:4px;}
.wikistyle .frame span span{display:block;font-size:10pt;margin:0;padding:4px 0 2px 0;text-align:center;line-height:10pt;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;}
.wikistyle .float-left{float:left;padding:.5em 1em .25em 0;}
.wikistyle .float-right{float:right;padding:.5em 0 .25em 1em;}
.wikistyle .align-left{display:block;text-align:left;}
.wikistyle .align-center{display:block;text-align:center;}
.wikistyle .align-right{display:block;text-align:right;}
.wikistyle.gollum.footer{border-top:4px solid #f0f0f0;margin-top:2em;}
.wikistyle.gollum>h1:first-child{display:none;}
.wikistyle.gollum.asciidoc>div#header>h1:first-child{display:none;}
.wikistyle.gollum.asciidoc .ulist p,.wikistyle.gollum.asciidoc .olist p{margin:0!important;}
.wikistyle.gollum.asciidoc .loweralpha{list-style-type:lower-alpha;}
.wikistyle.gollum.asciidoc .lowerroman{list-style-type:lower-roman;}
.wikistyle.gollum.asciidoc .upperalpha{list-style-type:upper-alpha;}
.wikistyle.gollum.asciidoc .upperroman{list-style-type:upper-roman;}
.wikistyle.gollum.org>p.title:first-child{display:none;}
.wikistyle.gollum.org p:first-child+h1{border-top:none!important;}
.wikistyle.gollum.pod>a.dummyTopAnchor:first-child+h1{display:none;}
.wikistyle.gollum.pod h1 a{text-decoration:none;color:inherit;}
.wikistyle.gollum.rest>div.document>div.section>h1:first-child{display:none;}
.wiki-form .inner{margin:0;padding:5px 0 5px 5px;background:#fff;border:solid 1px #888;}
.wiki-form input[type=text]{width:100%;}
label.wiki-label{padding:1em 5px;}
#wiki_format{margin-top:.3em;}
</style>
</head>
<body>
<div class="body wikistyle" style="margin:3em;padding:5px;">
<%= contents %>
</div>
</body>
</html>
