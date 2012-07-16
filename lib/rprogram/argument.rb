module RProgram
  class Argument

    #
    # Formats a value into an Array of arguments.
    #
    # @param [Hash, Array, String] value
    #   The value to format.
    #
    # @return [Array]
    #   The formatted arguments.
    #
    def arguments(value)
      value = case value
              when Hash
                value.map do |key,sub_value|
                  if    sub_value == true then key.to_s
                  elsif sub_value         then "#{key}=#{sub_value}"
                  end
                end
              when false, nil
                []
              else
                Array(value)
              end

      return value.compact
    end

  end
end
