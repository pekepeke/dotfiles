# -*- coding: utf-8 -*-

#$:.push(File.join(File.dirname(__FILE__), 'lib'))
#$:.push(File.join(File.dirname(__FILE__)))

require 'rubygems'
require 'rspec'

#require File.expand_path(File.join('.', 'spec_helper'), File.dirname(__FILE__))

require '<%= substitute(expand('%:t:r'), '_spec$', '', 'e') %>'

describe <%= substitute(substitute(expand('%:t:r'), '_spec$', '', 'e'), '^\(.\)\|\(.\)_', '\U\1\U\2', 'eg') %>, "- の場合, " do
  before(:each) do
    @obj = <%= substitute(substitute(expand('%:t:r'), '_spec$', '', 'e'), '^\(.\)\|\(.\)_', '\U\1\U\2', 'eg') %>.new
  end
  after(:each) do
  end

  it "- となる" do
    #@obj.exec.should == 1
    #should be_true, should_not be_true
    #should raise_error(Hoge::Error)
    #$stdout.should_receive(:puts).with("hoge")
  end
end

__END__
