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

    def initialize(opts={:name => nil, :leading => false, :tailing => false, :multiple => false})
      @name = opts[:name]

      @leading = opts[:leading] || false
      @tailing = opts[:tailing] || true
      @multiple = opts[:multiple] || false
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
