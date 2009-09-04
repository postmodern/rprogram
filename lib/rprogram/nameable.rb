require 'rprogram/extensions/meta'
require 'rprogram/compat'

module RProgram
  module Nameable
    def self.included(base)
      base.metaclass_eval do
        #
        # @return [String] The name of the program.
        #
        def program_name
          @program_name ||= nil
        end

        #
        # @return [Array] The program's aliases.
        #
        def program_aliases
          @program_aliases ||= []
        end

        #
        # Combines program_name with program_aliases.
        #
        # @return [Array] Names the program is known by.
        #
        def program_names
          ([program_name] + program_aliases).compact
        end

        #
        # Sets the program name for the class.
        #
        # @param [String, Symbol] name The new program name.
        #
        # @example
        #   name_program 'ls'
        #
        def name_program(name)
          @program_name = name.to_s
        end

        #
        # Sets the program aliases for the class.
        #
        # @param [Array] aliases The new program aliases.
        #
        # @example
        #   alias_program 'vim', 'vi'
        #
        def alias_program(*aliases)
          @program_aliases = aliases.map { |name| name.to_s }
        end
      end
    end

    #
    # @return [String] The program name of the class.
    #
    def program_name
      self.class.program_name
    end

    #
    # @return [Array] The program aliases of the class.
    #
    def program_aliases
      self.class.program_aliases
    end

    #
    # @return [Array] The program names of the class.
    #
    def program_names
      self.class.program_names
    end
  end
end
