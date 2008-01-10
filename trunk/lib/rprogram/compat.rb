module RProgram
  module Compat
    #
    # Returns the native _platform_.
    #
    #   Compat.arch  #=> "linux"
    #
    def self.platform
      RUBY_PLATFORM.split('-').last
    end

    #
    # Returns an array representing the +PATH+ environment variable.
    # If the +PATH+ environment variable is not setup, an empty array will
    # be returned.
    #
    #   Compat.PATH  #=> ["/bin", "/usr/bin"]
    #
    def self.PATH
      # return an empty array in case
      # the PATH variable does not exist
      return [] unless ENV['PATH']

      if self.platform =~ /mswin32/
        return ENV['PATH'].split(';')
      else
        return ENV['PATH'].split(':')
      end
    end

    #
    # Finds the program matching _name_ and returns it's full path.
    # If the program was not found, +nil+ will be returned.
    #
    #   Compat.find_program('as')  #=> "/usr/bin/as"
    #
    def self.find_program(name)
      self.PATH.each do |dir|
        full_path = File.expand_path(File.join(dir,name))

        return full_path if File.file?(full_path)
      end

      return nil
    end

    #
    # Finds the program matching one of the names within _names_ and
    # returns it's full path. If no program was found matching any of
    # the names, the +nil+ will be returned.
    #
    #   Compat.find_program_by_names("gas","as")  #=> "/usr/bin/as"
    #
    def self.find_program_by_names(*names)
      names.map { |name| self.find_program(name) }.compact.first
    end
  end
end
