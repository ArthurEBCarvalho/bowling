# Base exception to add 'Error: ' to the message
class Base < StandardError
  def initialize(message)
    super("Error: #{message}")
  end
end
