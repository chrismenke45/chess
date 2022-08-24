class String
  def black
    "\e[30m#{self}\e[0m"
  end

  def bg_blue
    "\e[44m#{self}\e[0m"
  end

  def bg_cyan
    "\e[46m#{self}\e[0m"
  end
end
