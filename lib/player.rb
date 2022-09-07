class Player
  attr_reader :team, :name

  def initialize(name, team)
    @name = name
    @team = team
  end
end
