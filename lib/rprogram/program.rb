require 'rprogram/rprogram'
require 'rprogram/system'
require 'rprogram/task'
require 'rprogram/sudo_task'
require 'rprogram/exceptions/program_not_found'

module RProgram
  class Program

    # Path to the program
    attr_reader :path

    # Name of the program
    attr_reader :name

    #
    # Creates a new Program object.
    #
    # @param [String] path
    #   The full-path of the program.
    #
    # @yield [prog]
    #   If a block is given, it will be passed the newly created Program
    #   object.
    #
    # @yieldparam [Program] prog
    #   The newly created program object.
    #
    # @raise [ProgramNotFound]
    #   Specifies the given path was not a valid file.
    #
    # @example
    #   Program.new('/usr/bin/ls')
    #
    def initialize(path)
      path = File.expand_path(path)

      unless File.file?(path)
        raise(ProgramNotFound,"program #{path.dump} does not exist")
      end

      @path = path
      @name = File.basename(path)

      yield self if block_given?
    end

    #
    # @return [String]
    #   The name of the program.
    #
    def self.program_name
      @program_name ||= nil
    end

    #
    # @return [Array]
    #   The program's aliases.
    #
    def self.program_aliases
      @program_aliases ||= []
    end

    #
    # Combines program_name with program_aliases.
    #
    # @return [Array]
    #   Names the program is known by.
    #
    def self.program_names
      ([program_name] + program_aliases).compact
    end

    #
    # Sets the program name for the class.
    #
    # @param [String, Symbol] name
    #   The new program name.
    #
    # @example
    #   name_program 'ls'
    #
    def self.name_program(name)
      @program_name = name.to_s
    end

    #
    # Sets the program aliases for the class.
    #
    # @param [Array] aliases
    #   The new program aliases.
    #
    # @example
    #   alias_program 'vim', 'vi'
    #
    def self.alias_program(*aliases)
      @program_aliases = aliases.map(&:to_s)
    end

    #
    # The default path of the program.
    #
    # @return [String, nil]
    #   The path to the program.
    #
    # @since 0.2.0
    #
    def self.path
      @program_path
    end

    #
    # Sets the default path to the program.
    #
    # @param [String] new_path
    #   The new path to the program.
    #
    # @return [String, nil]
    #   The path to the program.
    #
    # @since 0.2.0
    #
    def self.path=(new_path)
      @program_path = if new_path
                        File.expand_path(new_path)
                      end
    end

    #
    # Creates a new program object.
    #
    # @param [String] path
    #   The full-path of the program.
    #
    # @param [Array] arguments
    #   Additional arguments to initialize the program with.
    #
    # @yield [prog]
    #   If a block is given, it will be passed the newly created Program
    #   object.
    #
    # @yieldparam [Program] prog
    #   The newly created program object.
    #
    # @return [Program, nil]
    #   Returns the newly created Program object. If the given path was
    #   not a valid file, `nil` will be returned.
    #
    # @example
    #   Program.find_with_path('/bin/cd')
    #   # => Program
    #
    # @example
    #   Program.find_with_path('/obviously/fake')
    #   # => nil
    #
    def self.find_with_path(path,*arguments,&block)
      self.new(path,*arguments,&block) if File.file?(path)
    end

    #
    # Creates a new program object with the specified _paths_,
    # if a path within _paths_ is a valid file. Any given _arguments_ or
    # a given _block_ will be used in creating the new program.
    #
    # @param [Array] paths
    #   The Array of paths to search for the program.
    #
    # @param [Array] arguments
    #   Additional arguments to initialize the program with.
    #
    # @yield [prog]
    #   If a block is given, it will be passed the newly created Program
    #   object.
    #
    # @yieldparam [Program] prog
    #   The newly created program object.
    #
    # @return [Program, nil]
    #   Returns the newly created Program object. If none of the given
    #   paths were valid files, `nil` will be returned.
    #
    # @example
    #   Program.find_with_paths(['/bin/cd','/usr/bin/cd'])
    #   # => Program
    #
    # @example
    #   Program.find_with_paths(['/obviously/fake','/bla'])
    #   # => nil
    #
    def self.find_with_paths(paths,*arguments,&block)
      paths.each do |path|
        if File.file?(path)
          return self.new(path,*arguments,&block)
        end
      end
    end

    #
    # Finds and creates the program using it's `program_names`.
    #
    # @param [Array] arguments
    #   Additional arguments to initialize the program object with.
    #
    # @yield [prog]
    #   If a block is given, it will be passed the newly created Program
    #   object.
    #
    # @yieldparam [Program] prog
    #   The newly created program object.
    #
    # @return [Program]
    #   The newly created program object.
    #
    # @raise [ProgramNotFound]
    #   Non of the `program_names` represented valid programs on the system.
    #
    # @example
    #   Program.find
    #   # => Program
    #
    # @example
    #   MyProgram.find('stuff','here') do |prog|
    #     # ...
    #   end
    #
    def self.find(*arguments,&block)
      path = self.path
      path ||= System.find_program_by_names(*self.program_names)

      unless path
        names = self.program_names.map(&:dump).join(', ')

        raise(ProgramNotFound,"programs #{names} were not found")
      end

      return self.new(path,*arguments,&block)
    end

    #
    # @return [String]
    #   The program name of the class.
    #
    def program_name
      self.class.program_name
    end

    #
    # @return [Array]
    #   The program aliases of the class.
    #
    def program_aliases
      self.class.program_aliases
    end

    #
    # @return [Array]
    #   The program names of the class.
    #
    def program_names
      self.class.program_names
    end

    #
    # Runs the program.
    #
    # @overload run(*arguments)
    #   Run the program with the given arguments.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    # @overload run(*arguments,options)
    #   Run the program with the given arguments and options.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    #   @param [Hash] options
    #     Additional options to execute the program with.
    #
    #   @option options [Hash{String => String}] :env
    #     Environment variables to execute the program with.
    #
    #   @option options [String] :popen
    #     Specifies to run the program using `IO.popen` with the given
    #     IO mode.
    #
    # @return [true, false]
    #   Specifies the exit status of the program.
    #
    # @example
    #   echo = Program.find_by_name('echo')
    #   echo.run('hello')
    #   # hello
    #   # => true
    #
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method
    #   For acceptable options.
    #
    def run(*arguments)
      System.run(@path,*arguments)
    end

    #
    # Runs the program under sudo.
    #
    # @overload sudo(*arguments)
    #   Run the program under `sudo` with the given arguments.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    # @overload sudo(*arguments,options)
    #   Run the program under `sudo` with the given arguments
    #   and options.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    #   @param [Hash] options
    #     Additional options to execute the program with.
    #
    #   @option options [Hash{Symbol => Object}] :sudo
    #     Additional `sudo` options.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @raise [ProgramNotFound]
    #   Indicates that the `sudo` program could not be located.
    #
    # @since 0.1.8
    #
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method
    #   For acceptable options.
    #
    # @see SudoTask
    #   For valid `:sudo` options.
    #
    def sudo(*arguments)
      options = case arguments.last
                when Hash then arguments.pop
                else           {}
                end

      task = SudoTask.new(options.delete(:sudo) || {})
      task.command = [@path] + arguments

      arguments = task.arguments
      arguments << options unless options.empty?

      return System.sudo(*arguments)
    end

    #
    # Runs the program with the arguments from the given task.
    #
    # @param [Task, #to_a] task
    #   The task who's arguments will be used to run the program.
    #
    # @param [Hash] options
    #   Additional options to execute the program with.
    #
    # @return [true, false]
    #   Specifies the exit status of the program.
    #
    # @see #run
    #
    def run_task(task,options={})
      arguments = task.arguments
      arguments << options unless options.empty?

      return run(*arguments)
    end

    #
    # Runs the program under `sudo` with the arguments from the given task.
    #
    # @param [Task, #to_a] task
    #   The task who's arguments will be used to run the program.
    #
    # @param [Hash] options
    #   Spawn options for the program to be ran.
    #
    # @yield [sudo]
    #   If a block is given, it will be passed the sudo task.
    #
    # @yieldparam [SudoTask] sudo
    #   The sudo tasks.
    #
    # @return [true, false]
    #   Specifies the exit status of the program.
    #
    # @see #sudo
    #
    # @since 0.3.0
    #
    def sudo_task(task,options={},&block)
      arguments = task.arguments
      arguments << options unless options.empty?

      return sudo(*arguments,&block)
    end

    #
    # Converts the program to a String.
    #
    # @return [String]
    #   The path of the program.
    #
    # @example
    #   Program.find_by_name('echo').to_s
    #   # => "/usr/bin/echo"
    #
    def to_s
      @path.to_s
    end

  end
end
