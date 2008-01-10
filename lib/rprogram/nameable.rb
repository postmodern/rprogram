require 'rprogram/extensions/meta'
require 'rprogram/compat'

module RProgram
  module Nameable
    def self.included(base)
      base.metaclass_eval do
        def program_name
          @program_name
        end

        def program_name=(name)
          @program_name = name.to_s
        end

        def program_aliases
          @program_aliases ||= []
        end

        def program_aliases=(aliases)
          @program_aliases = aliases.to_a.map { |name| name.to_s }
        end

        def find_program
          names = self.program_aliases
          names.unshift(self.program_name) if self.program_name

          return Compat.find_program_by_names(*names)
        end
      end
    end

    #
    # Returns the program name of a class.
    #
    def program_name
      self.class.program_name
    end

    #
    # Returns the program aliases.
    #
    def program_aliases
      self.class.program_aliases
    end

    protected

    #
    # Sets the program name for a class to the specified _name_.
    #
    #   name_program 'ls'
    #
    def Object.name_program(name)
      self.program_name = name
    end

    #
    # Sets the program aliases for a class to the specified _aliases_.
    #
    #   name_program 'vim', 'vi'
    #
    def Object.alias_program(*aliases)
      self.program_aliases = aliases
    end
  end
end
