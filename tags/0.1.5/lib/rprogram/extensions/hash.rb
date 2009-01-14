class Hash

  def arguments
    map { |key,value|
      if value
        if value==true
          key.to_s
        else
          "#{key}=#{value}"
        end
      end
    }.compact
  end

end
