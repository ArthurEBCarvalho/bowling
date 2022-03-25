class InvalidRecord < StandardError
  def initialize(message)
    super("Error: #{message}")
  end
end