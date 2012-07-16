require 'spec_helper'

shared_examples_for 'Option' do
  it "should return an empty Array when passed nil" do
    subject.arguments(nil).should == []
  end

  it "should return an empty Array when passed false" do
    subject.arguments(false).should == []
  end

  it "should return a single flag when passed true" do
    subject.arguments(true).should == ['-f']
  end
end
