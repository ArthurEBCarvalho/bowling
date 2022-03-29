require 'spec_helper'
require 'models/pinfall'
require 'exceptions/invalid_record'

RSpec.describe Pinfall do
  subject(:build) { described_class.new(quantities) }

  let(:quantities) { %w[7 2] }

  describe 'validations' do
    let(:amount_error_message) { 'Error: The amount must be F or be between 0 and 10' }
    let(:size_error_message)   { 'Error: This round has exactly two moves' }

    context 'with two numbers before ten' do
      it { is_expected.to be_truthy }
    end

    context 'with F as a quantity' do
      let(:quantities) { %w[7 F] }

      it { is_expected.to be_truthy }
    end

    context 'with three correct quantities' do
      let(:quantities) { %w[7 3 8] }

      it { is_expected.to be_truthy }
    end

    context 'with one quantity' do
      let(:quantities) { ['10'] }

      it { is_expected.to be_truthy }
    end

    context 'with three wrong quantities' do
      let(:quantities) { %w[7 2 8] }

      it { expect { build }.to raise_error(InvalidRecord, size_error_message) }
    end

    context 'with one quantities' do
      let(:quantities) { ['9'] }

      it { expect { build }.to raise_error(InvalidRecord, size_error_message) }
    end

    context 'with some not integer value' do
      let(:quantities) { ['-1', 'A'] }

      it { expect { build }.to raise_error(InvalidRecord, amount_error_message) }
    end

    context 'with some negative value' do
      let(:quantities) { ['-1', '2'] }

      it { expect { build }.to raise_error(InvalidRecord, amount_error_message) }
    end

    context 'with some value greather than 10' do
      let(:quantities) { %w[7 11] }

      it { expect { build }.to raise_error(InvalidRecord, amount_error_message) }
    end
  end

  describe '#total_falled_pins' do
    subject { described_class.new(quantities).total_falled_pins }

    it { is_expected.to eq(9) }
  end

  describe '#related_total_falled_pins' do
    subject { described_class.new(quantities).related_total_falled_pins }

    it { is_expected.to eq(9) }

    context 'with a strike and has three times' do
      let(:quantities) { %w[10 8 1] }

      it { is_expected.to eq(10) }
    end

    context 'with a spare and has three times' do
      let(:quantities) { %w[7 3 1] }

      it { is_expected.to eq(10) }
    end
  end

  describe '#strike?' do
    subject { described_class.new(quantities).strike? }

    it { is_expected.to be_falsey }

    context 'with only one quantity and total_falled_pins 10' do
      let(:quantities) { ['10'] }

      it { is_expected.to be_truthy }
    end

    context 'with three times but without a ten' do
      let(:quantities) { %w[7 3 1] }

      it { is_expected.to be_falsey }
    end

    context 'with three times and a ten' do
      let(:quantities) { %w[10 8 1] }

      it { is_expected.to be_truthy }
    end
  end

  describe '#spare?' do
    subject { described_class.new(quantities).spare? }

    it { is_expected.to be_falsey }

    context 'when the total_falled_pins is 10' do
      let(:quantities) { %w[7 3] }

      it { is_expected.to be_truthy }
    end

    context 'with three times and with a ten' do
      let(:quantities) { %w[10 8 1] }

      it { is_expected.to be_falsey }
    end

    context 'with three times but without a ten' do
      let(:quantities) { %w[7 3 1] }

      it { is_expected.to be_truthy }
    end
  end

  describe '#three_times?' do
    subject { described_class.new(quantities).three_times? }

    it { is_expected.to be_falsey }

    context 'when the total_falled_pins is 10' do
      let(:quantities) { %w[10 8 1] }

      it { is_expected.to be_truthy }
    end
  end

  describe 'to_s' do
    subject { described_class.new(quantities).to_s }

    it { is_expected.to eq("7\t2") }

    context 'when is strike' do
      let(:quantities) { ['10'] }

      it { is_expected.to eq("\tX") }
    end

    context 'when is spare' do
      let(:quantities) { %w[7 3] }

      it { is_expected.to eq("7\t/") }
    end

    context 'with three times' do
      let(:quantities) { %w[10 8 1] }

      it { is_expected.to eq("X\t8\t1") }
    end

    context 'with foul' do
      let(:quantities) { %w[F 6] }

      it { is_expected.to eq("F\t6") }
    end
  end
end
