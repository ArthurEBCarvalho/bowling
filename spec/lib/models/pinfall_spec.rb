require 'spec_helper'
require 'models/pinfall'
require 'exceptions/invalid_record'

RSpec.describe Pinfall do
  subject { Pinfall.new(quantities) }

  describe 'validations' do
    context 'with right quantities' do
      let(:quantities) { [7, 2] }
      
      it { is_expected.to be_truthy }

      context 'with F as a quantity' do
        let(:quantities) { [7, 'F'] }

        it { is_expected.to be_truthy }
      end

      context 'with three quantities' do
        let(:quantities) { [7, 3, 8] }

        it { is_expected.to be_truthy }
      end
    end

    context 'with wrong quantities' do
      subject { -> { Pinfall.new(quantities) } }

      let(:amount_error_message) { 'Error: The amount must be F or be between 0 and 10' }
      let(:size_error_message) { 'Error: this round has only two moves' }

      context 'with three quantities' do
        let(:quantities) { [7, 2, 8] }

        it { is_expected.to raise_error(InvalidRecord, size_error_message) }
      end

      context 'with some not integer value' do
        let(:quantities) { [-1, 'A'] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end

      context 'with some negative value' do
        let(:quantities) { [-1, 2] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end

      context 'with some value greather than 10' do
        let(:quantities) { [7, 11] }

        it { is_expected.to raise_error(InvalidRecord, amount_error_message) }
      end
    end
  end
end