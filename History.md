### 0.1.8 / 2009-12-24
 
* Allow Program to run commands under sudo:
  * Added Compat.sudo.
  * Added Task#sudo.
  * Added Task#sudo=.
  * Added Task#sudo?.
  * Added Program#sudo.

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
* Renamed Compat.PATHS to Compat.paths.
* Refactored Option#arguments.
* Removed Option#format.
* Refactored NonOption#arguments.
* Renamed NonOption#leading to NonOption#leading?.
* Removed NonOption#tailing.
* Added NonOption#tailing?.
* Added specs.
* All specs pass on Ruby 1.9.1-p0 and 1.8.6-p287.

### 0.1.5 / 2009-01-14

* Use Kernel.system in RProgram::Program#run, instead of Open3.popen3:
  * popen3 is not well supported on Windows.
  * win32-open3 does not allow for the execution of single programs with
    separate command-line arguments. Instead, it merely executes a command
    string in command.com. This seems to allow arbitrary command injection
    via command-line arguments.
  * RProgram::Program#run will now return either `true` or `false`,
    depending on the exit status of the program.
* Added some missing documentation.

### 0.1.4 / 2009-01-07

* Added `lib/rprogram/rprogram.rb` to the Manifest.
* Added more documentation.

### 0.1.3 / 2008-01-27

* Renamed `Program.create_from_path` to
  `Program.find_with_path`.
* Renamed `Program.create_from_paths` to
  `Program.find_with_paths`.
* Renamed `Program.create` to `Program.find`.
* Renamed `Program.run_with_task` to `Program.run_task`.

### 0.1.2 / 2008-01-18

* DRY'ed up lib/rprogram/task.
  * Added Task.define_option.
* Added OptionList so that Option may contain sub-options.
* Touched up documenation.

### 0.1.1 / 2008-01-18

* Added support for the Option argument separators.

  #
  # Creates arguments of the form:
  #
  #   ["-opts","value1:value2:value3"]
  #
  long_option :flag => '-opts', :separator => ':'

* Fixed lib/rprogram.rb file.

### 0.1.0 / 2008-01-17

* Removed redundent methods in Program:
  * Program.find_by_name
  * Program.find_by_names
* Added Program#create.
* Made Program Nameable by default.
* Prevented arbitrary command-injection in Program#run.

### 0.0.9 / 2008-01-09

* Initial release.
* Provides cross-platform access to the PATH variable.
* Supports mapping long and short options.
* Supports mapping leading and tailing non-options.
* Supports custom formating of options.

