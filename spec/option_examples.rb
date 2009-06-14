require 'rprogram/option'

require 'spec_helper'

shared_examples_for 'Option' do
  it "should return an empty Array when passed nil" do
    @option.arguments(nil).should == []
  end

  it "should return an empty Array when passed false" do
    @option.arguments(false).should == []
  end

  it "should return a single flag when passed true" do
    @option.arguments(true).should == ['-f']
  end
end
