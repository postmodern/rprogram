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
        value = value.map do |key,sub_value|
          if sub_value == true
            key.to_s
          elsif sub_value
            "#{key}=#{sub_value}"
          end
        end
      elsif value.kind_of?(Array)
        value = value.flatten
      else
        value = [value]
      end

      return value.compact
    end

  end
end
