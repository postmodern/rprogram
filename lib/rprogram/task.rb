require 'rprogram/options'
require 'rprogram/option_list'

module RProgram
  class Task

    include Options

    #
    # Creates a new Task object with the given _options_. If a block is
    # given, it is passed the newly created Task object.
    #
    #   Task.new(:test => 'example', :count => 2, :verbose => true)
    #
    #   Task.new(:help => true) do |task|
    #     ...
    #   end
    #
    def initialize(options={},&block)
      @subtasks = {}
      @options = options

      block.call(self) if block
    end

    #
    # Returns the compiled _arguments_ from a Task object created
    # with the given _options_ and _block_.
    #
    #   MyTask.arguments(:verbose => true, :count => 2)
    #
    #   MyTask.arguments do |task|
    #     task.verbose = true
    #     task.file = 'output.txt'
    #   end
    #
    def self.arguments(options={},&block)
      self.new(options,&block).arguments
    end

    #
    # Returns an array of _arguments_ generated from all the leading
    # non-options of the task and it's sub-tasks.
    #
    def leading_non_options
      args = []

      # add the task leading non-options
      @options.each do |name,value|
        non_opt = get_non_option(name)

        if (non_opt && non_opt.leading)
          args += non_opt.arguments(value)
        end
      end

      # add all leading subtask non-options
      @subtasks.each_value do |task|
        args += task.leading_non_options
      end

      return args
    end

    #
    # Returns an array of _arguments_ generated from all the options
    # of the task and it's sub-tasks.
    #
    def options
      args = []

      # add all subtask options
      @subtasks.each_value do |task|
        args += task.arguments
      end

      # add the task options
      @options.each do |name,value|
        opt = get_option(name)
        args += opt.arguments(value) if opt
      end

      return args
    end

    #
    # Returns an array of _arguments_ generated from all the tailing
    # non-options of the task and it's sub-tasks.
    #
    def tailing_non_options
      args = []

      # add all tailing subtask non-options
      @subtasks.each_value do |task|
        args += task.tailing_non_options
      end

      # add the task tailing non-options
      @options.each do |name,value|
        non_opt = get_non_option(name)

        if (non_opt && non_opt.tailing)
          args += non_opt.arguments(value)
        end
      end

      return args
    end

    #
    # Returns an array of _arguments_ compiled from the _arguments_ of
    # the tasks leading non_options, options and tailing non-options.
    #
    def arguments
      leading_non_options + options + tailing_non_options
    end

    protected

    #
    # Defines a sub-task of _name_ and class of _task_.
    #
    #   subtask :extra, ExtraTask
    #
    def self.subtask(name,task)
      name = name.to_s

      class_eval %{
        def #{name}(options={},&block)
          if @subtasks[#{name.dump}]
            @subtasks[#{name.dump}].options.merge!(options)

            block.call(@subtasks[#{name.dump}]) if block
          else
            @subtasks[#{name.dump}] = #{task}.new(options,&block)
          end

          return @subtasks[#{name.dump}]
        end
      }
    end

    #
    # Defines a non-option with the given _options_.
    #
    #   non_option :name => 'input_file', :tailing => true
    #
    #   non_option :name => 'file', :tailing => true, :multiple => true
    #
    def self.non_option(options={})
      name = options[:name].to_sym

      self.non_options[name] = NonOption.new(options)

      class_def(name) do
        if options[:multiple]
          @options[name] ||= []
        else
          @options[name]
        end
      end

      class_def("#{name}=") do |value|
        @options[name] = value
      end
    end

    #
    # Defines a long-option with the specified _options_.
    #
    # _options_ must contain the following keys:
    # <tt>:flag</tt>:: The flag to use for the option.
    #
    # _options_ may also contain the following keys:
    # <tt>:name</tt>:: The name of the option. Defaults to the
    #                  flag_namify'ed form of <tt>options[:flag]</tt>,
    #                  if not given.
    # <tt>:multiply</tt>:: Specifies that the option may appear multiple
    #                      times in the arguments.
    # <tt>:sub_options</tt>:: Specifies that the option contains multiple
    #                  sub-options.
    #
    #   long_option :flag => '--output'
    #
    #   long_option :flag => '-f', :name => :file
    #
    def self.long_option(options={},&block)
      if (options[:name].nil? && options[:flag])
        options[:name] = Task.flag_namify(options[:flag])
      end

      return define_option(options,&block)
    end

    #
    # Defines a short_option with the specified _options_.
    #
    # _options_ must contain the following keys:
    # <tt>:name</tt>:: The name of the option.
    # <tt>:flag</tt>:: The flag to use for the option.
    #
    # _options_ may also contain the following keys:
    # <tt>:multiply</tt>:: Specifies that the option may appear multiple
    #                      times in the arguments.
    # <tt>:sub_options</tt>:: Specifies that the option contains multiple
    #                  sub-options.
    #
    #   short_option :flag => '-c', :name => :count
    #
    def self.short_option(options,&block)
      define_option(options,&block)
    end

    #
    # Defines an option with the specified _options_ and the given _block_.
    #
    # _options_ must contain the following keys:
    # <tt>:name</tt>:: The name of the option.
    # <tt>:flag</tt>:: The flag to use for the option.
    #
    # _options_ may also contain the following keys:
    # <tt>:multiply</tt>:: Specifies that the option may appear multiple
    #                      times in the arguments.
    # <tt>:sub_options</tt>:: Specifies that the option contains multiple
    #                  sub-options.
    #
    def self.define_option(options,&block)
      method_name = options[:name].to_sym

      self.options[method_name] = Option.new(options,&block)

      class_def(method_name) do
        if options[:sub_options]
          @options[method_name] ||= OptionList.new
        elsif options[:multiple]
          @options[method_name] ||= []
        else
          @options[method_name]
        end
      end

      class_def("#{method_name}=") do |value|
        if options[:sub_options]
          @options[method_name] = OptionList.new(value)
        else
          @options[method_name] = value
        end
      end
    end

    #
    # Converts a long-option flag to a Ruby method name.
    # 
    #   Task.flag_namify('--output-file')  # => "output_file"
    #
    def Task.flag_namify(flag)
      flag = flag.to_s

      # remove leading dashes
      if flag[0..1] == '--'
        method_name = flag[2..-1]
      elsif flag[0..0] == '-'
        method_name = flag[1..-1]
      else
        method_name = flag
      end

      # replace remaining dashes with underscores
      return method_name.gsub(/[-_.\s]+/,'_')
    end

  end
end
