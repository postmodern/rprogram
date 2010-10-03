module RProgram
  module Nameable
    module ClassMethods
      #
      # @return [String]
      #   The name of the program.
      #
      def program_name
        @program_name ||= nil
      end

      #
      # @return [Array]
      #   The program's aliases.
      #
      def program_aliases
        @program_aliases ||= []
      end

      #
      # Combines program_name with program_aliases.
      #
      # @return [Array]
      #   Names the program is known by.
      #
      def program_names
        ([program_name] + program_aliases).compact
      end

      #
      # Sets the program name for the class.
      #
      # @param [String, Symbol] name
      #   The new program name.
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
      # @param [Array] aliases
      #   The new program aliases.
      #
      # @example
      #   alias_program 'vim', 'vi'
      #
      def alias_program(*aliases)
        @program_aliases = aliases.map { |name| name.to_s }
      end
    end
  end
end
