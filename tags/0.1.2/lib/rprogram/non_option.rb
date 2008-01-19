module RProgram
  class NonOption

    # Name of the argument(s)
    attr_reader :name

    # Is the argument a leading argument(s)
    attr_reader :leading

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

      @leading = options[:leading] || false
      @tailing = options[:tailing] || true
      @multiple = options[:multiple] || false
    end

    def arguments(value)
      return [] if (value==nil || value==false)

      if value.kind_of?(Hash)
        return value.map { |name,value| "#{name}=#{value}" }
      elsif value.kind_of?(Array)
        if @multiple
          return value.compact
        else
          return value.join
        end
      else
        return [value]
      end
    end

  end
end
