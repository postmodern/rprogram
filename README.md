# RProgram

* [Source](https://github.com/postmodern/rprogram)
* [Issues](https://github.com/postmodern/rprogram/issues)
* [Documentation](http://rubydoc.info/gems/rprogram/frames)
* [Email](mailto:postmodern.mod3 at gmail.com)

## Description
  
RProgram is a library for creating wrappers around command-line programs.
RProgram provides a Rubyful interface to programs and all their options
or non-options. RProgram can also search for programs installed on a
system.

## Features

* Safely executes individual programs and their separate command-line
  arguments, to prevent command or option injection.
* Supports using Ruby 1.9 [exec options](http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method).
* Supports specifying environment variables of a process
  (only available on Ruby 1.9).
* Allows running programs with `IO.popen` (only available on Ruby 1.9).
* Allows running programs under `sudo`.
* Provides cross-platform access to the `PATH` environment variable.
* Supports leading/tailing non-options.
* Supports long-options and short-options.
* Supports custom formating of options.

## Examples

First, create the class to represent the options of the program, using
{RProgram::Task} as the base class:

    require 'rprogram/task'

    class MyProgTask < RProgram::Task

      # map in the short-options
      short_option :flag => '-o', :name => :output
      short_option :flag => '-oX', :name => :xml_output

      # map in long options
      long_option :flag => '--no-resolv', :name => :disable_resolv

      # long_option can infer the :name option, based on the :flag
      long_option :flag => '--mode'

      # options can also take multiple values
      long_option :flag => '--includes', :multiple => true

      # options with multiple values can have a custom separator character
      long_option :flag      => '--ops',
                  :multiple  => true,
                  :separator => ','

      # define any non-options (aka additional arguments)
      non_option :tailing => true, :name => :files

    end

Next, create the class to represent the program you wish to interface with,
using {RProgram::Program} as the base class:

    require 'my_prog_task'

    require 'rprogram/program'

    class MyProg < RProgram::Program

      # identify the file-name of the program
      name_program 'my_prg'

      # add a top-level method which finds and runs your program.
      def self.my_run(options={},&block)
        self.find.my_run(options,&block)
      end

      # add a method which runs the program with MyProgTask.
      def my_run(options={},&block)
        run_task(MyProgTask.new(options,&block))
      end

    end

Finally, run your program with options or a block:

    MyProgram.my_run(:mode => :fast, :files => ['test1'])
    # => true

    MyProgram.my_run do |my_prog|
      my_prog.includes = ['one', 'two', 'three']
      my_prog.mode     = :safe

      my_prog.output = 'output.txt'
      my_prog.files  = ['test1.txt', 'test2.txt']
    end
    # => true

## Install

    $ gem install rprogram

## License

Copyright (c) 2007-2012 Hal Brodigan

See {file:LICENSE.txt} for license information.
