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
    let(:ls) { subject.find_program('ls') }
    let(:echo) { subject.find_program('echo') }
    let(:cat) { subject.find_program('cat') }
    let(:data) { 'hello' }

    it "should return true when programs succeed" do
      subject.run(ls).should == true
    end

    it "should return false when programs fail" do
      subject.run(ls,'-zzzzzz').should == false
    end

    unless System.ruby_1_8?
      it "should allow passing exec options as the last argument" do
        output = Tempfile.new('rprogram_compat_run')
        subject.run(echo, data, :out => [output.path, 'w'])

        output.read.chomp.should == data
      end
    else
      it "should raise an exception when passing exec options" do
        lambda {
          subject.run(echo, data, :out => ['foo', 'w'])
        }.should raise_error
      end
    end


    unless (System.ruby_1_8? || (System.windows? && !System.jruby?))
      it "should allow running programs with IO.popen" do
        io = subject.run(cat, '-n', :popen => 'w+')

        io.puts(data)
        io.readline.should include(data)
      end
    else
      it "should raise an exception when specifying :popen" do
        lambda {
          subject.run(cat, '-n', :popen => 'w+')
        }.should raise_error
      end
    end
  end
end
