module RProgram
  #
  # Returns +true+ if RProgram debugging messages are enabled, returns
  # +false+ if they are not enabled.
  #
  def RProgram.debug
    @@rprogram_debug ||= false
  end

  #
  # Enables or disables RProgram debugging messages depending on the
  # specified _value_.
  #
  def RProgram.debug=(value)
    @@rprogram_debug = value
  end
end
