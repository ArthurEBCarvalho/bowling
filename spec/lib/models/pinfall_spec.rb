require 'spec_helper'
require 'models/pinfall'
require 'exceptions/invalid_record'

RSpec.describe Pinfall do
  subject { pinfall }

  let(:quantities) { ['7', '2'] }
  let(:pinfall) { Pinfall.new(quantities) }

  describe 'validations' do
    context 'with right quantities' do
      it { is_expected.to be_truthy }

      context 'with F as a quantity' do
        let(:quantities) { ['7', 'F'] }

        it { is_expected.to be_truthy }
      end

      context 'with three quantities' do
        let(:quantities) { ['7', '3', '8'] }

        it { is_expected.to be_truthy }
      end

      context 'with one quantity' do
        let(:quantities) { ['10'] }

        it { is_expected.to be_truthy }
      end
    end

    context 'with wrong quantities' do
      subject { -> { Pinfall.new(quantities) } }

      let(:amount_error_message) { 'Error: The amount must be F or be between 0 and 10' }
      let(:size_error_message)   { 'Error: This round has exactly two moves' }

      context 'with three quantities' do
        let(:quantities) { ['7', '2', '8'] }

        it { is_expected.to raise_error(InvalidRecord, size_error_message) }
      end

      context 'with one quantities' do
        let(:quantities) { ['9'] }

        it { is_expected.to raise_error(InvalidRecord, size_error_message) }
      end

      context 'with some not integer value' do
        let(:quantities) { ['-1', 'A'] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end

      context 'with some negative value' do
        let(:quantities) { ['-1', '2'] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end

      context 'with some value greather than 10' do
        let(:quantities) { ['7', '11'] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end
    end
  end
  
  describe '#total_falled_pins' do
    subject { pinfall.total_falled_pins }

    it { is_expected.to eq(9) }
  end

  describe '#related_total_falled_pins' do
    subject { pinfall.related_total_falled_pins }

    it { is_expected.to eq(9) }

    context 'with three times' do
      context 'when the first time is a strike' do
        let(:quantities) { ['10', '8', '1'] }
  
        it { is_expected.to eq(10) }
      end

      context 'with a spare' do
        let(:quantities) { ['7', '3', '1'] }
  
        it { is_expected.to eq(10) }
      end
    end
  end

  describe '#strike?' do
    subject { pinfall.strike? }

    it { is_expected.to be_falsey }

    context 'with only one quantity and total_falled_pins 10' do
      let(:quantities) { ['10'] }

      it { is_expected.to be_truthy }
    end

    context 'with three times' do
      let(:quantities) { ['7', '3', '1'] }

      it { is_expected.to be_falsey }

      context 'with the first time is 10' do
        let(:quantities) { ['10', '8', '1'] }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#spare?' do
    subject { pinfall.spare? }

    it { is_expected.to be_falsey }

    context 'when the total_falled_pins is 10' do
      let(:quantities) { ['7', '3'] }

      it { is_expected.to be_truthy }
    end

    context 'with three times' do
      let(:quantities) { ['10', '8', '1'] }
      
      it { is_expected.to be_falsey }
      
      context 'with with the first time is not 10' do
        let(:quantities) { ['7', '3', '1'] }

        it { is_expected.to be_truthy }
      end
    end
  end

  describe '#three_times?' do
    subject { pinfall.three_times? }
    
    it { is_expected.to be_falsey }

    context 'when the total_falled_pins is 10' do
      let(:quantities) { ['10', '8', '1'] }

      it { is_expected.to be_truthy }
    end
  end
end