# .irbrc
# coding: utf-8

load File.dirname(__FILE__) + '/.rubyrc'
require 'rubygems' unless defined? Gem
begin
    require 'irbtools'
rescue LoadError
end
require 'irb/completion'

IRB.conf.merge!({
  :USE_READLINE => true,
  :AUTO_INDENT => true,
  :SAVE_HISTORY => 1000,
  :PROMPT_MODE => :SIMPLE,# :VERBOSE
})
IRB.conf[:PROMPT][:SIMPLE] = {
  :PROMPT_I => "%03n:>> ",
  :PROMPT_N => "%03n:%i>",
  :PROMPT_S => "%03n:>%l ",
  :PROMPT_C => "%03n:>> ",
  :RETURN => "=> %s\n"
}

$RI = "ri"
if `which rurema` != ""
  $RI = "rurema"
elsif `which refe` != ""
  $RI = "refe"
end
# Class.r :method でrefe - http://d.hatena.ne.jp/secondlife/20051114/1131894899
# gem install refeしてから有効
module Kernel
  def r(arg)
    puts `#{$RI} #{arg}`
  end
  private :r
end

class Module
  def r(meth = nil)
    if meth
      if instance_methods(false).include? meth.to_s
        puts `#{$RI} #{self}##{meth}`
      else
        super
      end
    else
      puts `#{$RI} #{self}`
    end
  end
end

