require 'spec_helper'

describe Game do 
  
  g = Game.new(players: 4)
  
  it "creates a players hash" do
    expect(g.players.size).to eq(4) 
  end

  it "populates the total dice" do
    expect(g.total_dice_in_game).to eq(20)
  end

  it "creates an empty array for board" do
    expect(g.board).to eq([])
  end

  describe "move" do
    it "moves a players dice onto the board, and subtracts the players dice count, then rerolls" do
      g.move(player: 2, dice: 1, value: 3)
      expect(g.players[1][:dice_count]).to eq(4)
      expect(g.board.size).to be > 0
      expect(g.players[1][:updated_at]).not_to eq(nil)
    end
  end

  describe "claim" do
    it "has a correct probablity" do
      d = g.claim(dice: 5, value: 3)
      expect(d).to eq("11.646926278109309%")
    end
  end

  describe "challenge" do
    it "will determine if a claim is true or false" do
      expect(g.challenge(dice: 19, value: 2)).to be false
    end
  end

end 

