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
    # Creates a new Program object from _path_. If _block_ is given, it will
    # be passed the newly created Program.
    #
    #   Program.new('/usr/bin/ls')
    #
    def initialize(path,&block)
      @path = File.expand_path(path)
      @name = File.basename(@path)

      block.call(self) if block
    end

    #
    # Creates a new program object with the specified _path_, if _path_
    # is a valid file. Any given _args_ or a given _block_ will be used
    # in creating the new program.
    #
    #   Program.create_from_path('/bin/cd') # => Program
    #
    #   Program.create_from_path('/obviously/fake') # => nil
    #
    def self.create_from_path(path,*args,&block)
      return self.new(path,*args,&block) if File.file?(path)
    end

    #
    # Creates a new program object with the specified _paths_,
    # if a path within _paths_ is a valid file. Any given _args_ or
    # a given _block_ will be used in creating the new program.
    #
    #   Program.create_from_paths(['/bin/cd','/usr/bin/cd']) # => Program
    #
    #   Program.create_from_paths(['/obviously/fake','/bla']) # => nil
    #
    def self.create_from_paths(paths,*args,&block)
      paths.each do |path|
        return self.new(path,*args,&block) if File.file?(path)
      end
    end

    #
    # Finds and creates the program using it's +program_names+ and returns
    # a new Program object. If the program cannot be found by any of it's
    # +program_names+, a ProramNotFound exception will be raised. Any given
    # _args_ or a given _block_ will be used in creating the new program.
    #
    #   Program.create # => Program
    #
    #   MyProgram.create('stuff','here') do |prog|
    #     ...
    #   end
    #
    def self.create(*args,&block)
      path = Compat.find_program_by_names(program_names)
      unless path
        names = program_names.map { |name| name.dump }.join(', ')

        raise(ProgramNotFound,"programs #{names} were not found",caller)
      end

      return self.new(path,*args,&block)
    end

    #
    # Runs the program with the specified _args_ and returns
    # an Array of the programs output.
    #
    #   echo = Program.find_by_name('echo')
    #   echo.run("hello") # => ["hello\n"]
    #
    def run(*args)
      command = [@path] + args

      IO.popen(command.join(' ')) do |process|
        return process.readlines
      end
    end

    #
    # Runs the program with the specified _task_ object.
    #
    def run_task(task)
      run(*(task.arguments))
    end

    #
    # Returns the path of the program.
    #
    #   puts Program.find_by_name('echo')
    #   /usr/bin/echo
    #   # => nil
    #
    def to_s
      @path.to_s
    end

  end
end
