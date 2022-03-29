require 'spec_helper'
require 'main'
require 'exceptions/invalid_record'
require 'exceptions/invalid_file'

RSpec.describe Main do
  subject(:call) { described_class.new(file).call }

  context 'when input file is valid' do
    context 'with two players' do
      let(:file) { file_fixture('scores.txt') }
      let(:result) do
        "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\r\n"\
        "Jeff\r\n"\
        "Pinfalls\t\tX\t7\t/\t9\t0\t\tX\t0\t8\t8\t/\tF\t6\t\tX\t\tX\tX\t8\t1\r\n"\
        "Score\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\r\n"\
        "John\r\n"\
        "Pinfalls\t3\t/\t6\t3\t\tX\t8\t1\t\tX\t\tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\r\n"\
        "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151"
      end

      it { is_expected.to eq(result) }
    end

    context 'with more than two players' do
      let(:file) { file_fixture('three-players.txt') }
      let(:result) do
        "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\r\n"\
        "Jeff\r\n"\
        "Pinfalls\t\tX\t7\t/\t9\t0\t\tX\t0\t8\t8\t/\tF\t6\t\tX\t\tX\tX\t8\t1\r\n"\
        "Score\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\r\n"\
        "John\r\n"\
        "Pinfalls\t3\t/\t6\t3\t\tX\t8\t1\t\tX\t\tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\r\n"\
        "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151\r\n"\
        "Carl\r\n"\
        "Pinfalls\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\tX\tX\r\n"\
        "Score\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300"
      end

      it { is_expected.to eq(result) }
    end

    context 'with strikes in all throwings' do
      let(:file) { file_fixture('perfect.txt') }
      let(:result) do
        "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\r\n"\
        "Carl\r\n"\
        "Pinfalls\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\t\tX\tX\tX\tX\r\n"\
        "Score\t\t30\t\t60\t\t90\t\t120\t\t150\t\t180\t\t210\t\t240\t\t270\t\t300"
      end

      it { is_expected.to eq(result) }
    end

    context 'with fouls in all throwings' do
      let(:file) { file_fixture('full-fouls.txt') }
      let(:result) do
        "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\r\n"\
        "Carl\r\n"\
        "Pinfalls\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\tF\r\n"\
        "Score\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0\t\t0"
      end

      it { is_expected.to eq(result) }
    end
  end

  context 'when input file is invalid' do
    let(:amount_error_message) { 'Error: The amount must be F or be between 0 and 10' }
    let(:size_error_message) { 'Error: The player must have exactly 10 rounds' }
    let(:file_error_message) { 'Error: The file cannot be empty' }

    context 'with invalid characters present' do
      let(:file) { file_fixture('free-text.txt') }

      it { expect { call }.to raise_error(InvalidRecord, amount_error_message) }
    end

    context 'with invalid score' do
      let(:file) { file_fixture('invalid-score.txt') }

      it { expect { call }.to raise_error(InvalidRecord, amount_error_message) }
    end

    context 'with negative score' do
      let(:file) { file_fixture('negative.txt') }

      it { expect { call }.to raise_error(InvalidRecord, amount_error_message) }
    end

    context 'with empty file' do
      let(:file) { file_fixture('empty.txt') }

      it { expect { call }.to raise_error(InvalidFile, file_error_message) }
    end

    context 'with invalid number of throwings' do
      let(:file) { file_fixture('extra-score.txt') }

      it { expect { call }.to raise_error(InvalidRecord, size_error_message) }
    end
  end
end
