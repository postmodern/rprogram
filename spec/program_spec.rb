require 'rprogram/program'

require 'spec_helper'
require 'classes/ls_program'

describe Program do
  it "should create a Program from a path" do
    prog = Program.new('/usr/bin/ruby')

    prog.should_not be_nil
  end

  it "should derive the program name from a path" do
    prog = Program.new('/usr/bin/ruby')

    prog.name.should == 'ruby'
  end

  it "should return the program path when converted to a String" do
    prog = Program.new('/usr/bin/ruby')

    prog.to_s.should == '/usr/bin/ruby'
  end

  it "should raise an exception for invalid paths" do
    lambda {
      Program.new('/totally/doesnt/exist')
    }.should raise_error(ProgramNotFound)
  end

  it "should find a program from a path" do
    prog = Program.find_with_path('/usr/bin/dir')

    prog.should_not be_nil
  end

  it "should find a program from given paths" do
    prog = Program.find_with_paths(['/usr/bin/ls','/bin/ls'])

    prog.should_not be_nil
  end

  it "should be able to find a program based on the program names" do
    ls = nil

    lambda {
      ls = LS.find
    }.should_not raise_error(ProgramNotFound)

    File.executable?(ls.path).should == true
  end
end
