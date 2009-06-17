require 'rprogram/nameable'

class AliasedProgram

  include RProgram::Nameable

  name_program 'ls'
  alias_program 'dir'

end
