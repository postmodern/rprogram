module RProgram
  class NonOption

    # Name of the argument(s)
    attr_reader :name

    # Is the argument a tailing argument(s)
    attr_reader :tailing

    # Can the argument be specified multiple times
    attr_reader :multiple

    #
    # Creates a new NonOption object with the specified _options_.
    #
    # _options_ may contain the following keys:
    # <tt>:name</tt>:: The name of the non-option.
    # <tt>:leading</tt>:: Implies the non-option is a leading non-option.
    #                     Defaults to +false+, if not given.
    # <tt>:tailing</tt>:: Implies the non-option is a tailing non-option.
    #                     Defaults to +true+, if not given.
    # <tt>:multiple</tt>:: Implies the non-option maybe given an Array
    #                      of values. Defaults to +false+, if not given.
    #
    def initialize(options={})
      @name = options[:name]

      @tailing = if options[:leading]
                   !(options[:leading])
                 elsif options[:tailing]
                   options[:tailing]
                 else
                   true
                 end

      @multiple = (options[:multiple] || false)
    end

    #
    # Returns +true+ if the non-options arguments are leading, returns
    # +false+ otherwise.
    #
    def leading
      !(@tailing)
    end

    #
    # Returns an +Array+ of the arguments for the non-option with the
    # specified _value_.
    #
    def arguments(value)
      return [] unless value

      if value.kind_of?(Hash)
        return value.map { |name,value| "#{name}=#{value}" }
      elsif value.kind_of?(Array)
        return value.compact
      else
        return [value]
      end
    end

  end
end
