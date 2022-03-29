require 'spec_helper'
require 'models/player'
require 'models/pinfall'
require 'exceptions/invalid_record'

RSpec.describe Player do
  let(:name) { 'Arthur' }
  let(:quantity) { 10 }
  let(:pinfalls) { quantity.times.map { Pinfall.new(%w[7 2]) } }

  describe 'validations' do
    subject(:build) { described_class.new(name, pinfalls) }

    let(:name_error_message) { 'Error: The player must have a name' }
    let(:size_error_message) { 'Error: The player must have exactly 10 rounds' }

    context 'with correct attributes' do
      it { is_expected.to be_truthy }
    end

    context 'when the player has not ten rounds' do
      let(:quantity) { 9 }

      it { expect { build }.to raise_error(InvalidRecord, size_error_message) }
    end

    context 'without name' do
      let(:name) { nil }

      it { expect { build }.to raise_error(InvalidRecord, name_error_message) }
    end

    context 'with name as a number' do
      let(:name) { 1 }

      it { expect { build }.to raise_error(InvalidRecord, name_error_message) }
    end
  end

  describe '#scores' do
    subject(:scores) { described_class.new(name, pinfalls).scores }

    it { expect(scores).to eq([9, 18, 27, 36, 45, 54, 63, 72, 81, 90]) }
  end
end
