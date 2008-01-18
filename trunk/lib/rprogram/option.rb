module RProgram
  class Option

    # Flag of the option
    attr_reader :flag

    # Is the option in equals format
    attr_reader :equals

    # Can the option be specified multiple times
    attr_reader :multiple

    #
    # Creates a new Option object with the specified _options_. If a _block_
    # is given it will be used for the custom formating of the option. If a
    # _block_ is not given, the option will use the default_format when
    # generating the arguments.
    #
    # _options_ may contain the following keys:
    # <tt>:flag</tt>:: The command-line flag to use.
    # <tt>:equals</tt>:: Implies the option maybe formated as '--flag=value'.
    #                    Defaults to +falue+, if not given.
    # <tt>:multuple</tt>:: Implies the option maybe given an Array of
    #                      values. Defaults to +false+, if not given.
    #
    def initialize(options={},&block)
      @flag = options[:flag]

      @equals = options[:equals] || false
      @multiple = options[:multiple] || false

      @formating = block
    end

    #
    # Returns an +Array+ of the arguments for the option with the specified
    # _value_.
    #
    def arguments(value)
      return [@flag] if value==true
      return [] if (value==nil || value==false)

      if value.kind_of?(Hash)
        value = value.map { |name,value| "#{name}=#{value}" }
      elsif value.kind_of?(Array)
        value = value.compact
      end

      if @multiple
        args = []

        value.each { |arg| args += format(arg) }
        return args
      else
        return format(value)
      end
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
