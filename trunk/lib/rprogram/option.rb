module RProgram
  class Option

    # Flag of the option
    attr_reader :flag

    # Is the option in equals format
    attr_reader :equals

    # Can the option be specified multiple times
    attr_reader :multiple

    def initialize(opts={:flag => nil, :equals => false, :multiple => false},&block)
      @flag = opts[:flag]

      @equals = opts[:equals] || false
      @multiple = opts[:multiple] || false

      @formating = block
    end

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

    def default_format(value)
      return [@flag] + value if value.kind_of?(Array)
      return ["#{flag}=#{value}"] if @equals
      return [@flag, value]
    end

    def format(value)
      if @formating
        return @formating.call(@flag,value).to_a
      else
        return default_format(value)
      end
    end

  end
end
