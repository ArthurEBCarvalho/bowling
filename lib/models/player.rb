require 'pry'
require 'exceptions/invalid_record'

class Player
  attr_accessor :name, :pinfalls, :scores

  SIZE_ERROR_MESSAGE = 'The player must have exactly 10 rounds'
  NAME_ERROR_MESSAGE = 'The player must have a name'

  def initialize(name, pinfalls)
    @name     = name
    @pinfalls = pinfalls

    validate!
  end

  private

  def validate!
    size_validate!
    require_name!
  end

  def require_name!
    return if name.is_a?(String)

    raise InvalidRecord, NAME_ERROR_MESSAGE
  end

  def size_validate!
    return if pinfalls.size == 10

    raise InvalidRecord, SIZE_ERROR_MESSAGE
  end
end