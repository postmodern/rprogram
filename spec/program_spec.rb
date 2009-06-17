require 'rprogram/program'

require 'spec_helper'

describe Program do
  it "should create a Program from a path" do
    prog = Program.new('/usr/bin/ruby')

    prog.should_not be_nil
  end

  it "should derive the program name from a path" do
    prog = Program.new('/usr/bin/ruby')

    prog.name.should == 'ruby'
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
    prog = Program.find_with_paths('/usr/bin/ls','/bin/ls')

    prog.should_not be_nil
  end
end
