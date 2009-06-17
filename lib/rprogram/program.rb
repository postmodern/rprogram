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
    # Creates a new Program object from _path_. If _path_ is not a valid
    # file, a ProgramNotFound exception will be thrown. If a _block_ is
    # given, it will be passed the newly created Program.
    #
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
    # Creates a new program object with the specified _path_, if _path_
    # is a valid file. Any given _args_ or a given _block_ will be used
    # in creating the new program.
    #
    #   Program.find_with_path('/bin/cd') # => Program
    #
    #   Program.find_with_path('/obviously/fake') # => nil
    #
    def self.find_with_path(path,*args,&block)
      return self.new(path,*args,&block) if File.file?(path)
    end

    #
    # Creates a new program object with the specified _paths_,
    # if a path within _paths_ is a valid file. Any given _args_ or
    # a given _block_ will be used in creating the new program.
    #
    #   Program.find_with_paths(['/bin/cd','/usr/bin/cd']) # => Program
    #
    #   Program.find_with_paths(['/obviously/fake','/bla']) # => nil
    #
    def self.find_with_paths(paths,*args,&block)
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
    #   Program.find # => Program
    #
    #   MyProgram.find('stuff','here') do |prog|
    #     ...
    #   end
    #
    def self.find(*args,&block)
      path = Compat.find_program_by_names(*self.program_names)

      unless path
        names = self.program_names.map { |name| name.dump }.join(', ')

        raise(ProgramNotFound,"programs #{names} were not found",caller)
      end

      return self.new(path,*args,&block)
    end

    #
    # Runs the program with the specified _args_ and returns
    # either +true+ or +false+, depending on the exit status of the
    # program.
    #
    #   echo = Program.find_by_name('echo')
    #   echo.run('hello')
    #   # hello
    #   # => true
    #
    def run(*args)
      args = args.map { |arg| arg.to_s }

      if RProgram.debug
        STDERR.puts ">>> #{@path} #{args.join(' ')}"
      end

      return Kernel.system(@path,*args)
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
    #   Program.find_by_name('echo').to_s
    #   # => "/usr/bin/echo"
    #
    def to_s
      @path.to_s
    end

  end
end
