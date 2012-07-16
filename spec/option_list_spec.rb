require 'spec_helper'

require 'rprogram/option_list'

describe OptionList do
  it "should behave like a Hash" do
    subject[:bla] = 2
    subject[:bla].should == 2
  end

  it "should provide reader and writer methods" do
    subject.bla = 5
    subject.bla.should == 5
  end

  it "should raise a NoMethodError exception when calling other methods" do
    lambda {
      subject.bla(5)
    }.should raise_error(NoMethodError)
  end
end
