# -*- coding: utf-8 -*-


require 'formula'

class Vim <Formula
  # Get stable versions from hg repo instead of downloading an increasing
  # number of separate patches.
  url 'https://vim.googlecode.com/hg/', :revision => '1052677493be'
  version '7.3.631'
  homepage 'http://www.vim.org/'

  # head 'https://code.google.com/p/vim/'
  head 'https://vim.googlecode.com/hg/'

  def features; %w(tiny small normal big huge) end
  def interp; %w(lua mzscheme perl python python3 tcl ruby) end
  def options
    [
      ["--with-features=TYPE", "tiny, small, normal, big or huge (default: huge)"],
      ["--enable-interp=NAME,...", "lua, mzscheme, perl, python, python3, tcl and/or ruby (default:python,ruby,perl)"]
    ]
  end

  def install
    def opt_val(opt)
      opt.sub(/.*?=(.*)$/, "\\1") rescue nil
    end
    opts = []
    feature = opt_val(ARGV.find {|s| s =~ /^--with-features=/ }) || "fuge"
    # For compatibility and convenience {{{
    feature_shorthand = features.find {|f| ARGV.include? "--#{f}" }
    feature = feature_shorthand if feature_shorthand
    # }}}
    opts << "--with-features=#{feature}"

    interps = opt_val(ARGV.find {|s| s =~ /^--enable-interp=/ }) || "python,ruby,perl"
    interps = interps.split(/,/)
    # For compatibility and convenience {{{
    interp.each do |i|
      if ARGV.include? "--#{i}"
        interps << i
      end
    end
    # }}}
    interps.uniq!
    interps.each do |i|
      opts << "--enable-#{i}interp=yes"
      opts << "--with-lua-prefix=/usr/local" if i == "lua"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-gui",
                          "--without-x",
                          "--disable-gpm",
                          "--disable-nls",
                          "--disable-netbeans",
                          "--disable-arabic",
                          "--disable-farsi",
                          "--disable-cscope",
                          "--disable-emacs_tags",
                          "--disable-keymap",
                          "--disable-langmap",
                          "--enable-feature=browse",
                          "--enable-multibyte",
                          "--with-tlib=ncurses",
                          *opts
                          # "--enable-perlinterp",
                          # "--enable-pythoninterp",
                          # # "--enable-python3interp",
                          # "--enable-rubyinterp",
                          # "--with-features=huge"
    # system "make"
    system "make install"
  end
end

# vim: set nowrap tabstop=2 tw=0 sw=2 expandtab
