require 'rprogram/option_list'

require 'spec_helper'

describe OptionList do
  before(:each) do
    @options = OptionList.new
  end

  it "should behave like a Hash" do
    @options[:bla] = 2
    @options[:bla].should == 2
  end

  it "should provide reader and writer methods" do
    @options.bla = 5
    @options.bla.should == 5
  end

  it "should raise a NoMethodError exception when calling other methods" do
    lambda {
      @options.bla(5)
    }.should raise_error(NoMethodError)
  end
end
