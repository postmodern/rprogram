module RProgram
  #
  # @return [true, false] Specifies whether debugging messages are enabled
  #                       for RProgram. Defaults to false, if not set.
  #
  def RProgram.debug
    @@rprogram_debug ||= false
  end

  #
  # Enables or disables debugging messages for RProgram.
  #
  # @param [true, false] value The new value of RProgram.debug.
  # @return [true, false] The new value of RProgram.debug.
  #
  def RProgram.debug=(value)
    @@rprogram_debug = value
  end
end
