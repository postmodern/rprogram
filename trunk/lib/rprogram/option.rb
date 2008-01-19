require 'rprogram/extensions'

module RProgram
  class Option

    # Flag of the option
    attr_reader :flag

    # Is the option in equals format
    attr_reader :equals

    # Can the option be specified multiple times
    attr_reader :multiple

    # Argument separator
    attr_reader :separator

    #
    # Creates a new Option object with the specified _options_. If a _block_
    # is given it will be used for the custom formating of the option. If a
    # _block_ is not given, the option will use the default_format when
    # generating the arguments.
    #
    # _options_ must contain the following key:
    # <tt>:flag</tt>:: The command-line flag to use.
    #
    # _options_ may also contain the following keys:
    # <tt>:equals</tt>:: Implies the option maybe formated as
    #                    <tt>"--flag=value"</tt>. Defaults to +falue+, if
    #                    not given.
    # <tt>:multuple</tt>:: Implies the option maybe given an Array of
    #                      values. Defaults to +false+, if not given.
    # <tt>:separator</tt>:: The separator to use for formating multiple
    #                       arguments into one +String+. Cannot be used
    #                       with <tt>:multiple</tt>.
    #
    def initialize(options={},&block)
      @flag = options[:flag]

      @equals = options[:equals] || false
      @multiple = options[:multiple] || false
      @separator = options[:separator]

      @formating = block
    end

    #
    # Returns an +Array+ of the arguments for the option with the specified
    # _value_.
    #
    def arguments(value)
      return [@flag] if value==true
      return [] if (value==nil || value==false)

      if value.respond_to?(:arguments)
        value = value.arguments
      end

      if @multiple
        if value.respond_to?(:map)
          return value.map { |arg| format(arg) }
        end
      end

      if (value.kind_of?(Array) && @separator)
        value = value.join(@separator)
      end

      return format(value)
    end

    protected

    #
    # Returns an Array of the flag and the specified _value_ in argument
    # form.
    #
    def default_format(value)
      return [@flag] + value if value.kind_of?(Array)
      return ["#{flag}=#{value}"] if @equals
      return [@flag, value]
    end

    #
    # Formats specified _value_ with the option flag using
    # either the custom formating or the default_format.
    #
    def format(value)
      if @formating
        return @formating.call(@flag,value).to_a
      else
        return default_format(value)
      end
    end

  end
end
