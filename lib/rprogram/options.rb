require 'rprogram/extensions/meta'
require 'rprogram/non_option'
require 'rprogram/option'

module RProgram
  module Options
    def self.included(base) # :nodoc:
      base.metaclass_eval do
        #
        # @return [Hash] All defined non-options of the class.
        #
        def non_options
          @non_options ||= {}
        end

        #
        # Searches for the non-option with the matching name in the class
        # and it's ancestors.
        #
        # @param [Symbol, String] name The name to search for.
        #
        # @return [true, false] Specifies whether the non-option with the
        #                       matching name was defined.
        #
        def has_non_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(RProgram::Options)
              return true if base.non_options.include?(name)
            end
          end

          return false
        end

        #
        # Searches for the non-option with the matching name in the class
        # and it's ancestors.
        #
        # @param [Symbol, String] name The name to search for.
        #
        # @return [NonOption] The non-option with the matching name.
        #
        def get_non_option(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(RProgram::Options)
              if base.non_options.has_key?(name)
                return base.non_options[name]
              end
            end
          end

          return nil
        end

        #
        # @return [Hash] All defined options for the class.
        #
        def options
          @options ||= {}
        end

        #
        # Searches for the option with the matching name in the class and
        # it's ancestors.
        #
        # @param [Symbol, String] name The name to search for.
        #
        # @return [true, false] Specifies whether the option with the
        #                       matching name was defined.
        #
        def has_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(RProgram::Options)
              return true if base.options.has_key?(name)
            end
          end

          return false
        end

        #
        # Searches for the option with the matching name in the class and
        # it's ancestors.
        #
        # @param [Symbol, String] name The name to search for.
        #
        # @return [Option] The option with the matching name.
        #
        def get_option(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(RProgram::Options)
              return base.options[name] if base.options.has_key?(name)
            end
          end

          return nil
        end
      end
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
