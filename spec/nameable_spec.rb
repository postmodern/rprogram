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
end
