require 'rprogram/non_option'

require 'spec_helper'

describe NonOption do
  before(:all) do
    @non_option = NonOption.new(:name => 'files')
  end

  it "should keep :leading and :tailing options mutually exclusive" do
    leading = NonOption.new(:name => 'files', :leading => true)
    tailing = NonOption.new(:name => 'files', :tailing => true)

    leading.leading.should == true
    leading.tailing.should == false

    tailing.leading.should == false
    tailing.tailing.should == true
  end

  it "should return an empty Array when passed nil" do
    @non_option.arguments(nil).should == []
  end

  it "should return an empty Array when passed false" do
    @non_option.arguments(false).should == []
  end

  it "should return an empty Array when passed []" do
    @non_option.arguments([]).should == []
  end

  it "should return an Array when passed a single value" do
    @non_option.arguments('foo').should == ['foo']
  end

  it "should return an Array when passed multiple values" do
    @non_option.arguments(['foo', 'bar']).should == ['foo', 'bar']
  end

  it "should return an Array when passed a Hash of keys" do
    @non_option.arguments({:foo => true, :bar => false}).should == ['foo']
  end

  it "should return an Array when passed a Hash of values" do
    @non_option.arguments({:foo => 'bar'}).should == ['foo=bar']
  end
end
