require 'spec_helper'
require 'classes/ls_task'
require 'classes/ls_selinux_task'

require 'rprogram/task'

describe Task do
  describe "flag_namify" do
    subject { described_class }

    it "should downcase all characters" do
      expect(subject.flag_namify('-SHORT-option')).to eq('short_option')
    end

    it "should replace dashes with underscores" do
      expect(subject.flag_namify('-short-option')).to eq('short_option')
    end

    it "should replace dots with underscores" do
      expect(subject.flag_namify('-short.option')).to eq('short_option')
    end

    it "should replace spaces with underscores" do
      expect(subject.flag_namify('-short option')).to eq('short_option')
    end

    it "should replace multiple underscores with one underscore" do
      expect(subject.flag_namify('-short__option')).to eq('short_option')
    end

    it "should namify short options" do
      expect(subject.flag_namify('-short-option')).to eq('short_option')
    end

    it "should namify long options" do
      expect(subject.flag_namify('--long-option')).to eq('long_option')
    end
  end

  subject { LSTask.new }

  it "should have no arguments by default" do
    expect(subject.arguments).to be_empty
  end

  it "should define reader and writter methods for options" do
    expect(subject.all).to be_nil

    subject.all = true
    expect(subject.all).to eq(true)
  end

  it "should default the value of multi-options to an empty Array" do
    expect(subject.hide).to be_empty
  end

  it "should define reader and writter methods for non-options" do
    expect(subject.files).to be_empty

    subject.files << 'file.txt'
    expect(subject.files).to eq(['file.txt'])
  end

  describe "class methods" do
    subject { LSTask }

    it "should provide access to the defined options" do
      expect(subject.options).not_to be_empty
    end

    it "should provide access to the defined non-options" do
      expect(subject.non_options).not_to be_empty
    end

    it "should default the name of long options to the flag" do
      expect(subject.options[:author].flag).to eq('--author')
    end

    it "should allow the name of long options to be overridden" do
      expect(subject.options[:group_dirs_first].flag).to eq('--group-directories-first')
    end

    context "when inherited" do
      subject { LSSELinuxTask }

      it "should allow options to be inherited" do
        expect(subject.has_option?(:all)).to eq(true)
        expect(subject.has_option?(:security_context)).to eq(true)
      end
    end
  end
end
