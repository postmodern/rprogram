require 'rprogram/exceptions/program_not_found'

module RProgram
  module Compat
    #
    # Determines the native platform.
    #
    # @return [String]
    #   The native platform.
    #
    # @example
    #   Compat.arch  #=> "linux"
    #
    def Compat.platform
      RUBY_PLATFORM.split('-').last
    end

    #
    # Determines the contents of the +PATH+ environment variable.
    #
    # @return [Array]
    #   The contents of the +PATH+ environment variable.
    #
    # @example
    #   Compat.paths #=> ["/bin", "/usr/bin"]
    #
    def Compat.paths
      # return an empty array in case
      # the PATH variable does not exist
      return [] unless ENV['PATH']

      if Compat.platform =~ /mswin(32|64)/
        return ENV['PATH'].split(';')
      else
        return ENV['PATH'].split(':')
      end
    end

    #
    # Finds the full-path of the program with the matching name.
    #
    # @param [String] name
    #   The name of the program to find.
    #
    # @return [String, nil]
    #   The full-path of the desired program.
    #
    # @example
    #   Compat.find_program('as')  #=> "/usr/bin/as"
    #
    def Compat.find_program(name)
      Compat.paths.each do |dir|
        full_path = File.expand_path(File.join(dir,name))

        return full_path if File.file?(full_path)
      end

      return nil
    end

    #
    # Finds the program matching one of the matching names.
    #
    # @param [Array] names
    #   The names of the program to use while searching for the program.
    #
    # @return [String, nil]
    #   The first full-path for the program.
    #
    # @example
    #   Compat.find_program_by_names("gas","as")  #=> "/usr/bin/as"
    #
    def Compat.find_program_by_names(*names)
      names.map { |name| Compat.find_program(name) }.compact.first
    end

    #
    # Runs a program.
    #
    # @param [String] path
    #   The path to the program.
    #
    # @param [Array] args
    #   Additional arguments to run the program with.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    def Compat.run(path,*args)
      args = args.map { |arg| arg.to_s }

      if RProgram.debug
        STDERR.puts ">>> #{path} #{args.join(' ')}"
      end

      return Kernel.system(path,*args)
    end

    #
    # Runs a program under sudo.
    #
    # @param [String] path
    #   Path of the program to run.
    #
    # @param [Array] args
    #   Additional arguments to run the program with.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    def Compat.sudo(path,*args)
      sudo_path = Compat.find_program('sudo')

      unless sudo_path
        raise(ProgramNotFound,'could not find the "sudo" program',caller)
      end

      return Compat.run(sudo_path,path,*args)
    end
  end
end
