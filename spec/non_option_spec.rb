require 'spec_helper'

require 'rprogram/non_option'

describe NonOption do
  subject { NonOption.new(:name => 'files') }

  it "should keep :leading and :tailing options mutually exclusive" do
    leading = NonOption.new(:name => 'files', :leading => true)
    tailing = NonOption.new(:name => 'files', :tailing => true)

    leading.should be_leading
    leading.should_not be_tailing

    tailing.should_not be_leading
    tailing.should be_tailing
  end

  it "should return an empty Array when passed nil" do
    subject.arguments(nil).should == []
  end

  it "should return an empty Array when passed false" do
    subject.arguments(false).should == []
  end

  it "should return an empty Array when passed []" do
    subject.arguments([]).should == []
  end

  it "should return an Array when passed a single value" do
    subject.arguments('foo').should == ['foo']
  end

  it "should return an Array when passed multiple values" do
    subject.arguments(['foo', 'bar']).should == ['foo', 'bar']
  end

  it "should return an Array when passed a Hash of keys" do
    subject.arguments({:foo => true, :bar => false}).should == ['foo']
  end

  it "should return an Array when passed a Hash of values" do
    subject.arguments({:foo => 'bar'}).should == ['foo=bar']
  end
end
