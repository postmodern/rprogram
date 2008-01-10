require 'rprogram/compat'
require 'rprogram/task'
require 'rprogram/exceptions/program_not_found'

module RProgram
  class Program

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
    end

    #
    # Finds the program with the specified _name_ and returns a new
    # Program object. If no programs could be found with the matching _name_,
    # a ProramNotFound exception will be raised.
    #
    #   Program.find_by_name('cat') # => Program
    #
    def self.find_by_name(name)
      path = Compat.find_program(name)
      unless path
        raise(ProgramNotFound,"program '#{name}' could not be found",caller)
      end

      return self.new(path)
    end

    def self.find_by_names(*names)
      path = Compat.find_program_by_names(*names)

      unless path
        names = names.map { |name| name.dump }.join(', ')

        raise(ProgramNotFound,"programs #{names} were not be found",caller)
      end

      return self.new(path)
    end

    #
    # Creates a new Program object with the specified _path_,
    # if _path_ is a valid file.
    #
    #   Program.create_from_path('/bin/cd') # => Program
    #
    #   Program.create_from_path('/obviously/fake') # => nil
    #
    def self.create_from_path(path)
      return self.new(path) if File.file?(path)
    end

    def self.create_from_paths(*paths)
      paths.each do |path|
        return self.new(path) if File.file?(path)
      end
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
