require 'rprogram/option'
require 'rprogram/option_list'
require 'rprogram/non_option'

module RProgram
  class Task

    #
    # Creates a new Task object.
    #
    # @param [Hash{Symbol => Object}] options
    #   Additional task options.
    #
    # @yield [task]
    #   If a block is given, it will be passed the newly created task.
    #
    # @yieldparam [Task] task
    #   The newly created Task object.
    #
    # @example
    #   Task.new(:test => 'example', :count => 2, :verbose => true)
    #
    # @example
    #   Task.new(:help => true) do |task|
    #     # ...
    #   end
    #
    def initialize(options={})
      @subtasks = {}
      @options  = options

      yield self if block_given?
    end

    #
    # @return [Hash]
    #   All defined non-options of the class.
    #
    def self.non_options
      @non_options ||= {}
    end

    #
    # Searches for the non-option with the matching name in the class
    # and it's ancestors.
    #
    # @param [Symbol, String] name
    #   The name to search for.
    #
    # @return [true, false]
    #   Specifies whether the non-option with the matching name was
    #   defined.
    #
    def self.has_non_option?(name)
      name = name.to_sym

      ancestors.each do |base|
        if base < RProgram::Task
          return true if base.non_options.include?(name)
        end
      end

      return false
    end

    #
    # Searches for the non-option with the matching name in the class
    # and it's ancestors.
    #
    # @param [Symbol, String] name
    #   The name to search for.
    #
    # @return [NonOption]
    #   The non-option with the matching name.
    #
    def self.get_non_option(name)
      name = name.to_sym

      ancestors.each do |base|
        if base < RProgram::Task
          if base.non_options.has_key?(name)
            return base.non_options[name]
          end
        end
      end

      return nil
    end

    #
    # @return [Hash]
    #   All defined options for the class.
    #
    def self.options
      @options ||= {}
    end

    #
    # Searches for the option with the matching name in the class and
    # it's ancestors.
    #
    # @param [Symbol, String] name
    #   The name to search for.
    #
    # @return [true, false]
    #   Specifies whether the option with the matching name was defined.
    #
    def self.has_option?(name)
      name = name.to_sym

      ancestors.each do |base|
        if base < RProgram::Task
          return true if base.options.has_key?(name)
        end
      end

      return false
    end

    #
    # Searches for the option with the matching name in the class and
    # it's ancestors.
    #
    # @param [Symbol, String] name
    #   The name to search for.
    #
    # @return [Option]
    #   The option with the matching name.
    #
    def self.get_option(name)
      name = name.to_sym

      ancestors.each do |base|
        if base < RProgram::Task
          return base.options[name] if base.options.has_key?(name)
        end
      end

      return nil
    end

    #
    # Creates a new Task object, then formats command-line arguments
    # using the Task object.
    #
    # @param [Hash{Symbol => Object}] options
    #   Additional task options.
    #
    # @yield [task]
    #   If a block is given, it will be passed the newly created task.
    #
    # @yieldparam [Task] task
    #   The newly created Task object.
    #
    # @return [Array]
    #   The formatted arguments from a Task object.
    #
    # @example
    #   MyTask.arguments(:verbose => true, :count => 2)
    #   # => [...]
    #
    # @example
    #   MyTask.arguments do |task|
    #     task.verbose = true
    #     task.file = 'output.txt'
    #   end
    #   # => [...]
    #
    def self.arguments(options={},&block)
      self.new(options,&block).arguments
    end

    #
    # @see has_non_option?
    #
    def has_non_option?(name)
      self.class.has_non_option?(name)
    end

    #
    # @see get_non_option
    #
    def get_non_option(name)
      self.class.get_non_option(name)
    end

    #
    # @see has_option?
    #
    def has_option?(name)
      self.class.has_option?(name)
    end

    #
    # @see get_option
    #
    def get_option(name)
      self.class.get_option(name)
    end

    #
    # Generates the command-line arguments for all leading non-options.
    #
    # @return [Array]
    #   The command-line arguments generated from all the leading
    #   non-options of the task and it's sub-tasks.
    #
    def leading_non_options
      args = []

      # add the task leading non-options
      @options.each do |name,value|
        non_opt = get_non_option(name)

        if (non_opt && non_opt.leading?)
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
    # Generates the command-line arguments from all options.
    #
    # @return [Array]
    #   The command-line arguments generated from all the options of the
    #   task and it's sub-tasks.
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
    # Generates the command-line arguments from all tailing non-options.
    #
    # @return [Array]
    #   The command-line arguments generated from all the tailing
    #   non-options of the task and it's sub-tasks.
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

        if (non_opt && non_opt.tailing?)
          args += non_opt.arguments(value)
        end
      end

      return args
    end

    #
    # Generates the command-line arguments from the task.
    #
    # @return [Array]
    #   The command-line arguments compiled from the leading non-options,
    #   options and tailing non-options of the task and it's sub-tasks.
    #
    def arguments
      tailing_args = tailing_non_options

      if tailing_args.any? { |arg| arg[0,1] == '-' }
        tailing_args.unshift('--')
      end

      return leading_non_options + options + tailing_args
    end

    #
    # @see #arguments
    #
    def to_a
      arguments
    end

    protected

    #
    # Defines a sub-task.
    #
    # @param [String, Symbol] name
    #   The name of the sub-task.
    #
    # @param [Task] task
    #   The task class of the sub-task.
    #
    # @example
    #   subtask :extra, ExtraTask
    #
    def self.subtask(name,task)
      name = name.to_s
      file = __FILE__
      line = __LINE__ + 3

      class_eval %{
        def #{name}(options={},&block)
          if @subtasks[#{name.dump}]
            @subtasks[#{name.dump}].options.merge!(options)

            yield(@subtasks[#{name.dump}]) if block_given?
          else
            @subtasks[#{name.dump}] = #{task}.new(options,&block)
          end

          return @subtasks[#{name.dump}]
        end
      }, file, line
    end

    #
    # Defines a non-option.
    #
    # @param [Hash] options
    #   Additional options for the non-option.
    #
    # @option options [Symbol] :name
    #   The name of the non-option.
    #
    # @option options [true, false] :leading (true)
    #   Implies the non-option is a leading non-option.
    #
    # @option options [false, true] :tailing (false)
    #   Implies the non-option is a tailing non-option.
    #
    # @option options [false, true] :multiple (false)
    #   Implies the non-option maybe given an Array of values.
    #
    # @example
    #   non_option :name => 'input_file', :tailing => true
    #
    # @example
    #   non_option :name => 'file', :tailing => true, :multiple => true
    #
    def self.non_option(options={})
      name = options[:name].to_sym

      self.non_options[name] = NonOption.new(options)

      define_method(name) do
        if options[:multiple]
          @options[name] ||= []
        else
          @options[name]
        end
      end

      define_method("#{name}=") do |value|
        @options[name] = value
      end
    end

    #
    # Defines a long-option.
    #
    # @param [Hash] options
    #   Additional options of the long-option.
    #
    # @option options [String] :flag
    #   The flag to use for the option.
    #
    # @option options [Symbol] :name
    #   The name of the option. Defaults to the flag_namify'ed form of
    #   `options[:flag]`, if not given.
    #
    # @option options [true, false] :multiply (false)
    #   Specifies that the option may appear multiple times in the
    #   arguments.
    #
    # @option options [true, false] :sub_options (false)
    #   Specifies that the option contains multiple sub-options.
    #
    # @example
    #   long_option :flag => '--output'
    #
    # @example
    #   long_option :flag => '-f', :name => :file
    #
    def self.long_option(options={},&block)
      if (options[:name].nil? && options[:flag])
        options[:name] = Task.flag_namify(options[:flag])
      end

      return define_option(options,&block)
    end

    #
    # Defines a short_option.
    #
    # @param [Hash] options
    #   Additional options for the short-option.
    #
    # @option options [Symbol, String] :name
    #   The name of the short-option.
    #
    # @option options [String] :flag
    #   The flag to use for the short-option.
    #
    # @option options [true, false] :multiply (false)
    #   Specifies that the option may appear multiple times in the
    #   arguments.
    #
    # @option options [true, false] :sub_options (false)
    #   Specifies that the option contains multiple sub-options.
    #
    # @example
    #   short_option :flag => '-c', :name => :count
    #
    def self.short_option(options,&block)
      define_option(options,&block)
    end

    #
    # Defines an option.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [Symbol, String] :name
    #   The name of the option.
    #
    # @option options [String] :flag
    #   The flag to use for the option.
    #
    # @option options [true, false] :multiple (false)
    #   Specifies that the option may appear multiple times in the
    #   arguments.
    #
    # @option options [true, false] :sub_options (false)
    #   Specifies that the option contains multiple sub-options.
    #
    def self.define_option(options,&block)
      method_name = options[:name].to_sym

      self.options[method_name] = Option.new(options,&block)

      define_method(method_name) do
        if options[:sub_options]
          @options[method_name] ||= OptionList.new
        elsif options[:multiple]
          @options[method_name] ||= []
        else
          @options[method_name]
        end
      end

      define_method("#{method_name}=") do |value|
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
    # @param [String] flag
    #   The command-line flag to convert.
    #
    # @return [String]
    #   A method-name compatible version of the given flag.
    # 
    # @example
    #   Task.flag_namify('--output-file')
    #   # => "output_file"
    #
    def self.flag_namify(flag)
      flag = flag.to_s.downcase

      # remove leading dashes
      method_name = if    flag.start_with?('--') then flag[2..-1]
                    elsif flag.start_with?('-')  then flag[1..-1]
                    else                              flag
                    end

      # replace remaining dashes with underscores
      return method_name.gsub(/[-_\.\s]+/,'_')
    end

  end
end
