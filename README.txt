= RProgram

* http://rprogram.rubyforge.org/
* http://github.com/postmodern/rprogram/
* Postmodern (postmodern.mod3 at gmail.com)

== DESCRIPTION:
  
RProgram is a library for creating wrappers around command-line programs.
RProgram provides a Rubyful interface to programs and all their options
or non-options. RProgram can also search for programs installed on a
system.

== FEATURES/PROBLEMS:

* Uses Kernel.system for safe execution of individual programs and their
  separate command-line arguments.
* Allows running programs under +sudo+.
* Provides cross-platform access to the PATH variable.
* Supports leading/tailing non-options.
* Supports long-options and short-options.
* Supports custom formating of options.

== INSTALL:

  $ sudo gem install rprogram

== LICENSE:

The MIT License

Copyright (c) 2007-2009 Hal Brodigan

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
