require 'rprogram/option'

require 'spec_helper'
require 'option_examples'

describe Option do
  describe "single flag" do
    before(:all) do
      @option = Option.new(:flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with an optional value" do
      @option.arguments('foo').should == ['-f', 'foo']
    end

    it "should render a single flag with multiple values" do
      @option.arguments(['foo','bar','baz']).should == ['-f','foo','bar','baz']
    end

    it "should render a single flag with a Hash of keys" do
      @option.arguments({:foo => true, :bar => false}).should == ['-f','foo']
    end

    it "should render a single flag with a Hash of keys and values" do
      @option.arguments({:foo => 'bar'}).should == ['-f','foo=bar']
    end
  end

  describe "equals flag" do
    before(:all) do
      @option = Option.new(:equals => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      @option.arguments('foo').should == ['-f=foo']
    end

    it "should render a single flag with multiple values" do
      @option.arguments(['foo', 'bar', 'baz']).should == ['-f', 'foo', 'bar', 'baz']
    end

    it "should render a single flag with a Hash of keys" do
      @option.arguments({:foo => true, :bar => false}).should == ['-f=foo']
    end
  end

  describe "multiple flags" do
    before(:all) do
      @option = Option.new(:multiple => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      @option.arguments('foo').should == ['-f', 'foo']
    end

    it "should render multiple flags for multiple values" do
      @option.arguments(['foo','bar','baz']).should == ['-f', 'foo', '-f', 'bar', '-f', 'baz']
    end

    it "should render multiple flags for a Hash of keys" do
      @option.arguments({:foo => true, :bar => true, :baz => false}).should == ['-f', 'foo', '-f', 'bar']
    end

    it "should render multiple flags for a Hash of values" do
      @option.arguments({:foo => 'bar'}).should == ['-f', 'foo=bar']
    end
  end

  describe "separated values" do
    before(:all) do
      @option = Option.new(:seprator => ',', :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      @option.arguments('foo').should == ['-f', 'foo']
    end

    it "should render a single flag with multiple values" do
      @option.arguments(['foo', 'bar', 'baz']).should == ['-f', 'foo,bar,baz']
    end

    it "should render a single flag with a Hash of keys" do
      @option.arguments({:foo => true, :bar => true, :baz => false}).should == ['-f', 'foo,bar']
    end

    it "should render a single flag with a Hash of values" do
      @option.arguments({:foo => 'bar', :bar => 'baz'}).should == ['-f', 'foo=bar,bar=baz']
    end
  end
end
