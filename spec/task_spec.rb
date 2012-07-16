require 'spec_helper'
require 'classes/ls_task'
require 'classes/ls_selinux_task'

require 'rprogram/task'

describe Task do
  describe "flag_namify" do
    subject { described_class }

    it "should downcase all characters" do
      subject.flag_namify('-SHORT-option').should == 'short_option'
    end

    it "should replace dashes with underscores" do
      subject.flag_namify('-short-option').should == 'short_option'
    end

    it "should replace dots with underscores" do
      subject.flag_namify('-short.option').should == 'short_option'
    end

    it "should replace spaces with underscores" do
      subject.flag_namify('-short option').should == 'short_option'
    end

    it "should replace multiple underscores with one underscore" do
      subject.flag_namify('-short__option').should == 'short_option'
    end

    it "should namify short options" do
      subject.flag_namify('-short-option').should == 'short_option'
    end

    it "should namify long options" do
      subject.flag_namify('--long-option').should == 'long_option'
    end
  end

  subject { LSTask.new }

  it "should have no arguments by default" do
    subject.arguments.should be_empty
  end

  it "should define reader and writter methods for options" do
    subject.all.should be_nil

    subject.all = true
    subject.all.should == true
  end

  it "should default the value of multi-options to an empty Array" do
    subject.hide.should be_empty
  end

  it "should define reader and writter methods for non-options" do
    subject.files.should be_empty

    subject.files << 'file.txt'
    subject.files.should == ['file.txt']
  end

  describe "class methods" do
    subject { LSTask }

    it "should provide access to the defined options" do
      subject.options.should_not be_empty
    end

    it "should provide access to the defined non-options" do
      subject.non_options.should_not be_empty
    end

    it "should default the name of long options to the flag" do
      subject.options[:author].flag.should == '--author'
    end

    it "should allow the name of long options to be overridden" do
      subject.options[:group_dirs_first].flag.should == '--group-directories-first'
    end

    context "when inherited" do
      subject { LSSELinuxTask }

      it "should allow options to be inherited" do
        subject.has_option?(:all).should == true
        subject.has_option?(:security_context).should == true
      end
    end
  end
end
