require 'rprogram/rprogram'
require 'rprogram/compat'
require 'rprogram/task'
require 'rprogram/nameable'
require 'rprogram/exceptions/program_not_found'

module RProgram
  class Program

    include Nameable

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
    def initialize(path,&block)
      path = File.expand_path(path)

      unless File.file?(path)
        raise(ProgramNotFound,"program #{path.dump} does not exist",caller)
      end

      @path = path
      @name = File.basename(path)

      block.call(self) if block
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
      return self.new(path,*arguments,&block) if File.file?(path)
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
        return self.new(path,*arguments,&block) if File.file?(path)
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
      path ||= Compat.find_program_by_names(*self.program_names)

      unless path
        names = self.program_names.map { |name| name.dump }.join(', ')

        raise(ProgramNotFound,"programs #{names} were not found",caller)
      end

      return self.new(path,*arguments,&block)
    end

    #
    # Runs the program.
    #
    # @param [Array] arguments
    #   Addition arguments to run the program with.
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
    # @see Compat.run
    #
    def run(*arguments)
      Compat.run(@path,*arguments)
    end

    #
    # Runs the program under sudo.
    #
    # @param [Array] arguments
    #   Additional arguments to run the program with.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @raise [ProgramNotFound]
    #   Indicates that the `sudo` program could not be located.
    #
    # @since 0.1.8
    #
    # @see Compat.sudo
    #
    def sudo(*arguments)
      Compat.sudo(@path,*arguments)
    end

    #
    # Runs the program with the arguments from the given task.
    #
    # @param [Task] task
    #   The task who's arguments will be used to run the program.
    #
    # @return [true, false]
    #   Specifies the exit status of the program.
    #
    # @see #run
    # @see #sudo
    #
    def run_task(task)
      if task.sudo?
        return sudo(*(task.arguments))
      else
        return run(*(task.arguments))
      end
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
