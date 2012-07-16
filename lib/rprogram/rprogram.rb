module RProgram
  @debug = false

  #
  # @return [true, false]
  #   Specifies whether debugging messages are enabled for RProgram.
  #   Defaults to false, if not set.
  #
  def self.debug
    @debug
  end

  #
  # Enables or disables debugging messages for RProgram.
  #
  # @param [true, false] value
  #   The new value of RProgram.debug.
  #
  # @return [true, false]
  #   The new value of RProgram.debug.
  #
  def self.debug=(value)
    @debug = value
  end
end
