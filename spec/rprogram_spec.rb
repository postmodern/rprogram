require 'spec_helper'

require 'rprogram/version'
require 'rprogram/rprogram'

describe RProgram do
  it "should have a VERSION constant" do
    expect(subject.const_defined?('VERSION')).to eq(true)
  end

  it "should have a debug mode" do
    subject.debug = true
    expect(subject.debug).to be(true)

    subject.debug = false
    expect(subject.debug).to be(false)
  end
end
