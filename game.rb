require 'rubygems'
require 'faker'
require 'dice'
require 'pry'
  
class Game
  attr_reader :players, :player, :total_dice_in_game, :board

  def initialize(args)
    @ids = (1..args[:players]).to_a
    @players = []
    create_player_hash
    @total_dice_in_game = @players.map { |player| player[:hand].size }.reduce(&:+)
    @board = []
  end 

  def move(args)
    player = @players[args[:player] - 1]
    number_of_dice = args[:dice]
    value_of_dice = args[:value]
    hash = { player_id: player[:id], number_of_dice_played: number_of_dice, value_of_dice_played: value_of_dice  }
    @board.push(hash)
    dice_left = player[:dice_count] - number_of_dice
    player[:hand] = Dice.new(6, dice_left, true).roll
    player[:dice_count] = dice_left 
    update_total_dice!
  end

  def claim(args)
    dice = args[:dice]
    calc(dice, @total_dice_in_game) + calc(@total_dice_in_game, @total_dice_in_game)
  end


#game.move(player: 1, dice: 2, value: 3)
private
  
  def fac(n)
    (1..n).reduce(:*) 
  end

  def calc(n, k)
    fac(n) / (fac(k) * fac(n - k)) * (1.0/6.0)**k * 5.0/6.0**(n-k)
  end  

  #n! / k! (n - k)! * (1/6)^k * 5/6^(n-k)

  def update_total_dice!
    @total_dice_in_game = @players.map { |player| player[:hand].size }.reduce(&:+)
  end
  
  def create_player_hash
    @ids.each do |f|
      hash = { id: f, name: Faker::Name.first_name, dice_count: 5, hand: Dice.new(6, 5, true).roll  }
      @players.push(hash)
    end
  end

end
