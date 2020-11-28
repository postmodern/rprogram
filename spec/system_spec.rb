require 'spec_helper'
require 'tempfile'

require 'rprogram/system'

describe System do
  subject { System }

  it "should determine the native architecture" do
    expect(subject.arch).not_to be_empty
  end

  it "should determine the native platform" do
    expect(subject.platform).not_to be_empty
  end

  it "should have a list of directories that contain programs" do
    expect(subject.paths).not_to be_empty

    expect(subject.paths.any? { |dir| dir.directory? }).to eq(true)
  end

  it "should be able to find programs" do
    expect(subject.find_program('ls')).to be_executable
  end

  it "should be able to find programs by multiple names" do
    expect(subject.find_program_by_names('ls','dir')).to be_executable
  end

  describe "run" do
    let(:scripts_dir) { File.join(File.dirname(__FILE__),'scripts') }

    let(:fail_script)    { File.join(scripts_dir,'fail.rb') }
    let(:success_script) { File.join(scripts_dir,'success.rb') }

    let(:print_script) { File.join(scripts_dir,'print.rb') }
    let(:echo_script)  { File.join(scripts_dir,'echo.rb') }

    let(:data) { 'hello' }

    it "should return true when programs succeed" do
      expect(subject.run(success_script)).to eq(true)
    end

    it "should return false when programs fail" do
      expect(subject.run(fail_script)).to eq(false)
    end

    unless System.ruby_1_8?
      it "should allow passing exec options as the last argument" do
        output = Tempfile.new('rprogram_run_with_options')
        subject.run(print_script, data, :out => [output.path, 'w'])

        expect(output.read.chomp).to eq(data)
      end
    else
      it "should raise an exception when passing exec options" do
        expect {
          subject.run(print_script, data, :out => ['foo', 'w'])
        }.to raise_error
      end
    end


    unless (System.ruby_1_8? || (System.windows? && !System.jruby?))
      it "should allow running programs with IO.popen" do
        io = subject.run(echo_script, :popen => 'w+')

        io.puts(data)
        expect(io.readline.chomp).to eq(data)
      end
    else
      it "should raise an exception when specifying :popen" do
        expect {
          subject.run(echo_script, :popen => 'w+')
        }.to raise_error
      end
    end
  end
end
