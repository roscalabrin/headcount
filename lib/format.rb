module Format

  def truncate(number)
    (number * 1000).floor / 1000.to_f
  end


end
