require 'spec_helper'
require 'services/parser'
require 'exceptions/invalid_record'

RSpec.describe Parser do
  subject(:call) { described_class.new(file).call }

  let(:file) { file_fixture('scores.txt') }
  let(:player_jeff) do
    { 'Jeff' => [['10'], %w[7 3], %w[9 0], ['10'], %w[0 8], %w[8 2], %w[F 6], ['10'], ['10'], %w[10 8 1]] }
  end
  let(:player_john) do
    { 'John' => [%w[3 7], %w[6 3], ['10'], %w[8 1], ['10'], ['10'], %w[9 0], %w[7 3], %w[4 4], %w[10 9 0]] }
  end

  describe '#call' do
    it { is_expected.to eq([player_jeff, player_john]) }

    context 'with only two times on the last round' do
      let(:file) { file_fixture('full-fouls.txt') }
      let(:player) { { 'Carl' => painfalls } }
      let(:painfalls) do
        [%w[F F], %w[F F], %w[F F], %w[F F], %w[F F], %w[F F], %w[F F], %w[F F], %w[F F], %w[F F]]
      end

      it { is_expected.to eq([player]) }
    end

    context 'with extra score' do
      let(:file) { file_fixture('extra-score.txt') }
      let(:player) { { 'Carl' => painfalls } }
      let(:painfalls) do
        [['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], %w[10 10 10], %w[7 2]]
      end

      it { is_expected.to eq([player]) }
    end

    context 'with empty file' do
      let(:file) { file_fixture('empty.txt') }
      let(:error_message) { 'Error: The file cannot be empty' }

      it { expect { call }.to raise_error(InvalidFile, error_message) }
    end
  end
end
