require 'rprogram/exceptions/program_not_found'
require 'rprogram/rprogram'

require 'env/variables'

module RProgram
  module System
    extend Env::Variables

    @arch, @platform = RUBY_PLATFORM.split('-',2)

    #
    # Determines the native architecture.
    #
    # @return [String]
    #   The native architecture.
    #
    # @example
    #   System.arch
    #   # => "x86-64"
    #
    # @since 0.3.0
    #
    def System.arch
      @arch
    end

    #
    # Determines the native platform.
    #
    # @return [String]
    #   The native platform.
    #
    # @example
    #   System.platform
    #   # => "linux"
    #
    def System.platform
      @platform
    end

    #
    # Determines if the platform is Windows.
    #
    # @return [Boolean]
    #   Specifies whether the platform is Windows.
    #
    # @since 0.3.0
    #
    def System.windows?
      platform.include?('mingw') || platform.include?('mswin')
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
    #   System.find_program('as')
    #   #=> #<Pathname:/usr/bin/as>
    #
    def System.find_program(name)
      # add the `.exe` suffix to the name, if running on Windows
      if windows?
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
    #   System.find_program_by_names("gas","as")  #=> "/usr/bin/as"
    #
    def System.find_program_by_names(*names)
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
    # @overload run(path,*arguments)
    #   Run the program with the given arguments.
    #
    #   @param [Pathname, String] path
    #     The path of the program to run.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    # @overload run(path,*arguments,options)
    #   Run the program with the given arguments and options.
    #
    #   @param [Pathname, String] path
    #     The path of the program to run.
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
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method
    #   For acceptable options.
    #
    def System.run(*arguments)
      path = arguments.shift
      options = if arguments.last.kind_of?(Hash)
                  arguments.pop
                else
                  {}
                end

      env = (options.delete(:env) || {})

      path = path.to_s
      arguments = arguments.map { |arg| arg.to_s }

      if RProgram.debug
        STDERR.puts ">>> #{path} #{arguments.join(' ')}"
      end

      return Kernel.system(*([env, path] + arguments + [options]))
    end

    #
    # Runs a program under sudo.
    #
    # @overload run(path,*arguments)
    #   Run the program with the given arguments.
    #
    #   @param [Pathname, String] path
    #     The path of the program to run.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    # @overload run(path,*arguments,options)
    #   Run the program with the given arguments and options.
    #
    #   @param [Pathname, String] path
    #     The path of the program to run.
    #
    #   @param [Array] arguments
    #     Additional arguments to run the program with.
    #
    #   @param [Hash] options
    #     Additional options to execute the program with.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @raise [ProgramNotFound]
    #   Indicates that the `sudo` program could not be located.
    #
    # @since 0.1.8
    #
    # @see run
    #
    def System.sudo(path,*arguments)
      sudo_path = find_program('sudo')

      unless sudo_path
        raise(ProgramNotFound,'could not find the "sudo" program')
      end

      return run(sudo_path,path,*arguments)
    end
  end
end
