require 'rprogram/nameable'

require 'spec_helper'
require 'classes/named_program'
require 'classes/aliased_program'

describe Nameable do
  describe "named program" do
    it "should be able to give a class a program name" do
      NamedProgram.program_name.should == 'ls'
    end

    it "should not have any program aliases" do
      NamedProgram.program_aliases.should be_empty
    end

    it "should have one program name" do
      NamedProgram.program_names.should == ['ls']
    end

    it "should provide an instance method for the program name" do
      obj = NamedProgram.new

      obj.program_name.should == 'ls'
    end

    it "should provide an instance method for the program names" do
      obj = NamedProgram.new

      obj.program_names.should == ['ls']
    end
  end

  describe "aliased program" do
    it "should have program aliases" do
      AliasedProgram.program_aliases.should == ['dir']
    end

    it "should have one program name" do
      AliasedProgram.program_names.should == ['ls', 'dir']
    end

    it "should provide an instance method for the program aliases" do
      obj = AliasedProgram.new

      obj.program_aliases.should == ['dir']
    end

    it "should provide an instance method for the program names" do
      obj = AliasedProgram.new

      obj.program_names.should == ['ls', 'dir']
    end
  end

  describe "path" do
    subject { NamedProgram }
    after(:all) { NamedProgram.path = nil }

    it "should not have a path by default" do
      subject.path.should be_nil
    end

    it "should allow setting the path" do
      new_path = '/usr/bin/ls'

      subject.path = new_path
      subject.path.should == new_path
    end

    it "should expand paths" do
      subject.path = '/usr/../bin/ls'

      subject.path.should == '/bin/ls'
    end

    it "should allow setting the path to nil" do
      subject.path = nil

      subject.path.should be_nil
    end
  end
end
