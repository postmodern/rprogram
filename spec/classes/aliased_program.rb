require 'rprogram/program'

class AliasedProgram < RProgram::Program

  name_program 'ls'
  alias_program 'dir'

end
