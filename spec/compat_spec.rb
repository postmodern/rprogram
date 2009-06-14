require 'rprogram/compat'

require 'spec_helper'

describe Compat do
  it "should have a list of directories that contain programs" do
    Compat.paths.any? { |dir|
      File.directory?(dir)
    }.should == true
  end

  it "should be able to find programs" do
    File.executable?(Compat.find_program('dir')).should == true
  end

  it "should be able to find programs by multiple names" do
    File.executable?(Compat.find_program_by_names('ls','dir')).should == true
  end
end
