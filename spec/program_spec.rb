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
      expect(subject.program_name).to eq('ls')
    end

    it "should not have any program aliases" do
      expect(subject.program_aliases).to be_empty
    end

    it "should have one program name" do
      expect(subject.program_names).to eq(['ls'])
    end

    it "should provide an instance method for the program name" do
      program = subject.find

      expect(program.program_name).to eq('ls')
    end

    it "should provide an instance method for the program names" do
      program = subject.find

      expect(program.program_names).to eq(['ls'])
    end
  end

  describe "aliased program" do
    subject { AliasedProgram }

    it "should have program aliases" do
      expect(subject.program_aliases).to eq(['dir'])
    end

    it "should have one program name" do
      expect(subject.program_names).to eq(['ls', 'dir'])
    end

    it "should provide an instance method for the program aliases" do
      program = subject.find

      expect(program.program_aliases).to eq(['dir'])
    end

    it "should provide an instance method for the program names" do
      program = subject.find

      expect(program.program_names).to eq(['ls', 'dir'])
    end
  end

  describe "path" do
    subject { NamedProgram }

    it "should not have a path by default" do
      expect(subject.path).to be_nil
    end

    it "should allow setting the path" do
      new_path = '/bin/ls'

      subject.path = new_path
      expect(subject.path).to eq(new_path)
    end

    it "should expand paths" do
      subject.path = '/../bin/ls'

      expect(subject.path).to eq('/bin/ls')
    end

    it "should allow setting the path to nil" do
      subject.path = nil

      expect(subject.path).to be_nil
    end

    after(:all) { NamedProgram.path = nil }
  end

  it "should create a Program from a path" do
    expect(subject).not_to be_nil
  end

  it "should derive the program name from a path" do
    expect(subject.name).to eq('cc')
  end

  it "should return the program path when converted to a String" do
    expect(subject.to_s).to eq('/usr/bin/cc')
  end

  it "should raise an exception for invalid paths" do
    expect {
      described_class.new('/totally/doesnt/exist')
    }.to raise_error(ProgramNotFound)
  end

  it "should find a program from a path" do
    prog = described_class.find_with_path('/usr/bin/cc')

    expect(prog).not_to be_nil
  end

  it "should find a program from given paths" do
    prog = described_class.find_with_paths(['/usr/bin/ls','/bin/ls'])

    expect(prog).not_to be_nil
  end

  it "should be able to find a program based on the program names" do
    ls = LS.find

    expect(File.executable?(ls.path)).to eq(true)
  end

  it "should raise a ProgramNotFound exception if no path/name is valid" do
    expect {
      described_class.find
    }.to raise_error(ProgramNotFound)
  end

  it "should allow using a default path" do
    LS.path = '/bin/ls'

    expect(LS.find.path).to eq(LS.path)
  end
end
