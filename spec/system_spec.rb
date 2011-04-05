require 'spec_helper'
require 'tempfile'

require 'rprogram/system'

describe System do
  subject { System }

  it "should determine the native architecture" do
    subject.arch.should_not be_empty
  end

  it "should determine the native platform" do
    subject.platform.should_not be_empty
  end

  it "should have a list of directories that contain programs" do
    subject.paths.should_not be_empty

    subject.paths.any? { |dir| dir.directory? }.should == true
  end

  it "should be able to find programs" do
    subject.find_program('dir').should be_executable
  end

  it "should be able to find programs by multiple names" do
    subject.find_program_by_names('ls','dir').should be_executable
  end

  describe "run" do
    let(:dir) { subject.find_program('dir') }
    let(:cat) { subject.find_program('cat') }

    it "should return true when programs succeed" do
      subject.run(dir).should == true
    end

    it "should return false when programs fail" do
      subject.run(dir,'-zzzzzz').should == false
    end

    unless System.ruby_1_8?
      it "should allow passing spawn options as the last argument" do
        output = Tempfile.new('rprogram_compat_run')

        subject.run(dir, '-l', :out => [output.path, 'w'])

        output.read.should_not be_empty
      end
    else
      it "should raise an exception when passing exec options" do
        lambda {
          subject.run(dir, '-l', :out => ['foo', 'w'])
        }.should raise_error
      end
    end

    unless (System.windows? && !System.jruby?)
      it "should allow running programs with IO.popen" do
        io = subject.run(cat,'-n', :popen => 'w+')
        data = 'hello'

        io.puts(data)
        io.readline.should include(data)
      end
    else
      it "should raise an exception when specifying :popen" do
        lambda {
          subject.run(cat,'-n', :popen => 'w+')
        }.should raise_error
      end
    end
  end
end
