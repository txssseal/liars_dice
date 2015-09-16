## liars_dice

clone the repo

`bundle`

launch a pry or irb session

`require './lib/game.rb'`

````

game = Game.new(players: 4)
game.move(player: 1, dice: 2, value: 3)
game.move(player: 2, dice: 1, value: 3)
game.claim(dice: 19, value: 3)
game.challenge(dice: 19, value: 3)

````
