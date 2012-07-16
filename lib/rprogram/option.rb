require 'rprogram/argument'

module RProgram
  class Option < Argument

    # Flag of the option
    attr_reader :flag

    # Is the option in equals format
    attr_reader :equals

    # Can the option be specified multiple times
    attr_reader :multiple

    # Argument separator
    attr_reader :separator

    # Does the option contain sub-options
    attr_reader :sub_options

    #
    # Creates a new Option object with. If a block is given it will be
    # used for the custom formatting of the option. If a block is not given,
    # the option will use the default_format when generating the arguments.
    #
    # @param [Hash] options
    #   Additional options.
    #
    # @option options [String] :flag
    #   The command-line flag to use.
    #
    # @option options [true, false] :equals (false)
    #   Implies the option maybe formated as `--flag=value`.
    #
    # @option options [true, false] :multiple (false)
    #   Specifies the option maybe given an Array of values.
    #
    # @option options [String] :separator
    #   The separator to use for formating multiple arguments into one
    #   `String`. Cannot be used with the `:multiple` option.
    #
    # @option options [true, false] :sub_options (false)
    #   Specifies that the option contains sub-options.
    #
    # @yield [option, value]
    #   If a block is given, it will be used to format each value of the
    #   option.
    #
    # @yieldparam [Option] option
    #   The option that is being formatted.
    #
    # @yieldparam [String, Array] value
    #   The value to format for the option. May be an Array, if multiple
    #   values are allowed with the option.
    #
    def initialize(options={},&block)
      @flag = options[:flag]

      @equals    = (options[:equals] || false)
      @multiple  = (options[:multiple] || false)
      @separator = if options[:separator] then options[:separator]
                   elsif options[:equals] then ' '
                   end
      @sub_options = (options[:sub_options] || false)

      @formatter = if block
                     block
                   else
                     Proc.new do |opt,value|
                       if opt.equals
                         ["#{opt.flag}=#{value.first}"]
                       else
                         [opt.flag] + value
                       end
                     end
                   end
    end

    #
    # Formats the arguments for the option.
    #
    # @param [Hash, Array, String] value
    #   The arguments to format.
    #
    # @return [Array]
    #   The formatted arguments of the option.
    #
    def arguments(value)
      case value
      when true
        [@flag]
      when false, nil
        []
      else
        value = super(value)

        if @multiple
          args = []

          value.each do |arg|
            args += Array(@formatter.call(self,[arg]))
          end

          return args
        else
          value = [value.join(@separator)] if @separator

          return Array(@formatter.call(self,value))
        end
      end
    end

  end
end
