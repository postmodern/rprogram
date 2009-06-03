require 'rprogram/version'

require 'spec_helper'

describe RProgram do
  it "should have a VERSION constant" do
    RProgram.const_defined?('VERSION').should == true
  end
end
