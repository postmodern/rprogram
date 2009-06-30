require 'rprogram/extensions/meta'
require 'rprogram/compat'

module RProgram
  module Nameable
    def self.included(base) # :nodoc:
      base.metaclass_eval do
        #
        # Returns the name of the program.
        #
        def program_name
          @program_name ||= nil
        end

        #
        # Returns an Array of the program's aliases.
        #
        def program_aliases
          @program_aliases ||= []
        end

        #
        # Returns an Array of all names the program is known by, combining
        # both program_name and program_aliases.
        #
        def program_names
          ([program_name] + program_aliases).compact
        end

        #
        # Sets the program name for a class to the specified _name_.
        #
        #   name_program 'ls'
        #
        def name_program(name)
          @program_name = name.to_s
        end

        #
        # Sets the program aliases for a class to the specified _aliases_.
        #
        #   alias_program 'vim', 'vi'
        #
        def alias_program(*aliases)
          @program_aliases = aliases.map { |name| name.to_s }
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

    #
    # Returns the program names.
    #
    def program_names
      self.class.program_names
    end
  end
end
