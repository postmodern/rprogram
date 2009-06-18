require 'rprogram/task'

require 'spec_helper'

describe Task do
  describe "flag_namify" do
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
end
