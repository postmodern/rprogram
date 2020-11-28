require 'spec_helper'

shared_examples_for 'Option' do
  it "should return an empty Array when passed nil" do
    expect(subject.arguments(nil)).to eq([])
  end

  it "should return an empty Array when passed false" do
    expect(subject.arguments(false)).to eq([])
  end

  it "should return a single flag when passed true" do
    expect(subject.arguments(true)).to eq(['-f'])
  end
end
