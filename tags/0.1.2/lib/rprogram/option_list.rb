require 'rprogram/extensions/hash'

module RProgram
  class OptionList < Hash

    def initialize(options={})
      super(options)
    end

    protected

    def method_missing(sym,*args,&block)
      name = sym.to_s

      unless block
        if (name =~ /=$/ && args.length==1)
          return self[name.chop.to_sym] = args[0]
        elsif args.length==0
          return self[sym]
        end
      end

      super(sym,*args,&block)
    end

  end
end
