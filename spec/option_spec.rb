require 'spec_helper'
require 'option_examples'

require 'rprogram/option'

describe Option do
  describe "custom formatting" do
    it "should allow the format block to return nil" do
      opt = described_class.new(:flag => '-f') { |opt,value| }

      expect(opt.arguments('bla')).to eq([])
    end
  end

  describe "single flag" do
    subject { described_class.new(:flag => '-f') }

    it_should_behave_like 'Option'

    it "should render a single flag with an optional value" do
      value = 'foo'

      expect(subject.arguments('foo')).to eq(['-f', 'foo'])
    end

    it "should render a single flag with multiple values" do
      value = ['foo','bar','baz']

      expect(subject.arguments(value)).to eq(['-f','foo','bar','baz'])
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => false}

      expect(subject.arguments(value)).to eq(['-f','foo'])
    end

    it "should render a single flag with a Hash of keys and values" do
      value = {:foo => 'bar'}

      expect(subject.arguments(value)).to eq(['-f','foo=bar'])
    end
  end

  describe "equals flag" do
    subject do
      described_class.new(:equals => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      expect(subject.arguments('foo')).to eq(['-f=foo'])
    end

    it "should render a single flag with multiple values" do
      value = ['foo', 'bar', 'baz']

      expect(subject.arguments(value)).to eq(['-f=foo bar baz'])
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => false}

      expect(subject.arguments(value)).to eq(['-f=foo'])
    end
  end

  describe "multiple flags" do
    subject do
      described_class.new(:multiple => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      expect(subject.arguments(value)).to eq(['-f', 'foo'])
    end

    it "should render multiple flags for multiple values" do
      value = ['foo','bar','baz']

      expect(subject.arguments(value)).to eq(['-f', 'foo', '-f', 'bar', '-f', 'baz'])
    end

    it "should render multiple flags for a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = subject.arguments(value)
      
      expect(args & ['-f', 'foo']).to eq(['-f', 'foo'])
      expect(args & ['-f', 'bar']).to eq(['-f', 'bar'])
    end

    it "should render multiple flags for a Hash of values" do
      value = {:foo => 'bar'}

      expect(subject.arguments(value)).to eq(['-f', 'foo=bar'])
    end
  end

  describe "multiple equals flags" do
    subject do
      described_class.new(:multiple => true, :equals => true, :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      expect(subject.arguments(value)).to eq(['-f=foo'])
    end

    it "should render multiple equal flags for multiple values" do
      value = ['foo', 'bar']

      expect(subject.arguments(value)).to eq(['-f=foo', '-f=bar'])
    end

    it "should render multiple equal flags for a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = subject.arguments(value)
      
      expect(args.include?('-f=foo')).to eq(true)
      expect(args.include?('-f=bar')).to eq(true)
    end

    it "should render multiple equal flags for a Hash of values" do
      value = {:foo => 'bar', :bar => 'baz'}
      args = subject.arguments(value)

      expect(args.include?('-f=foo=bar')).to eq(true)
      expect(args.include?('-f=bar=baz')).to eq(true)
    end
  end

  describe "separated values" do
    subject do
      described_class.new(:separator => ',', :flag => '-f')
    end

    it_should_behave_like 'Option'

    it "should render a single flag with a value" do
      value = 'foo'

      expect(subject.arguments('foo')).to eq(['-f', 'foo'])
    end

    it "should render a single flag with multiple values" do
      value = ['foo', 'bar', 'baz']

      expect(subject.arguments(value)).to eq(['-f', 'foo,bar,baz'])
    end

    it "should render a single flag with a Hash of keys" do
      value = {:foo => true, :bar => true, :baz => false}
      args = subject.arguments(value)
      
      expect(args[0]).to eq('-f')

      sub_args = args[1].split(',')
      
      expect(sub_args.include?('foo')).to eq(true)
      expect(sub_args.include?('bar')).to eq(true)
    end

    it "should render a single flag with a Hash of values" do
      value = {:foo => 'bar', :bar => 'baz'}
      args = subject.arguments(value)
      
      expect(args[0]).to eq('-f')

      sub_args = args[1].split(',')

      expect(sub_args.include?('foo=bar')).to eq(true)
      expect(sub_args.include?('bar=baz')).to eq(true)
    end
  end
end
