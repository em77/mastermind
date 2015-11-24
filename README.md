## Mastermind in Ruby (with AI)
#### Where codes are made and broken!

This is a command-line based Mastermind game written in Ruby where
the player can either attempt to break a computer-generated code or
create a code that the computer breaks. The AI implements Swaszek's
algorithm[^cite] for code breaking in less than 5 turns on average.

####RULES
The codemaker makes a code by choosing four colored pegs (out of 
six possible colors) in their chosen order. The codebreaker has 10
turns to attempt to guess the correct colors in the correct order.
Colors can be used any number of times (e.g. green-green-green-green
is a possibility). Each turn, the codebreaker is given feedback on
their guess in the form of black and white key pegs. A black peg
means a codebreaker's peg is the correct color and in the correct
position. A white peg means a codebreaker's peg is the correct color
but in the wrong position. The order of the key pegs is meaningless.
It is up to the codebreaker to find the meaning behind the key pegs
and solve the code in as few turns as possible.

To run the game, enter `ruby controller.rb` at your command-line.

[^cite]: P.F. Swaszek. The mastermind novice. *Journal of Recreational Mathematics*,
30(3):193–198, 2000.