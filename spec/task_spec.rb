require 'rprogram/task'

require 'spec_helper'
require 'classes/ls_task'
require 'classes/ls_selinux_task'

describe Task do
  describe "flag_namify" do
    it "should downcase all characters" do
      Task.flag_namify('-SHORT-option').should == 'short_option'
    end

    it "should replace dashes with underscores" do
      Task.flag_namify('-short-option').should == 'short_option'
    end

    it "should replace dots with underscores" do
      Task.flag_namify('-short.option').should == 'short_option'
    end

    it "should replace spaces with underscores" do
      Task.flag_namify('-short option').should == 'short_option'
    end

    it "should replace multiple underscores with one underscore" do
      Task.flag_namify('-short__option').should == 'short_option'
    end

    it "should namify short options" do
      Task.flag_namify('-short-option').should == 'short_option'
    end

    it "should namify long options" do
      Task.flag_namify('--long-option').should == 'long_option'
    end
  end

  before(:each) do
    @task = LSTask.new
  end

  it "should have no arguments by default" do
    @task.arguments.should be_empty
  end

  it "should define reader and writter methods for options" do
    @task.all.should be_nil

    @task.all = true
    @task.all.should == true
  end

  it "should define reader and writter methods for non-options" do
    @task.files.should be_empty

    @task.files << 'file.txt'
    @task.files.should == ['file.txt']
  end

  it "should provide access to the defined options" do
    LSTask.options.should_not be_empty
  end

  it "should provide access to the defined non-options" do
    LSTask.non_options.should_not be_empty
  end

  it "should default the name of long options to the flag" do
    LSTask.options[:author].flag.should == '--author'
  end

  it "should allow the name of long options to be overridden" do
    LSTask.options[:group_dirs_first].flag.should == '--group-directories-first'
  end

  it "should allow options to be inherited" do
    LSTask.has_option?(:security_context).should == false
    LSSELinuxTask.has_option?(:all).should == true
    LSSELinuxTask.has_option?(:security_context).should == true
  end
end
