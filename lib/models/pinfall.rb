require 'pry'

class Pinfall
  attr_accessor :quantities

  AMOUNT_ERROR_MESSAGE = 'Error: The amount must be F or be between 0 and 10'
  SIZE_ERROR_MESSAGE   = 'Error: this round has only two moves'

  def initialize(quantities)
    @quantities = quantities

    update_fouls
    validate!
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
    return if quantities.size == 2 || (quantities.size == 3 && quantities[0..1].sum >= 10)

    raise StandardError, SIZE_ERROR_MESSAGE
  end

  def amount_validate!
    return if only_number? && not_negative? && less_than_or_equal_to_ten?
    
    raise StandardError, AMOUNT_ERROR_MESSAGE
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
