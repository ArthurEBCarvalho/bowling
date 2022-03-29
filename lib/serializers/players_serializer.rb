require 'pry'

# Serializer to print final score in correct format
class PlayersSerializer
  attr_reader :players, :lines

  def initialize(players)
    @players = players
    @lines   = [%w[Frame 1 2 3 4 5 6 7 8 9 10].join("\t\t")]
  end

  def call
    players.each do |player|
      lines << player.name
      lines << pinfalls(player)
      lines << score(player)
    end

    lines.join("\r\n")
  end

  private

  def pinfalls(player)
    "Pinfalls\t#{player.pinfalls.map(&:to_s).join("\t")}"
  end

  def score(player)
    "Score\t\t#{player.scores.join("\t\t")}"
  end
end
