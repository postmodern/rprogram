require 'rubygems'
require 'rake'
require './lib/rprogram/version.rb'

begin
  gem 'jeweler', '~> 1.4.0'
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = 'rprogram'
    gem.version = RProgram::VERSION
    gem.summary = %Q{A library for creating wrappers around command-line programs.}
    gem.description = %Q{RProgram is a library for creating wrappers around command-line programs. RProgram provides a Rubyful interface to programs and all their options or non-options. RProgram can also search for programs installed on a system.}
    gem.email = 'postmodern.mod3@gmail.com'
    gem.homepage = 'http://github.com/postmodern/rprogram'
    gem.authors = ['Postmodern']
    gem.add_development_dependency 'rspec', '~> 2.0.0'
    gem.add_development_dependency 'yard', '~> 0.6.0'
    gem.has_rdoc = 'yard'
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new
  task :default => :spec
rescue LoadError
  task :spec do
    abort "RSpec 2.0.0 is not available. In order to run spec, you must: gem install rspec"
  end
end

begin
  require 'yard'
  YARD::Rake::YardocTask.new
rescue LoadError
  task :yard do
    abort "YARD is not available. In order to run yard, you must: gem install yard"
  end
end
