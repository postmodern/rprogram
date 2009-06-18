require 'classes/ls_task'

class LSSELinuxTask < LSTask

  long_option :flag => '--lcontext', :name => :security_context

end
