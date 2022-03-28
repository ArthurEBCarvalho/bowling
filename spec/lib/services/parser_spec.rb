require 'spec_helper'
require 'services/parser'
require 'exceptions/invalid_record'

RSpec.describe Parser do
  subject { Parser.new(file).call }

  let(:file) { file_fixture('scores.txt') }
  let(:player_jeff) { { 'Jeff' => jeff_painfalls } }
  let(:jeff_painfalls) { [['10'], ['7', '3'], ['9', '0'], ['10'], ['0', '8'], ['8', '2'], ['F', '6'], ['10'], ['10'], ['10', '8', '1']] }
  let(:player_john) { { 'John' => john_painfalls } }
  let(:john_painfalls) { [['3', '7'], ['6', '3'], ['10'], ['8', '1'], ['10'], ['10'], ['9', '0'], ['7', '3'], ['4', '4'], ['10', '9', '0']] }

  describe '#call' do
    it { is_expected.to eq([player_jeff, player_john]) }

    context 'with only two times on the last round' do
      let(:file) { file_fixture('full-fouls.txt') }
      let(:player) { { 'Carl' => painfalls } }
      let(:painfalls) { [['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F'], ['F', 'F']] }

      it { is_expected.to eq([player]) }
    end

    context 'with extra score' do
      let(:file) { file_fixture('extra-score.txt') }
      let(:player) { { 'Carl' => painfalls } }
      let(:painfalls) { [['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10'], ['10', '10', '10'], ['7', '2']] }

      it { is_expected.to eq([player]) }
    end

    context 'with empty file' do
      subject { -> { Parser.new(file).call } }

      let(:file) { file_fixture('empty.txt') }
      let(:error_message) { 'Error: The file cannot be empty' }

      it { is_expected.to raise_error(InvalidRecord, error_message) }
    end
  end
end