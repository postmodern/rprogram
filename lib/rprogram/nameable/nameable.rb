require 'rprogram/nameable/class_methods'
require 'rprogram/compat'

module RProgram
  module Nameable
    def self.included(base)
      base.send :extend, ClassMethods
    end

    #
    # @return [String]
    #   The program name of the class.
    #
    def program_name
      self.class.program_name
    end

    #
    # @return [Array]
    #   The program aliases of the class.
    #
    def program_aliases
      self.class.program_aliases
    end

    #
    # @return [Array]
    #   The program names of the class.
    #
    def program_names
      self.class.program_names
    end
  end
end
