require 'rprogram/task'

module RProgram
  #
  # Represents the options for `sudo`.
  #
  # ## Sudo options:
  #
  # * `-A` - `sudo.ask_password`
  # * `-b` - `sudo.background`
  # * `-C` - `sudo.close_from`
  # * `-E` - `sudo.preserve_env`
  # * `-e` - `sudo.edit`
  # * `-g` - `sudo.group`
  # * `-H` - `sudo.home`
  # * `-h` - `sudo.help`
  # * `-i` - `sudo.simulate_initial_login`
  # * `-k` - `sudo.kill`
  # * `-K` - `sudo.sure_kill`
  # * `-L` - `sudo.list_defaults`
  # * `-l` - `sudo.list`
  # * `-n` - `sudo.non_interactive`
  # * `-P` - `sudo.preserve_group`
  # * `-p` - `sudo.prompt`
  # * `-r` - `sudo.role`
  # * `-S` - `sudo.stdin`
  # * `-s` - `sudo.shell`
  # * `-t` - `sudo.type`
  # * `-U` - `sudo.other_user`
  # * `-u` - `sudo.user`
  # * `-V` - `sudo.version`
  # * `-v` - `sudo.validate`
  #
  # * `[command]` - `sudo.command`
  #
  # @since 0.3.0
  #
  class SudoTask < Task

    short_option :name => :ask_password, :flag => '-A'
    short_option :name => :background, :flag => '-b'
    short_option :name => :close_from, :flag => '-C'
    short_option :name => :preserve_env, :flag => '-E'
    short_option :name => :edit, :flag => '-e'
    short_option :name => :group, :flag => '-g'
    short_option :name => :home, :flag => '-H'
    short_option :name => :help, :flag => '-h'
    short_option :name => :simulate_initial_login, :flag => '-i'
    short_option :name => :kill, :flag => '-k'
    short_option :name => :sure_kill, :flag => '-K'
    short_option :name => :list_defaults, :flag => '-L'
    short_option :name => :list, :flag => '-l'
    short_option :name => :non_interactive, :flag => '-n'
    short_option :name => :preserve_group, :flag => '-P'
    short_option :name => :prompt, :flag => '-p'
    short_option :name => :role, :flag => '-r'
    short_option :name => :stdin, :flag => '-S'
    short_option :name => :shell, :flag => '-s'
    short_option :name => :type, :flag => '-t'
    short_option :name => :other_user, :flag => '-U'
    short_option :name => :user, :flag => '-u'
    short_option :name => :version, :flag => '-V'
    short_option :name => :validate, :flag => '-v'

    non_option :tailing => true, :name => :command

  end
end
