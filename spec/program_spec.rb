require 'spec_helper'
require 'classes/named_program'
require 'classes/aliased_program'
require 'classes/ls_program'

require 'rprogram/program'

describe Program do
  subject { described_class.new('/usr/bin/cc') }

  after(:all) { LS.path = nil }

  describe "named program" do
    subject { NamedProgram }

    it "should be able to give a class a program name" do
      subject.program_name.should == 'ls'
    end

    it "should not have any program aliases" do
      subject.program_aliases.should be_empty
    end

    it "should have one program name" do
      subject.program_names.should == ['ls']
    end

    it "should provide an instance method for the program name" do
      program = subject.find

      program.program_name.should == 'ls'
    end

    it "should provide an instance method for the program names" do
      program = subject.find

      program.program_names.should == ['ls']
    end
  end

  describe "aliased program" do
    subject { AliasedProgram }

    it "should have program aliases" do
      subject.program_aliases.should == ['dir']
    end

    it "should have one program name" do
      subject.program_names.should == ['ls', 'dir']
    end

    it "should provide an instance method for the program aliases" do
      program = subject.find

      program.program_aliases.should == ['dir']
    end

    it "should provide an instance method for the program names" do
      program = subject.find

      program.program_names.should == ['ls', 'dir']
    end
  end

  describe "path" do
    subject { NamedProgram }

    it "should not have a path by default" do
      subject.path.should be_nil
    end

    it "should allow setting the path" do
      new_path = '/bin/ls'

      subject.path = new_path
      subject.path.should == new_path
    end

    it "should expand paths" do
      subject.path = '/../bin/ls'

      subject.path.should == '/bin/ls'
    end

    it "should allow setting the path to nil" do
      subject.path = nil

      subject.path.should be_nil
    end

    after(:all) { NamedProgram.path = nil }
  end

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
      described_class.new('/totally/doesnt/exist')
    }.should raise_error(ProgramNotFound)
  end

  it "should find a program from a path" do
    prog = described_class.find_with_path('/usr/bin/cc')

    prog.should_not be_nil
  end

  it "should find a program from given paths" do
    prog = described_class.find_with_paths(['/usr/bin/ls','/bin/ls'])

    prog.should_not be_nil
  end

  it "should be able to find a program based on the program names" do
    ls = LS.find

    File.executable?(ls.path).should == true
  end

  it "should raise a ProgramNotFound exception if no path/name is valid" do
    lambda {
      described_class.find
    }.should raise_error(ProgramNotFound)
  end

  it "should allow using a default path" do
    LS.path = '/bin/ls'

    LS.find.path.should == LS.path
  end
end
