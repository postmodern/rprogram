require 'rprogram/program'

require 'spec_helper'
require 'classes/ls_program'

describe Program do
  subject { Program.new('/usr/bin/cc') }

  it "should create a Program from a path" do
    subject.should_not be_nil
  end

  it "should derive the program name from a path" do
    subject.name.should == 'cc'
  end

  it "should return the program path when converted to a String" do
    subject.to_s.should == '/usr/bin/cc'
  end

  it "should raise an exception for invalid paths" do
    lambda {
      Program.new('/totally/doesnt/exist')
    }.should raise_error(ProgramNotFound)
  end

  it "should find a program from a path" do
    prog = Program.find_with_path('/usr/bin/cc')

    prog.should_not be_nil
  end

  it "should find a program from given paths" do
    prog = Program.find_with_paths(['/usr/bin/ls','/bin/ls'])

    prog.should_not be_nil
  end

  it "should be able to find a program based on the program names" do
    ls = LS.find

    File.executable?(ls.path).should == true
  end

  it "should raise a ProgramNotFound exception if no path/name is valid" do
    lambda {
      Program.find
    }.should raise_error(ProgramNotFound)
  end
end
