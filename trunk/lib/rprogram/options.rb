require 'rprogram/extensions/meta'
require 'rprogram/non_option'
require 'rprogram/option'

module RProgram
  module Options
    def self.included(base)
      base.metaclass_eval do
        def non_options
          @non_options ||= {}
        end

        def has_non_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return true if base.non_options.include?(name)
            end
          end

          return false
        end

        def get_non_option(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return base.non_options[name] if base.non_options.has_key?(name)
            end
          end

          return nil
        end

        def options
          @options ||= {}
        end

        def has_option?(name)
          name = name.to_sym

          ancestors.each do |base|
            if base.include?(Options)
              return true if base.options.has_key?(name)
            end
          end

          return false
        end

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

    def has_non_option?(name)
      self.class.has_non_option?(name)
    end

    def get_non_option(name)
      self.class.get_non_option(name)
    end

    def has_option?(name)
      self.class.has_option?(name)
    end

    def get_option(name)
      self.class.get_option(name)
    end
  end
end
