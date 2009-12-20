module RProgram
  class OptionList < Hash

    #
    # Creates a new OptionList object.
    #
    # @param [Hash{Symbol => String}] options
    #   The options to start with.
    #
    def initialize(options={})
      super(options)
    end

    protected

    #
    # Provides transparent access to the options within the option list.
    #
    # @example
    #   opt_list = OptionList.new(:name => 'test')
    #   opt_list.name
    #   # => "test"
    #
    def method_missing(sym,*args,&block)
      name = sym.to_s

      unless block
        if (name =~ /=$/ && args.length == 1)
          return self[name.chop.to_sym] = args.first
        elsif args.empty?
          return self[sym]
        end
      end

      return super(sym,*args,&block)
    end

  end
end
