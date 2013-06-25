#!/usr/bin/env ruby
# generate vim dictionary with docsetutil and ADC Reference

devel_path = `xcode-select -print-path`.chomp
docsetutil = File.join(devel_path, 'usr/bin/docsetutil')
docsetpath = File.join(devel_path, 'Documentation/DocSets/com.apple.ADC_Reference_Library.CoreReference.docset')

cmd = [docsetutil, 'dump', '-node', 'Cocoa', docsetpath].join(' ')

str = `#{cmd}`
str.slice!(/\A.*^API index contains \d+ tokens$/m)
syms = Hash.new([])
str.each_line do |line|
  lang, kind, klass, sym = line.chomp('').split('/')
  if lang == 'Objective-C'
    info = 
      case kind
      when 'instm'
        "-#{klass}"
      when 'clm'
        "+#{klass}"
      when 'cl'
        'Class'
      when 'intfm'
        if klass == '-'
	  'Protocol'
	else
	  "<#{klass}>"
	end
      when 'cat'
        next
      else
        nil
      end
  else
    info = nil
  end
  syms[sym] += [info]
end

syms.each do |sym, info|
  puts sym
#  info.compact!
#  info.uniq!
#  if info.size > 0
#    puts "#{sym}(#{info.join(',')})"
#  else
#    puts sym
#  end
end

