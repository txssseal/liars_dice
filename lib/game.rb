require 'faker'
require 'dice'

class Game
  attr_reader :players, :player, :total_dice_in_game, :board, :dice_bag

  def initialize(args)
    @ids = (1..args[:players]).to_a
    @players = []
    create_player_hash
    @total_dice_in_game = @players.map { |player| player[:hand].size }.reduce(&:+)
    @board = []
    @dice_bag =  @players.map { |player| player[:hand] }.flatten.sort
  end 
  
  #Find the player by id, creates a hash of there move, and pushes it to the board.
  #it then calculates how many dice the player has left and updates it, and rerolls the remaining dice
  #finally it updates the total_dice in play and dice_bag
  def move(args)
    player = @players[args[:player] - 1]
    hash = { player_id: player[:id], number_of_dice_played: args[:dice], value_of_dice_played: args[:value], created_at: Time.now  }
    @board.push(hash)
    dice_left = player[:dice_count] - args[:dice]
    player[:hand] = Dice.new(6, dice_left, true).roll
    player[:dice_count] = dice_left
    player[:updated_at] = Time.now 
    update_total_dice
    update_dice_bag
  end
  
  #I believe my calculations are correct
  def claim(args)
    "#{calc(@total_dice_in_game, args[:dice]) + calc(@total_dice_in_game, @total_dice_in_game)}%"
  end
  
  #this is comparing a claim to dice in the dice bag.
  #only taking into account if it exactly equals number in dice bag.
  def challenge(args)
    @dice_bag.select { |d| d == args[:value] }.size == args[:dice]
  end  

private
  
  def fac(n)
    (1..n).reduce(:*) || 1 
  end
  
  #n! / k! (n - k)! * (1/6)^k * 5/6^(n-k)
  def calc(n, k)
    fac(n) / (fac(k) * fac(n - k)) * ((1.0/6.0)**k * (5.0/6.0)**(n-k)) * 100
  end  
  
  def update_total_dice
    @total_dice_in_game = @players.map { |player| player[:hand].size }.reduce(&:+)
  end

  def update_dice_bag
    @dice_bag = @players.map { |player| player[:hand] }.flatten.sort
  end
  
  #this is creating a player hashtable.  Each player has a unique id, a name, dice_count, dice roll, created_at, and updated_at keys
  def create_player_hash
    @ids.each do |f|
      hash = { id: f, name: Faker::Name.first_name, dice_count: 5, hand: Dice.new(6, 5, true).roll, created_at: Time.now, updated_at: nil }
      @players.push(hash)
    end
  end

end
