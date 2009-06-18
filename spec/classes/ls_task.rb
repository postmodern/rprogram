require 'rprogram/task'

class LSTask < RProgram::Task

  short_option :flag => '-a', :name => :all
  long_option :flag => '--author'
  long_option :flag => '--group-directories-first', :name => :group_dirs_first

end
