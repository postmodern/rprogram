require 'rprogram/extensions/meta'
require 'rprogram/non_option'
require 'rprogram/option'

module RProgram
  module Options
    def self.included(base)
      base.metaclass_eval do
        #
        # Returns a Hash of all defined non-options.
        #
        def non_options
          @non_options ||= {}
        end

        #
        # Returns +true+ if the non-option with the specified _name_ was
        # defined, returns +false+ otherwise.
        #
        def has_non_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return true if base.non_options.include?(name)
            end
          end

          return false
        end

        #
        # Returns the non-option known by _name_, returns +nil+ otherwise.
        #
        def get_non_option(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return base.non_options[name] if base.non_options.has_key?(name)
            end
          end

          return nil
        end

        #
        # Returns a Hash of all defined options.
        #
        def options
          @options ||= {}
        end

        #
        # Returns +true+ if an option with the specified _name_ was defined,
        # returns +false+ otherwise.
        #
        def has_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return true if base.options.has_key?(name)
            end
          end

          return false
        end

        #
        # Returns the option with the specified _name_, returns +nil+
        # otherwise.
        #
        def get_option(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return base.options[name] if base.options.has_key?(name)
            end
          end

          return nil
        end
      end
    end

    #
    # Returns +true+ if the non-option with the specified _name_ was
    # defined, returns +false+ otherwise.
    #
    def has_non_option?(name)
      self.class.has_non_option?(name)
    end

    #
    # Returns the non-option known by _name_, returns +nil+ otherwise.
    #
    def get_non_option(name)
      self.class.get_non_option(name)
    end

    #
    # Returns +true+ if an option with the specified _name_ was defined,
    # returns +false+ otherwise.
    #
    def has_option?(name)
      self.class.has_option?(name)
    end

    #
    # Returns the option with the specified _name_, returns +nil+
    # otherwise.
    #
    def get_option(name)
      self.class.get_option(name)
    end
  end
end
