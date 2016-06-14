class UnknownDataError < StandardError
  def message
    "Unknown Data"
  end
end

class UnknownRaceError < StandardError
  def message
    "Unknown Race"
  end
end

class InsufficientInformationError < StandardError
  def message
    "A grade must be provided to answer this question"
  end
end
