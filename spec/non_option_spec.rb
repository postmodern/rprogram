require 'spec_helper'

require 'rprogram/non_option'

describe NonOption do
  subject { NonOption.new(:name => 'files') }

  it "should keep :leading and :tailing options mutually exclusive" do
    leading = NonOption.new(:name => 'files', :leading => true)
    tailing = NonOption.new(:name => 'files', :tailing => true)

    expect(leading).to be_leading
    expect(leading).not_to be_tailing

    expect(tailing).not_to be_leading
    expect(tailing).to be_tailing
  end

  it "should return an empty Array when passed nil" do
    expect(subject.arguments(nil)).to eq([])
  end

  it "should return an empty Array when passed false" do
    expect(subject.arguments(false)).to eq([])
  end

  it "should return an empty Array when passed []" do
    expect(subject.arguments([])).to eq([])
  end

  it "should return an Array when passed a single value" do
    expect(subject.arguments('foo')).to eq(['foo'])
  end

  it "should return an Array when passed multiple values" do
    expect(subject.arguments(['foo', 'bar'])).to eq(['foo', 'bar'])
  end

  it "should return an Array when passed a Hash of keys" do
    expect(subject.arguments({:foo => true, :bar => false})).to eq(['foo'])
  end

  it "should return an Array when passed a Hash of values" do
    expect(subject.arguments({:foo => 'bar'})).to eq(['foo=bar'])
  end
end
