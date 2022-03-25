require 'spec_helper'
require 'models/player'
require 'exceptions/invalid_record'

RSpec.describe Player do
  subject { Player.new(name, pinfalls) }

  describe 'validations' do
    let(:name) { 'Arthur' }
    let(:quantity) { 10 }
    let(:pinfalls) { quantity.times.map { [7, 2] } }

    context 'with right attributes' do
      it { is_expected.to be_truthy }
    end

    context 'with wrong quantities' do
      subject { -> { Player.new(name, pinfalls) } }

      let(:name_error_message) { 'Error: The player must have a name' }
      let(:size_error_message) { 'Error: The player must have exactly 10 rounds' }

      context 'when the player has not ten rounds' do
        let(:quantity) { 9 }

        it { is_expected.to raise_error(InvalidRecord, size_error_message) }
      end

      context 'without name' do
        let(:name) { nil }

        it { is_expected.to raise_error(InvalidRecord, name_error_message) }
      end

      context 'with name as a number' do
        let(:name) { 1 }

        it { is_expected.to raise_error(InvalidRecord, name_error_message) }
      end
    end
  end
end