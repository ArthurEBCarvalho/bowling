require 'spec_helper'
require 'serializers/players_serializer'
require 'models/player'
require 'models/pinfall'

RSpec.describe PlayersSerializer do
  subject { described_class.new([player_jeff, player_john]).call }

  let(:player_jeff) { Player.new('Jeff', pinfalls_jeff) }
  let(:pinfalls_jeff) do
    [
      Pinfall.new(['10']),
      Pinfall.new(%w[7 3]),
      Pinfall.new(%w[9 0]),
      Pinfall.new(['10']),
      Pinfall.new(%w[0 8]),
      Pinfall.new(%w[8 2]),
      Pinfall.new(%w[F 6]),
      Pinfall.new(['10']),
      Pinfall.new(['10']),
      Pinfall.new(%w[10 8 1])
    ]
  end

  let(:player_john) { Player.new('John', pinfalls_john) }
  let(:pinfalls_john) do
    [
      Pinfall.new(%w[3 7]),
      Pinfall.new(%w[6 3]),
      Pinfall.new(['10']),
      Pinfall.new(%w[8 1]),
      Pinfall.new(['10']),
      Pinfall.new(['10']),
      Pinfall.new(%w[9 0]),
      Pinfall.new(%w[7 3]),
      Pinfall.new(%w[4 4]),
      Pinfall.new(%w[10 9 0])
    ]
  end

  describe '#call' do
    let(:result) do
      "Frame\t\t1\t\t2\t\t3\t\t4\t\t5\t\t6\t\t7\t\t8\t\t9\t\t10\r\n"\
      "Jeff\r\n"\
      "Pinfalls\t\tX\t7\t/\t9\t0\t\tX\t0\t8\t8\t/\tF\t6\t\tX\t\tX\tX\t8\t1\r\n"\
      "Score\t\t20\t\t39\t\t48\t\t66\t\t74\t\t84\t\t90\t\t120\t\t148\t\t167\r\n"\
      "John\r\n"\
      "Pinfalls\t3\t/\t6\t3\t\tX\t8\t1\t\tX\t\tX\t9\t0\t7\t/\t4\t4\tX\t9\t0\r\n"\
      "Score\t\t16\t\t25\t\t44\t\t53\t\t82\t\t101\t\t110\t\t124\t\t132\t\t151"\
    end

    it { is_expected.to eq(result) }
  end
end
