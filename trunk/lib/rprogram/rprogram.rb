module RProgram
  def RProgram.debug
    @@debug ||= false
  end

  def RProgram.debug=(value)
    @@debug = value
  end
end
