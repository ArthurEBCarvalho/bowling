require 'spec_helper'
require 'services/score_calculator'
require 'models/pinfall'

RSpec.describe ScoreCalculator do
  subject { ScoreCalculator.new(pinfalls).call }

  let(:pinfalls) do
    [
      Pinfall.new(['10']),
      Pinfall.new(['7', '3']),
      Pinfall.new(['9', '0']),
      Pinfall.new(['10']),
      Pinfall.new(['0', '8']),
      Pinfall.new(['8', '2']),
      Pinfall.new(['F', '6']),
      Pinfall.new(['10']),
      Pinfall.new(['10']),
      last_pinfall
    ]
  end

  describe '.call' do
    context 'with a strike in the last round' do
      let(:last_pinfall) { Pinfall.new(['10', '8', '1']) }

      it { is_expected.to eq([20, 39, 48, 66, 74, 84, 90, 120, 148, 167]) }
    end

    context 'with a spare in the last round' do
      let(:last_pinfall) { Pinfall.new(['7', '3', '1']) }

      it { is_expected.to eq([20, 39, 48, 66, 74, 84, 90, 120, 140, 151]) }
    end

    context 'with only two times in the end' do
      let(:last_pinfall) { Pinfall.new(['8', '1']) }

      it { is_expected.to eq([20, 39, 48, 66, 74, 84, 90, 119, 138, 147]) }
    end
  end
end