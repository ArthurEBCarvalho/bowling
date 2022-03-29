require 'pry'
require_relative '../exceptions/invalid_record'
require_relative '../services/score_calculator'

# Model to represents a player
class Player
  attr_accessor :name, :pinfalls, :scores

  SIZE_ERROR_MESSAGE = 'The player must have exactly 10 rounds'.freeze
  NAME_ERROR_MESSAGE = 'The player must have a name'.freeze

  def initialize(name, pinfalls)
    @name     = name
    @pinfalls = pinfalls

    validate!

    @scores = ScoreCalculator.new(pinfalls).call
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
