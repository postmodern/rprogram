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

      #
      # The default path of the program.
      #
      # @return [String, nil]
      #   The path to the program.
      #
      # @since 0.2.0
      #
      def path
        @program_path
      end

      #
      # Sets the default path to the program.
      #
      # @param [String] new_path
      #   The new path to the program.
      #
      # @return [String, nil]
      #   The path to the program.
      #
      # @since 0.2.0
      #
      def path=(new_path)
        @program_path = (File.expand_path(new_path) if new_path)
      end
    end
  end
end
