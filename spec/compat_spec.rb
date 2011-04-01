require 'rprogram/compat'

require 'spec_helper'
require 'tempfile'

describe Compat do
  it "should have a list of directories that contain programs" do
    Compat.paths.should_not be_empty

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

  describe "run" do
    subject { Compat }
    let(:dir) { Compat.find_program('dir') }

    it "should return true when programs succeed" do
      subject.run(dir).should == true
    end

    it "should return false when programs fail" do
      subject.run(dir,'-zzzzzz').should == false
    end

    it "should allow passing spawn options as the last argument" do
      output = Tempfile.new('rprogram_compat_run')

      subject.run(dir,'-l',:out => [output.path, 'w'])

      output.read.should_not be_empty
    end
  end
end
