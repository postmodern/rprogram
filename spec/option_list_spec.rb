require 'spec_helper'

require 'rprogram/option_list'

describe OptionList do
  it "should behave like a Hash" do
    subject[:bla] = 2
    expect(subject[:bla]).to eq(2)
  end

  it "should provide reader and writer methods" do
    subject.bla = 5
    expect(subject.bla).to eq(5)
  end

  it "should raise a NoMethodError exception when calling other methods" do
    expect {
      subject.bla(5)
    }.to raise_error(NoMethodError)
  end
end
