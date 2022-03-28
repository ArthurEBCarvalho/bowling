require 'pry'

class Parser
  attr_reader :file

  EMPTY_FILE_ERROR_MESSAGE = 'The file cannot be empty'

  def initialize(file)
    @file = file

    validate!
  end

  def call
    skip_until = 0
    group_file.map do |name, rounds|
      pinfalls = []
      rounds   = rounds.map { |round| round.split("\t").last.delete("\r\n") }

      populate_pinfalls(pinfalls, rounds, skip_until)

      { name => pinfalls }
    end
  end

  private

  def validate!
    return unless group_file.empty?

    raise InvalidFile, EMPTY_FILE_ERROR_MESSAGE
  end

  def group_file
    @group_file ||= File.open(file).group_by { |line| line.split("\t").first }
  end

  def populate_pinfalls(pinfalls, rounds, skip_until)
    rounds.size.times do |index|
      next if skip_until > index

      skip_until = skip_until_next_index(rounds, index, pinfalls)
      pinfalls << round_pinfalls(rounds, index, pinfalls)
    end
  end

  def round_pinfalls(rounds, index, pinfalls)
    if last_but_one_round?(pinfalls)
      [rounds[index], rounds[index + 1], rounds[index + 2]]
    elsif rounds[index] == '10'
      [rounds[index]]
    else
      [rounds[index], rounds[index + 1]]
    end.compact
  end

  def last_but_one_round?(pinfalls)
    pinfalls.size == 9
  end

  def skip_until_next_index(rounds, index, pinfalls)
    index + round_pinfalls(rounds, index, pinfalls).size
  end
end
