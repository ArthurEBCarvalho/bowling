require 'pry'

class Parser
  attr_reader :file

  def initialize(file)
    @file = file
  end

  def call
    skip_next = false
    group_file.map do |name, rounds|
      pinfalls = []
      rounds   = rounds.map { |round| round.split("\t").last.delete("\r\n") }

      populate_pinfalls(pinfalls, rounds, skip_next)

      { name => pinfalls }
    end
  end

  private

  def group_file
    File.open(file).group_by { |line| line.split("\t").first }
  end

  def populate_pinfalls(pinfalls, rounds, skip_next)
    rounds.size.times do |index|
      if skip_next || last_round?(pinfalls)
        skip_next = false
        next
      end

      skip_next = skip_next?(rounds, index, pinfalls)
      pinfalls << round_pinfalls(rounds, index, pinfalls)
    end
  end

  def last_round?(pinfalls)
    pinfalls.size == 10
  end

  def round_pinfalls(rounds, index, pinfalls)
    if last_but_one_round?(pinfalls)
      [rounds[index], rounds[index + 1], rounds[index + 2]].compact
    elsif rounds[index] == '10'
      [rounds[index]]
    else
      [rounds[index], rounds[index + 1]]
    end
  end

  def last_but_one_round?(pinfalls)
    pinfalls.size == 9
  end

  def skip_next?(rounds, index, pinfalls)
    !last_but_one_round?(pinfalls) && rounds[index] != '10'
  end
end
