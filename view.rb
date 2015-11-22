module Display
  def self.peg(color_code, peg_width)
    spaces = ""
    peg_width.times {spaces << " "}
    "\e[#{color_code}m#{spaces}\e[0m"
  end

  def self.peg_array_to_string(peg_array, peg_width)
    peg_string = ""
    peg_array.each do |p|
      peg_string << "#{peg(p, peg_width)} "
    end
    peg_string
  end

  def self.board(board_array)
    puts "Code pegs".rjust(38) + "      " + "Key pegs"
    board_array.each do |guess|
      guess.each do |code_pegs, key_pegs|
        print peg_array_to_string(code_pegs, 2).rjust(75) + " --  " + \
          "#{peg_array_to_string(key_pegs, 1)}\n\n"
      end
    end
  end
end

module Prompt
  def self.get_code_guess(choice_number, answer_choice_array)
    print "\nAvailable colors: #{answer_choice_array.join(", ")}\n"
    print "Enter the peg color for position #{choice_number} (Left to right): "
    gets.chomp.downcase
  end

  def self.play_again
    print "\nWould you like to play again? (yes/no): "
    gets.chomp.downcase
  end
end

module Message
  def self.welcome_rules
    print "\n\nWelcome to Mastermind, where codes are made and broken!\n\n"
    line
    print "RULES".rjust(25)
    line
    puts "The codemaker makes a code by choosing four colored pegs (out of "
    puts "six possible colors) in their chosen order. The codebreaker has 10"
    puts "turns to attempt to guess the correct colors in the correct order."
    puts "Each turn, the codebreaker is given feedback on their guess in the"
    puts "form of black and white key pegs. A black peg means a codebreaker's"
    puts "peg is the correct color and in the correct position. A white peg"
    puts "means a codebreaker's peg is the correct color but in the wrong"
    puts "position. The order of the key pegs is meaningless. It is up to the"
    puts "codebreaker to find the meaning behind the key pegs and solve the"
    puts "code in as few turns as possible."
    line
  end

  def self.line
    print "\n################################################\n"
  end

  def self.you_won(code_array, number_of_turns)
    print "\n\nYou cracked the code in #{number_of_turns} turns!"
    puts " You are a Mastermind!"
    print "Secret code: #{Display::peg_array_to_string(code_array, 2)}\n\n"
  end

  def self.you_lost(code_array)
    puts "\n\nYou failed to crack the code in the allowed number of tries.\n\n"
    print "Secret code: #{Display::peg_array_to_string(code_array, 2)}\n\n"
  end

  def self.exit
    print "\n\nThank you for playing Mastermind!\n\n"
  end
end