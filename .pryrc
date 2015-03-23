# Pry.config.input = File.open("test.rb")
# Pry.start binding, :input => StringIO.new("ls\nexit")
# Pry.config.color = false
# off pager
Pry.config.pager = false
# Pry.config.auto_indent = false
# Pry.config.correct_indent = false
# Pry.config.command_prefix = "%"

Pry.commands.alias_command 'man', 'show-doc'
Pry.config.prompt = [
  proc {|target_self, nest_level, pry|
    nested = (nest_level.zero?) ? '' : ":#{nest_level}"
    "[#{pry.input_array.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}> "
  },
  proc {|target_self, nest_level, pry|
    nested = (nest_level.zero?) ?  '' : ":#{nest_level}"
    "[#{pry.input_array.size}] #{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}(#{Pry.view_clip(target_self)})#{nested}* "
  }
]
begin
  require 'pry-clipboard'
  # aliases
  Pry.commands.alias_command 'ch', 'copy-history'
  Pry.commands.alias_command 'cr', 'copy-result'
rescue LoadError
  # Missing goodies, bummer
end


begin
  require 'awesome_print'
  require 'tapp'
rescue LoadError
  # Missing goodies, bummer
end

begin
  require 'pry-debugger'
  Pry.commands.alias_command 'c', 'continue'
  Pry.commands.alias_command 's', 'step'
  Pry.commands.alias_command 'n', 'next'
  Pry.commands.alias_command 'f', 'finish'
  Pry.commands.alias_command 'b', 'break'
rescue LoadError
  # Missing goodies, bummer
end

begin
  require 'hirb'
  require 'hirb-unicode'
  Hirb.enable
  Pry.config.print = proc do |output, value, _pry_|
    Hirb::View.view_or_page_output(value) || Pry::DEFAULT_PRINT.call(output, value, _pry_)
  end
rescue LoadError
  # Missing goodies, bummer
end

