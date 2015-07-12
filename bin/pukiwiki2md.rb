#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

# $:.push(File.join(File.dirname(__FILE__), 'lib'))
# require 'rubygems'
# require "bundler"
# Bundler.setup
require 'uri'

module HTMLUtils
  ESC = {
    '&' => '&amp;',
    '"' => '&quot;',
    '<' => '&lt;',
    '>' => '&gt;'
  }
  def escape(str)
    table = ESC   # optimize
    str.gsub(/[&"<>]/u) {|s| table[s]}
  end
  CODE = {
    '<' => '&lt;',
    '>' => '&gt;',
    '&' => '&amp;'
  }
  def code_escape(str)
    table = CODE
    str.gsub(/[<>&]/u) {|s| table[s]}
  end
  URIENC = {
    '(' => '%28',
    ')' => '%29',
    ' ' => '%20'
  }
  def uri_encode(str)
    table = URIENC
    str.gsub(/[\(\) ]/u) {|s| table[s]}
  end
  def urldecode(str)
    str.gsub(/[A-F\d]{2}/u) {|x| [x.hex].pack('C*')}
  end
end

class PukiWikiParser
  include HTMLUtils

  def initialize()
    @h_start_level = 2
  end
  def filename(pw_name)
    decoded_name = HTMLUtils.urldecode(pw_name).sub(/\:/, '_').downcase.split("/").last
    name = decoded_name.sub(/\.txt$/, '.md')
    if @timestamp.nil? || @timestamp.size===0
      return name
    else
      return "#{@timestamp}-#{name}"
    end
  end
#   def timestamp()
#     @timestamp
#   end
  def to_md(src, page_names, page, base_uri = 'http://terai.xrea.jp/', suffix= '/')
    @page_names = page_names
    @base_uri = base_uri
    #@page = page.sub!(/\.txt$/, '')
    @page = page.sub(/\ASwing\/(.+)\.txt$/) { $1 }
    @pagelist_suffix = suffix
    @inline_re = nil # invalidate cache

    @timestamp = ''
    @title  = ''
    @author = ''
    @tags = ''

    buf = []
    lines = src.rstrip.split(/\r?\n/).map {|line| line.chomp }
    while lines.first
      case lines.first
      when ''
        buf.push lines.shift
      when /\ATITLE:/
        @title = lines.shift.sub(/\ATITLE:/, '')
      when /\ARIGHT:/
        /at (\w{4}-\w{2}-\w{2})/ =~ lines.first
        @timestamp = $1
        buf.push parse_inline(lines.shift.sub(/\ARIGHT:/, '').concat("\n"))
      when /\A----/
        lines.shift
        buf.push '- - - -' #hr
      when /\A\*/
        buf.push parse_h(lines.shift)
      when /\A\#code.*\{\{/
        buf.concat parse_pre2(take_multi_block(lines))
      when /\A\#.+/
        buf.push parse_block_plugin(lines.shift)
      when /\A\s/
        buf.concat parse_pre(take_block(lines, /\A\s/))
      when /\A\/\//
        #buf.concat parse_comment(take_block(lines, /\A\/\//))
        take_block(lines, /\A\/\//)
      when /\A>/
        buf.concat parse_quote(take_block(lines, /\A>/))
      when /\A-/
        #buf.push parse_inline(lines.shift)
        #buf.push ''
        buf.concat parse_list('ul', take_list_block(lines))
      when /\A\+/
        buf.concat parse_list('ol', take_block(lines, /\A\+/))
      when /\A:/
        buf.concat parse_dl(take_block(lines, /\A:/))
      else
        buf.concat parse_p(take_block(lines, /\A(?![*\s>:\-\+\#]|----|\z)/))
      end
    end
    buf.join("\n")

    # head = []
    # head.push("---")
    # head.push("layout: post")
    # head.push("title: #{@title}")
    # head.push("category: swing")
    # head.push("folder: #{@page}")
    # head.push("tags: [#{@tags}]")
    # head.push("author: #{@author}")
    # head.push("comment: true")
    # head.push("---")
    # head.push('')

    # head.join("\n").strip.concat(buf.join("\n"))
  end

  private

  def take_block(lines, marker)
    buf = []
    until lines.empty?
      break unless marker =~ lines.first
      if /\A\/\// =~ lines.first then
        lines.shift
      else
        buf.push lines.shift.sub(marker, '')
      end
    end
    buf
  end

  def take_multi_block(lines)
    buf = []
    until lines.empty?
      l = lines.shift
      break if /^\}\}$/ =~ l
      next  if /^.code.*$/ =~ l
      buf.push l
    end
    buf
  end

  def parse_h(line)
    level = @h_start_level + (line.slice(/\A\*{1,4}/).length - 1)
    h = "#"*level
    # content = line.sub(/\A\*+/, '')
    ##content = line.gsub(/\A\*+(.+) \[#\w+\]$/) { $1 }
    #"<h#{level}>#{parse_inline(content)}</h#{level}>"
    content = line.gsub(/\A\*+(.+)$/) { $1.gsub(/ +\[#\w+\]$/, "") }
    "#{h} #{parse_inline(content).strip}"
  end

  def take_list_block(lines)
    marker = /\A-/
    buf = []
    codeblock = false
    listblock = false
    until lines.empty?
      #break unless marker =~ lines.first
      #while lines.first
      case lines.first
      when /\A\/\//
        lines.shift
      when /\A----/
        if codeblock then
          buf.push "<!-- dummy comment line for breaking list -->"
        end
        #buf.push "<!-- dummy comment line for breaking list -->"
        break
      when marker
        l = lines.shift
        #puts l
        buf.push l #lines.shift #.sub(marker, '')
        listblock = true
        codeblock = false
        #puts buf.last
#       when /\A$/
#         buf.push lines.shift
      when /\A\s/
        buf.push '#' + lines.shift
        codeblock = true
        listblock = false
      when /\A\#code.*\{\{/
        array = []
        until lines.empty?
          l = lines.shift
          array.push l
          break if /^\}\}$/ =~ l
        end
        buf.concat array
        codeblock = true
        listblock = false
      else
        if listblock then
          buf.push "<!-- dummy comment line for breaking list -->"
          break
        elsif codeblock then
          buf.push lines.shift
        else
          break
        end
      end
    end
    buf
  end

  def parse_list(type, lines)
    marker = ((type == 'ul') ? /\A-+/ : /\A\++/)
    parse_list0(type, lines, marker)
  end

  def parse_list0(type, lines, marker)
    buf = []
    level = 0
    blockflag = false
    until lines.empty?
      line = lines.shift.strip
      aaa = line.slice(marker)
      if aaa then
        level = aaa.length - 1
        line = line.sub(marker,'').strip
      #else
      #  level = 0
      end
      h = "    "*level
      s = (type == 'ul') ? '-' : '1.'

      if line.empty? then
        #buf.push line
      elsif line.start_with?('#code') then
        hh = "    "*(level+1)
        array = take_multi_block(lines).map{|ll| hh + code_escape(ll)}
        line = array.shift.strip
        buf.concat [hh, %Q|#{hh}<pre class="prettyprint"><code>|.concat(line), array.join("\n"), "</code></pre>"]
        blockflag = false
      elsif line.start_with?('#') then
        unless blockflag then
          blockflag = true
          buf.push h
        end
        x = "\t"*2
        line = code_escape(line.sub(/\A\#\s/, ''))
        buf.push "#{h}#{x}#{line}"
      elsif  line.start_with?('<!--') then
        buf.concat ['', line]
        break
      else
        blockflag = false
        #puts "#{level}: #{line}"
        buf.push "#{h}#{s} #{parse_inline(line)}"
      end
    end
    buf
  end

  def parse_dl(lines)
    buf = ["<dl>"]
    lines.each do |line|
      dt, dd = *line.split('|', 2)
      buf.push "<dt>#{parse_inline(dt)}</dt>"
      buf.push "<dd>#{parse_inline(dd)}</dd>" if dd
    end
    buf.push "</dl>"
    buf
  end

  def parse_quote(lines)
    ["<blockquote><p>", lines.join("\n"), "</p></blockquote>"]
  end

  def parse_pre(lines)
    #[%Q|#{lines.map {|line| "\t".concat(line) }.join("\n")}|, %Q|{:class="prettyprint"}|]
    lines.map{|line| "\t".concat(line)} #.join("\n")
  end

  def parse_pre2(lines)
    array = lines.map{|line| code_escape(line)}
    array[0] = %Q|<pre class="prettyprint"><code>|.concat(array[0])
    [array.join("\n"), "</code></pre>"]
  end

  def parse_pre3(lines)
    ["``java", lines.join("\n"), "``"]
  end

  def parse_comment(lines)
    ["<!-- #{lines.map {|line| escape(line) }.join("\n")}",
      ' -->']
  end

  def parse_p(lines)
    lines.map {|line| parse_inline(line)}
  end

  def parse_inline(str)
    str = str.gsub(/%%(?!%)((?:(?!%%).)*)%%/) { ['~~', $1, '~~'].join() } #<del>, <strike>
    str = str.gsub(/`(?!`)((?:(?!`).)*)`/) { ['`', $1, '`'].join() }   #<code>
    str = str.gsub(/\'\'(?!\')((?:(?!\'\').)*)\'\'/) { ['**', $1, '**'].join() } #<strong>
    str = str.gsub(/KBD{([^}]*)}/) { ['<kbd>', $1, '</kbd>'].join() } #<kbd>
    @inline_re ||= %r!
        &([A-Za-z]+)(?:\(([^\)]+)\))?(?:{([^}]+)})?; # $1: plugin, $2: parameter, $3: inline
      | \[\[([^>]+)>?([^\]]*)\]\]     # $4: label,  $5: URI
      | \[(https?://\S+)\s+([^\]]+)\] # $6: label,  $7: URI
      | (#{autolink_re()})            # $8: Page name autolink
      | (#{URI.regexp('http')})       # $9: URI autolink
    !x
    str.gsub(@inline_re) {
      case
      when plugin   = $1 then parse_inline_plugin(plugin.strip, $2, $3)
      when bracket  = $4 then a_href($5.strip, bracket, 'pagelink')
      when bracket  = $7 then a_href($6.strip, bracket, 'outlink')
      when pagename = $8 then a_href(page_uri(pagename), pagename, 'pagelink')
      when uri      = $9 then a_href(uri, uri, 'outlink')
      else
        raise 'must not happen'
      end
    }
  end

  def parse_inline_plugin(plugin, para, inline)
    case plugin
    when 'jnlp'
      %Q|{% jnlp %}|
    when 'jar'
      %Q|{% jar %}|
    when 'zip'
      %Q|{% src %}\n- {% svn %}|
    when 'author'
      @author = para.strip #.delete("()")
      %Q|[#{@author}](#{@base_uri}#{@author}.html)|
    when 'new'
      inline.strip #.delete("{}")
    else
      plugin
    end
  end

  def parse_block_plugin(line)
    @plugin_re = %r<
        \A\#([^\(]+)\(?([^\)]*)\)?
      >x
    args = []
    line.gsub(@plugin_re) {
      args.push $1
      args.push $2 #.slice(",")
    }
    buf = []
    case args.first
    when 'ref'
      buf.push %Q<![screenshot](#{args[1]})>
    when 'tags'
      @tags = args[1]
    else
      buf.push ''
    end
    buf
  end

  def a_href(uri, label, cssclass)
    str = label.strip
    if(cssclass.casecmp('pagelink')==0) then
      if(uri.size===0) then
        %Q<[#{str}](#{@base_uri}#{escape(str)}.html)>
      else
        %Q<[#{str}](#{@base_uri}#{escape(uri.strip)}.html)>
      end
    else
      #%Q<[#{str}](#{URI.escape(uri.strip)})>
      %Q<[#{str}](#{uri_encode(uri.strip)})>
    end
  end

  def autolink_re
    Regexp.union(* @page_names.reject {|name| name.size <= 3 })
  end

  def page_uri(page_name)
    "#{@base_uri}#{urldecode(page_name)}#{@pagelist_suffix}"
  end
end

def render(body, fname = "page", page_names = [])
  include HTMLUtils
  parser = PukiWikiParser.new()
  content    = parser.to_md(body, page_names, HTMLUtils.urldecode(fname))
  filename = parser.filename(fname)

  [filename, content]
end

def main
  include HTMLUtils
  srcpath = ARGV[0]
  tgtpath = ARGV[1]

  if not srcpath.nil? and File.exist?(srcpath)
    Dir::glob("#{srcpath}/5377696E672F*.txt").each {|f|
    #Dir::glob("#{srcpath}/*.txt").each {|f|
      fname = File.basename(f)
      tbody = File.read(f)
      page_names = []
      filename, content = render(tbody, fname, page_names)

      unless /^_/ =~ filename
        if /-/ =~ filename
          nname  = [tgtpath, filename].join('/')
          puts filename
          outf = open(nname, "wb")
          outf.puts(content)
          outf.close()
        end
      end
    }
  else
    tbody = STDIN.read
    filename, content = render(tbody)
    puts "=" * 70
    puts content
  end
end

if __FILE__ == $0
  main
end

__END__
