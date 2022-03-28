class Base < StandardError
  def initialize(message)
    super("Error: #{message}")
  end
end