require 'pry'

class ScoreCalculator
  attr_accessor :pinfalls, :score

  def initialize(pinfalls)
    @pinfalls = pinfalls
    @score    = []
  end

  def call
    populate_score_by_pinfalls

    score
  end

  private

  def populate_score_by_pinfalls
    pinfalls.size.times do |index|
      update_pred_score(index) if index.positive?

      score[index] = score[index - 1].to_i + current_pinfall(index).total_falled_pins
    end
  end

  def update_pred_score(index)
    score[index - 1] += related_total_falled_pins(index) if pred_pinfall(index).strike?
    score[index - 1] += current_pinfall(index).quantities.first if pred_pinfall(index).spare?
  end

  def pred_pinfall(index)
    pinfalls[index - 1]
  end

  def current_pinfall(index)
    pinfalls[index]
  end

  def next_pinfall(index)
    pinfalls[index + 1] || build_next_pinfal(index)
  end

  def build_next_pinfal(index)
    total_falled_pins = current_pinfall(index).strike? ? current_pinfall(index).quantities[1] : 0

    Pinfall.new([total_falled_pins, 0])
  end

  def related_total_falled_pins(index)
    if current_pinfall(index).strike? || current_pinfall(index).three_times?
      current_pinfall(index).related_total_falled_pins + next_pinfall(index).related_total_falled_pins
    else
      current_pinfall(index).related_total_falled_pins
    end
  end
end
