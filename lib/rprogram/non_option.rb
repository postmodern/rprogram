module RProgram
  class NonOption

    # Name of the argument(s)
    attr_reader :name

    # Can the argument be specified multiple times
    attr_reader :multiple

    #
    # Creates a new NonOption object.
    #
    # @param [Hash] options Additional options.
    # @option options [Symbol] :name The name of the non-option.
    # @option options [true, false] :leading (true)
    #                                        Implies the non-option is a
    #                                        leading non-option.
    # @option options [false, true] :tailing (false)
    #                                        Implies the non-option is a
    #                                        tailing non-option.
    # @option options [false, true] :multiple (false)
    #                                         Implies the non-option maybe
    #                                         given an Array of values.
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
    # Determines whether the non-option's arguments are tailing.
    #
    # @return [true, false] Specifies whether the non-option's arguments are
    #                       tailing.
    #
    def tailing?
      @tailing == true
    end

    #
    # Determines whether the non-option's arguments are leading.
    #
    # @return [true, false] Specifies whether the non-option's arguments are
    #                       leading.
    #
    def leading?
      !(@tailing)
    end

    #
    # Formats the arguments for the non-option.
    #
    # @param [Hash, Array, String, nil] value The value to use for the
    #                                         arguments of the non-option.
    #                                   
    # @return [Array] The arguments for the non-option.
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
