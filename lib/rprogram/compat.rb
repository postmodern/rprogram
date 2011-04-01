require 'rprogram/exceptions/program_not_found'
require 'rprogram/rprogram'

require 'env/variables'

module RProgram
  module Compat
    extend Env::Variables

    #
    # Determines the native platform.
    #
    # @return [String]
    #   The native platform.
    #
    # @example
    #   Compat.arch  #=> "linux"
    #
    # @deprecated Will be removed in 0.3.0.
    #
    def Compat.platform
      RUBY_PLATFORM.split('-').last
    end

    #
    # Finds the full-path of the program with the matching name.
    #
    # @param [String] name
    #   The name of the program to find.
    #
    # @return [Pathname, nil]
    #   The full-path of the desired program.
    #
    # @example
    #   Compat.find_program('as')
    #   #=> #<Pathname:/usr/bin/as>
    #
    def Compat.find_program(name)
      # add the `.exe` suffix to the name, if running on Windows
      if platform =~ /mswin/
        name = "#{name}.exe"
      end

      paths.each do |dir|
        full_path = dir.join(name).expand_path

        return full_path if full_path.file?
      end

      return nil
    end

    #
    # Finds the program matching one of the matching names.
    #
    # @param [Array] names
    #   The names of the program to use while searching for the program.
    #
    # @return [Pathname, nil]
    #   The first full-path for the program.
    #
    # @example
    #   Compat.find_program_by_names("gas","as")  #=> "/usr/bin/as"
    #
    def Compat.find_program_by_names(*names)
      names.each do |name|
        if (path = find_program(name))
          return path
        end
      end

      return nil
    end

    #
    # Runs a program.
    #
    # @param [String] path
    #   The path to the program.
    #
    # @param [Array] arguments
    #   Additional arguments to run the program with.
    #   The last argument of `arguments` may be a `Hash` of options.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#system-instance_method
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method
    #
    def Compat.run(path,*arguments)
      if arguments.last.kind_of?(Hash)
        options = arguments[-1..-1]
        arguments = arguments[0..-2]
      else
        options = []
      end

      arguments = arguments.map { |arg| arg.to_s }

      if RProgram.debug
        STDERR.puts ">>> #{path} #{arguments.join(' ')}"
      end

      return Kernel.system(path,*(arguments + options))
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
    # @raise [ProgramNotFound]
    #   Indicates that the `sudo` program could not be located.
    #
    # @since 0.1.8
    #
    def Compat.sudo(path,*args)
      sudo_path = find_program('sudo')

      unless sudo_path
        raise(ProgramNotFound,'could not find the "sudo" program',caller)
      end

      return run(sudo_path,path,*args)
    end
  end
end
