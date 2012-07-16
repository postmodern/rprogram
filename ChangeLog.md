### 0.3.2 / 2012-07-15

* Require Ruby >= 1.8.7.
* Removed env as a dependency.
* Added {RProgram::Argument}.
* Removed orphaned `rprogram/yard.rb` file.
* Style improvements.

### 0.3.1 / 2012-05-27

* Replaced ore-tasks with
  [rubygems-tasks](https://github.com/postmodern/rubygems-tasks#readme).

### 0.3.0 / 2011-04-08

* Merged `RProgram::Nameable` into {RProgram::Program}.
* Merged `RProgram::Options` into {RProgram::Task}.
* Renamed `RProgram::Compat` to {RProgram::System}.
* Added {RProgram::System.arch}.
* Added {RProgram::System.platform}.
* Added {RProgram::System.windows?}.
* Added {RProgram::System.ruby_1_8?}.
* Added {RProgram::System.jruby?}.
* Added {RProgram::System.sudo_path}.
* Added {RProgram::System.sudo_path=}.
* Added {RProgram::System.sudo?}.
* Added {RProgram::Sudo}.
* Added {RProgram::SudoTask}.
* Allow passing tailing [exec-options](http://rubydoc.info/stdlib/core/1.9.2/Kernel#spawn-instance_method)
  to {RProgram::System.run} (only supported on Ruby 1.9).
* Allow using `IO.popen` in {RProgram::System.run} if the `:popen` option
  is specified (only available on Ruby 1.9).
* Allow specifying the environment variables in {RProgram::System.run}
  if the `:env` option is specified (only available on Ruby 1.9).

### 0.2.3 / 2011-03-30

* Require env ~> 0.1, >= 0.1.2.
* Automatically search for programs with a `.exe` suffix, when running on
  Windows.
* `RProgram::Compat.find_program` and `RProgram::Compat.find_program_by_names`
  now return a `Pathname` object.

### 0.2.2 / 2011-01-22

* Deprecated `RProgram::Compat.platform`.
* Use `File::PATH_SEPARATOR` to separate the `PATH` environment variable
  in `RProgram::Compat.paths`.

### 0.2.1 / 2010-10-27

* Allow the formatter block passed to {RProgram::Option} to return `nil`.

### 0.2.0 / 2010-10-03

* Added `RProgram::Nameable::ClassMethods`.
* Added `RProgram::Options::ClassMethods`.
* Added `RProgram::Nameable::ClassMethods#path`:
  * {RProgram::Program.find} will default to
    `RProgram::Nameable::ClassMethods#path` if set.

### 0.1.8 / 2009-12-24
 
* Allow Program to run commands under sudo:
  * Added `RProgram::Compat.sudo`.
  * Added `RProgram::Task#sudo`.
  * Added `RProgram::Task#sudo=`.
  * Added `RProgram::Task#sudo?`.
  * Added {RProgram::Program#sudo}.

### 0.1.7 / 2009-09-21

* Require Hoe >= 2.3.3.
* Require YARD >= 0.2.3.5.
* Require RSpec >= 1.2.8.
* Use 'hoe/signing' for signed RubyGems.
* Moved to YARD based documentation.
* All specs pass on JRuby 1.3.1.

### 0.1.6 / 2009-06-30

* Use Hoe 2.2.0.
* Removed requirement for 'open3'.
* Renamed `PRogram::Compat.PATHS` to `RProgram::Compat.paths`.
* Refactored {RProgram::Option#arguments}.
* Removed `RProgram::Option#format`.
* Refactored `RProgram::NonOption#arguments`.
* Renamed `RProgram::NonOption#leading` to {RProgram::NonOption#leading?}.
* Removed `RProgram::NonOption#tailing`.
* Added {RProgram::NonOption#tailing?}.
* Added specs.
* All specs pass on Ruby 1.9.1-p0 and 1.8.6-p287.

### 0.1.5 / 2009-01-14

* Use Kernel.system in {RProgram::Program#run}, instead of Open3.popen3:
  * popen3 is not well supported on Windows.
  * win32-open3 does not allow for the execution of single programs with
    separate command-line arguments. Instead, it merely executes a command
    string in command.com. This seems to allow arbitrary command injection
    via command-line arguments.
  * {RProgram::Program#run} will now return either `true` or `false`,
    depending on the exit status of the program.
* Added some missing documentation.

### 0.1.4 / 2009-01-07

* Added `lib/rprogram/rprogram.rb` to the Manifest.
* Added more documentation.

### 0.1.3 / 2008-01-27

* Renamed `RProgram::Program.create_from_path` to
  {RProgram::Program.find_with_path}.
* Renamed `RProgram::Program.create_from_paths` to
  {RProgram::Program.find_with_paths}.
* Renamed `RProgram::Program.create` to {RProgram::Program.find}.
* Renamed `RProgram::Program.run_with_task` to {RProgram::Program#run_task}.

### 0.1.2 / 2008-01-18

* DRYed up lib/rprogram/task.
  * Added {RProgram::Task.define_option}.
* Added OptionList so that Option may contain sub-options.
* Touched up documenation.

### 0.1.1 / 2008-01-18

* Added support for the {RProgram::Option} argument separators.

        #
        # Creates arguments of the form:
        #
        #   ["-opts","value1:value2:value3"]
        #
        long_option :flag => '-opts', :separator => ':'

* Fixed the `lib/rprogram.rb` file.

### 0.1.0 / 2008-01-17

* Removed redundent methods in {RProgram::Program}:
  * `RProgram::Program.find_by_name`
  * `RProgram::Program.find_by_names`
* Added `RProgram::Program#create`.
* Made {RProgram::Program} nameable by default.
* Prevented arbitrary command-injection in {RProgram::Program#run}.

### 0.0.9 / 2008-01-09

* Initial release.
* Provides cross-platform access to the `PATH` environment variable.
* Supports mapping long and short options.
* Supports mapping leading and tailing non-options.
* Supports custom formating of options.

