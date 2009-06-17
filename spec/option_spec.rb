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
      value = 'foo'

      @option.arguments('foo').should == ['-f', 'foo']
    end

    it "should render a single flag with multiple values" do
      value = ['foo','bar','baz']

      @option.arguments(value).should == ['-f','foo','bar','baz']
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => false}

      @option.arguments(value).should == ['-f','foo']
    end

    it "should render a single flag with a Hash of keys and values" do
      value = {:foo => 'bar'}

      @option.arguments(value).should == ['-f','foo=bar']
    end
  end

  describe "equals flag" do
    before(:all) do
      @option = Option.new(:equals => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      @option.arguments('foo').should == ['-f=foo']
    end

    it "should render a single flag with multiple values" do
      value = ['foo', 'bar', 'baz']

      @option.arguments(value).should == ['-f=foo bar baz']
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => false}

      @option.arguments(value).should == ['-f=foo']
    end
  end

  describe "multiple flags" do
    before(:all) do
      @option = Option.new(:multiple => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      @option.arguments(value).should == ['-f', 'foo']
    end

    it "should render multiple flags for multiple values" do
      value = ['foo','bar','baz']

      @option.arguments(value).should == ['-f', 'foo', '-f', 'bar', '-f', 'baz']
    end

    it "should render multiple flags for a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = @option.arguments(value)
      
      (args & ['-f', 'foo']).should == ['-f', 'foo']
      (args & ['-f', 'bar']).should == ['-f', 'bar']
    end

    it "should render multiple flags for a Hash of values" do
      value = {:foo => 'bar'}

      @option.arguments(value).should == ['-f', 'foo=bar']
    end
  end

  describe "multiple equals flags" do
    before(:all) do
      @option = Option.new(:multiple => true, :equals => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      @option.arguments(value).should == ['-f=foo']
    end

    it "should render multiple equal flags for multiple values" do
      value = ['foo', 'bar']

      @option.arguments(value).should == ['-f=foo', '-f=bar']
    end

    it "should render multiple equal flags for a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = @option.arguments(value)
      
      args.include?('-f=foo').should == true
      args.include?('-f=bar').should == true
    end

    it "should render multiple equal flags for a Hash of values" do
      value = {:foo => 'bar', :bar => 'baz'}
      args = @option.arguments(value)

      args.include?('-f=foo=bar').should == true
      args.include?('-f=bar=baz').should == true
    end
  end

  describe "separated values" do
    before(:all) do
      @option = Option.new(:separator => ',', :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      @option.arguments('foo').should == ['-f', 'foo']
    end

    it "should render a single flag with multiple values" do
      value = ['foo', 'bar', 'baz']

      @option.arguments(value).should == ['-f', 'foo,bar,baz']
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = @option.arguments(value)
      
      args[0].should == '-f'

      sub_args = args[1].split(',')
      
      sub_args.include?('foo').should == true
      sub_args.include?('bar').should == true
    end

    it "should render a single flag with a Hash of values" do
      value = {:foo => 'bar', :bar => 'baz'}
      args = @option.arguments(value)
      
      args[0].should == '-f'

      sub_args = args[1].split(',')

      sub_args.include?('foo=bar').should == true
      sub_args.include?('bar=baz').should == true
    end
  end
end
