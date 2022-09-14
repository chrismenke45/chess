class Player
  attr_reader :team, :name, :computer

  def initialize(name, team, computer = false)
    @name = name
    @team = team
    @computer = computer
  end

  def to_object
    {
      name: @name,
      team: @team,
      computer: @computer,
    }
  end
end
