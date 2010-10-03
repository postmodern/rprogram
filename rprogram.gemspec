# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{rprogram}
  s.version = "0.1.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Postmodern"]
  s.date = %q{2010-10-03}
  s.description = %q{RProgram is a library for creating wrappers around command-line programs. RProgram provides a Rubyful interface to programs and all their options or non-options. RProgram can also search for programs installed on a system.}
  s.email = %q{postmodern.mod3@gmail.com}
  s.extra_rdoc_files = [
    "ChangeLog.md",
     "LICENSE.txt",
     "README.md"
  ]
  s.files = [
    ".gitignore",
     ".specopts",
     ".yardopts",
     "ChangeLog.md",
     "LICENSE.txt",
     "README.md",
     "Rakefile",
     "lib/rprogram.rb",
     "lib/rprogram/compat.rb",
     "lib/rprogram/exceptions.rb",
     "lib/rprogram/exceptions/program_not_found.rb",
     "lib/rprogram/extensions.rb",
     "lib/rprogram/nameable.rb",
     "lib/rprogram/nameable/class_methods.rb",
     "lib/rprogram/nameable/nameable.rb",
     "lib/rprogram/non_option.rb",
     "lib/rprogram/option.rb",
     "lib/rprogram/option_list.rb",
     "lib/rprogram/options.rb",
     "lib/rprogram/options/class_methods.rb",
     "lib/rprogram/options/options.rb",
     "lib/rprogram/program.rb",
     "lib/rprogram/rprogram.rb",
     "lib/rprogram/task.rb",
     "lib/rprogram/version.rb",
     "lib/rprogram/yard.rb",
     "rprogram.gemspec",
     "spec/classes/aliased_program.rb",
     "spec/classes/ls_program.rb",
     "spec/classes/ls_selinux_task.rb",
     "spec/classes/ls_task.rb",
     "spec/classes/named_program.rb",
     "spec/compat_spec.rb",
     "spec/nameable_spec.rb",
     "spec/non_option_spec.rb",
     "spec/option_examples.rb",
     "spec/option_list_spec.rb",
     "spec/option_spec.rb",
     "spec/program_spec.rb",
     "spec/rprogram_spec.rb",
     "spec/spec_helper.rb",
     "spec/task_spec.rb"
  ]
  s.has_rdoc = %q{yard}
  s.homepage = %q{http://github.com/postmodern/rprogram}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{A library for creating wrappers around command-line programs.}
  s.test_files = [
    "spec/classes/ls_program.rb",
     "spec/classes/named_program.rb",
     "spec/classes/ls_selinux_task.rb",
     "spec/classes/aliased_program.rb",
     "spec/classes/ls_task.rb",
     "spec/nameable_spec.rb",
     "spec/program_spec.rb",
     "spec/rprogram_spec.rb",
     "spec/option_examples.rb",
     "spec/non_option_spec.rb",
     "spec/compat_spec.rb",
     "spec/option_list_spec.rb",
     "spec/spec_helper.rb",
     "spec/option_spec.rb",
     "spec/task_spec.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_development_dependency(%q<yard>, [">= 0.5.3"])
    else
      s.add_dependency(%q<rspec>, [">= 1.3.0"])
      s.add_dependency(%q<yard>, [">= 0.5.3"])
    end
  else
    s.add_dependency(%q<rspec>, [">= 1.3.0"])
    s.add_dependency(%q<yard>, [">= 0.5.3"])
  end
end

