require 'spec_helper'

require 'rprogram/version'
require 'rprogram/rprogram'

describe RProgram do
  it "should have a VERSION constant" do
    subject.const_defined?('VERSION').should == true
  end

  it "should have a debug mode" do
    subject.debug = true
    subject.debug.should be_true

    subject.debug = false
    subject.debug.should be_false
  end
end
