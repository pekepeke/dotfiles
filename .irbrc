# .irbrc
# coding: utf-8
#$RI = "refe"

if RUBY_VERSION < '1.9'
  $KCODE='u'
  require 'jcode'
end

$RI = "ri"
if `which refe` != ""
  $RI = "refe"
end

require 'pp'              # ついでなんでpp(PrettyPrint)のライブラリをロード
require 'irb/completion'

IRB.conf[:AUTO_INDENT] = true
IRB.conf[:PROMPT][:SIMPLE] = {
  :PROMPT_I => "%03n:>> ",
  :PROMPT_N => "%03n:%i>",
  :PROMPT_S => "%03n:>%l ",
  :PROMPT_C => "%03n:>> ",
  :RETURN => "=> %s\n"
}
IRB.conf[:PROMPT_MODE] = :SIMPLE
IRB.conf[:SAVE_HISTORY] = 100

# --- wirble --- gem install wirble
require 'rubygems'
begin
  require 'wirble'
  Wirble.init
  Wirble.colorize
rescue LoadError=>e
  puts e
end
begin
  require 'what_methods'
rescue LoadError=>e
  puts e
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

# for rails
# Log to STDOUT if in Rails
if ENV.include?('RAILS_ENV') && !Object.const_defined?('RAILS_DEFAULT_LOGGER')
  require 'logger'
  RAILS_DEFAULT_LOGGER = Logger.new(STDOUT)
end

