require 'rprogram/options'

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
    def Object.subtask(name,task)
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
    # Defines a non-option with the given _opts_.
    #
    #   non_option :name => 'input_file', :tailing => true
    #
    #   non_option :name => 'file', :tailing => true, :multiple => true
    #
    def Object.non_option(opts={})
      name = opts[:name].to_sym

      self.non_options[name] = NonOption.new(opts)

      class_def(name) do
        if opts[:multiple]
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
    # Defines a long-option with the given _opts_.
    #
    #   long_option :flag => '--output'
    #
    #   long_option :flag => '-f', :name => :file
    #
    def Object.long_option(opts={},&block)
      flag = opts[:flag].to_s
      method_name = (opts[:name] || Task.flag_namify(flag)).to_sym

      self.options[method_name] = Option.new(opts,&block)

      class_def(method_name) do
        if opts[:multiple]
          @options[method_name] ||= []
        else
          @options[method_name]
        end
      end

      class_def("#{method_name}=") do |value|
        @options[method_name] = value
      end
    end

    #
    # Defines a short_option with the given _opts_.
    #
    #   short_option :flag => '-c', :name => :count
    #
    def Object.short_option(opts={},&block)
      method_name = opts[:name].to_sym

      self.options[method_name] = Option.new(opts,&block)

      class_def(method_name) do
        if opts[:multiple]
          @options[method_name] ||= []
        else
          @options[method_name]
        end
      end

      class_def("#{method_name}=") do |value|
        @options[method_name] = value
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
      if flag =~ /^--/
        method_name = flag[2..-1]
      elsif flag =~ /^-/
        method_name = flag[1..-1]
      else
        method_name = flag
      end

      # replace remaining dashes with underscores
      return method_name.gsub(/[-.]/,'_')
    end

  end
end
