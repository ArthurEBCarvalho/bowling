require 'spec_helper'
require 'services/parser'

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
      let(:painfalls) { [['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F'], ['F','F']] }

      it { is_expected.to eq([player]) }
    end
  end
end