require 'rprogram/options/class_methods'
require 'rprogram/non_option'
require 'rprogram/option'

module RProgram
  module Options
    def self.included(base)
      base.send :extend, ClassMethods
    end

    #
    # @see self.has_non_option?
    #
    def has_non_option?(name)
      self.class.has_non_option?(name)
    end

    #
    # @see self.get_non_option
    #
    def get_non_option(name)
      self.class.get_non_option(name)
    end

    #
    # @see self.has_option?
    #
    def has_option?(name)
      self.class.has_option?(name)
    end

    #
    # @see self.get_option
    #
    def get_option(name)
      self.class.get_option(name)
    end
  end
end
