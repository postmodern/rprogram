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
      if @platform
        @platform.include?('mingw') || @platform.include?('mswin')
      else
        false
      end
    end

    #
    # Determines if the current Ruby VM is from the 1.8.x family.
    #
    # @return [Boolean]
    #   Specifies if the current Ruby VM is from the 1.8.x family.
    #
    # @since 0.3.0
    #  
    def System.ruby_1_8?
      RUBY_VERSION[0,4] == '1.8.'
    end

    #
    # Determines if the current Ruby VM is JRuby.
    #
    # @return [Boolean]
    #   Specifies whether the Ruby VM is JRuby.
    #
    # @since 0.3.0
    #
    def System.jruby?
      Object.const_defined?(:RUBY_ENGINE) && \
        Object.const_get(:RUBY_ENGINE) == 'jruby'
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
    #   @option options [String] :popen
    #     Specifies to run the program using `IO.popen` with the given
    #     IO mode.
    #
    # @return [Boolean]
    #   Specifies whether the program exited successfully.
    #
    # @raise [RuntimeError]
    #   Passing `:popen`, `:env` or exec options is not supported
    #   before Ruby 1.9.1.
    #
    # @see http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method
    #   For acceptable options.
    #
    def System.run(*arguments)
      # extra tailing options and ENV variables from arguments
      if arguments.last.kind_of?(Hash)
        options = arguments.pop
        env = (options.delete(:env) || {})
        popen = options.delete(:popen)
      else
        options = {}
        env = {}
      end

      # all arguments must be Strings
      arguments = arguments.map { |arg| arg.to_s }

      # print debugging information
      if RProgram.debug
        command = ''

        env.each do |name,value|
          command << "#{name}=#{value} "
        end
        
        command << arguments.join(' ')
        command << " #{options.inspect}" unless options.empty?

        STDERR.puts ">>> #{command}"
      end

      # passing ENV variables or exec options is not supported before 1.9.1
      if (!options.empty? && ruby_1_8?)
        raise("cannot pass exec options to Kernel.system in #{RUBY_VERSION}")
      end

      if popen
        # IO.popen does not accept multiple arguments on Ruby 1.8.x.
        if ruby_1_8?
          raise("cannot use :popen on #{RUBY_VERSION}, please use 1.9.x")
        end

        # :popen can only be used on Unix, or on Windows with JRuby
        if (windows? && !jruby?)
          raise("cannot use :popen on Windows, unless under JRuby")
        end
      end

      # re-add ENV variables and exec options
      arguments.unshift(env) unless env.empty?
      arguments.push(options) unless options.empty?

      if popen
        IO.popen(arguments,popen)
      else
        Kernel.system(*arguments)
      end
    end

    #
    # The path to the `sudo` program.
    #
    # @return [Pathname, nil]
    #   The path to the `sudo` program.
    #
    # @since 0.3.0
    #
    def System.sudo_path
      @sudo ||= find_program('sudo')
    end

    #
    # Sets the path to the `sudo` program.
    #
    # @param [String, Pathname] path
    #   The new path to use.
    #
    # @return [Pathanme]
    #   The new path to the `sudo` program.
    #
    # @since 0.3.0
    #
    def System.sudo_path=(path)
      @sudo = Pathname.new(path)
    end

    #
    # Determines whether `sudo` is available on the system.
    #
    # @return [Boolean]
    #   Specifies whether the `sudo` program is installed on the system.
    #
    # @since 0.3.0
    #
    def System.sudo?
      !sudo_path.nil?
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
    def System.sudo(*arguments)
      unless sudo?
        raise(ProgramNotFound,'could not find the "sudo" program')
      end

      return run(sudo_path,*arguments)
    end
  end
end
