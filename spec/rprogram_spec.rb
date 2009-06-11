require 'rprogram/version'

require 'spec_helper'

describe RProgram do
  it "should have a VERSION constant" do
    RProgram.const_defined?('VERSION').should == true
  end

  it "should have a debug mode" do
    RProgram.debug = true
    RProgram.debug.should == true

    RProgram.debug = false
    RProgram.debug.should == false
  end
end
