require 'pry'
require 'exceptions/invalid_record'

class Pinfall
  attr_accessor :quantities

  AMOUNT_ERROR_MESSAGE = 'The amount must be F or be between 0 and 10'
  SIZE_ERROR_MESSAGE   = 'This round has exactly two moves'

  def initialize(quantities)
    @quantities = quantities

    validate!
  end

  def total_falled_pins
    quantities_integer.sum
  end

  def related_total_falled_pins
    return [quantities_integer[0..1].sum, 10].min if three_times? # have to do a strike?

    quantities_integer.sum
  end
  
  def strike?
    quantities.size == 1 && total_falled_pins == 10 ||
      quantities.size == 3 && quantities.first == '10'
  end

  def spare?
    quantities.size == 2 && total_falled_pins == 10 ||
      quantities.size == 3 && quantities.first != '10'
  end

  def three_times?
    quantities.size == 3
  end

  def to_s
    return default_to_s if three_times?
    return "#{quantities.first}\t/" if spare?
    return "\tX" if strike?
    
    default_to_s
  end

  private

  def validate!
    amount_validate!
    size_validate!
  end

  def size_validate!
    return if right_size?

    raise InvalidRecord, SIZE_ERROR_MESSAGE
  end

  def right_size?
    quantities.size == 2 ||
      (quantities.size == 3 && quantities_integer[0..1].sum >= 10) ||
      (quantities.size == 1 && quantities.first == '10')
  end

  def amount_validate!
    return if only_number_or_foul? && not_negative? && less_than_or_equal_to_ten?
    
    raise InvalidRecord, AMOUNT_ERROR_MESSAGE
  end

  def only_number_or_foul?
    quantities.all? { |quantity| integer?(quantity) || quantity == 'F' }
  end

  def integer?(number)
    number.match(/^(\d)+$/)
  end

  def quantities_integer
    quantities.collect(&:to_i)
  end

  def not_negative?
    quantities_integer.select(&:negative?).none?
  end

  def less_than_or_equal_to_ten?
    quantities_integer.select { |quantity| quantity > 10 }.none?
  end

  def default_to_s
    quantities.map { |quantity| quantity == '10' ? 'X' : quantity }.join("\t")
  end
end
