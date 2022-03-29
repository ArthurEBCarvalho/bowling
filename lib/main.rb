require 'pry'
require_relative 'services/parser'
require_relative 'models/pinfall'
require_relative 'models/player'
require_relative 'serializers/players_serializer'

# Main file to perform all required steps
class Main
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    PlayersSerializer.new(build_players).call
  end

  private

  def build_players
    players_attributes.map { |attributes| Player.new(attributes.first, attributes[1..]) }
  end

  def players_attributes
    parse_file.map do |player|
      player.map do |name, rounds|
        [
          name,
          rounds.map do |quantities|
            Pinfall.new(quantities)
          end
        ]
      end.flatten
    end
  end

  def parse_file
    Parser.new(file).call
  end
end
