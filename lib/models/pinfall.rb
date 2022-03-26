require 'pry'
require 'exceptions/invalid_record'

class Pinfall
  attr_accessor :quantities

  AMOUNT_ERROR_MESSAGE = 'The amount must be F or be between 0 and 10'
  SIZE_ERROR_MESSAGE   = 'This round has exactly two moves'

  def initialize(quantities)
    @quantities = quantities

    update_fouls
    validate!
  end

  def total_falled_pins
    quantities.sum
  end

  def related_total_falled_pins
    return [quantities[0..1].sum, 10].min if three_times? # have to do a strike?

    quantities.sum
  end
  
  def strike?
    quantities.size == 1 && total_falled_pins == 10 ||
      quantities.size == 3 && quantities.first == 10
  end

  def spare?
    quantities.size == 2 && total_falled_pins == 10 ||
      quantities.size == 3 && quantities.first != 10
  end

  def three_times?
    quantities.size == 3
  end

  private

  def update_fouls
    quantities.collect! { |quantity| quantity == 'F' ? 0 : quantity }
  end

  def validate!
    size_validate!
    amount_validate!
  end

  def size_validate!
    return if right_size?

    raise InvalidRecord, SIZE_ERROR_MESSAGE
  end

  def right_size?
    quantities.size == 2 ||
      (quantities.size == 3 && quantities[0..1].sum >= 10) ||
      (quantities.size == 1 && quantities.first == 10)
  end

  def amount_validate!
    return if only_number? && not_negative? && less_than_or_equal_to_ten?
    
    raise InvalidRecord, AMOUNT_ERROR_MESSAGE
  end

  def only_number?
    quantities.all? { |quantity| quantity.is_a?(Integer) }
  end

  def not_negative?
    quantities.select(&:negative?).none?
  end

  def less_than_or_equal_to_ten?
    quantities.select { |quantity| quantity > 10 }.none?
  end
end
