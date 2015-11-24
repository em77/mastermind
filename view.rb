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

  def self.secret_code(secret_code)
    print "Secret code: #{Display::peg_array_to_string(secret_code, 2)}\n\n"
  end
end

module Prompt
  def self.get_code(choice_number, answer_choice_array)
    print "\nAvailable colors: #{answer_choice_array.join(", ")}\n"
    print "Enter the peg color for position #{choice_number} (Left to right): "
    gets.chomp.downcase
  end

  def self.play_again
    print "\nWould you like to play again? (yes/no): "
    gets.chomp.downcase
  end

  def self.get_make_break_choice
    print "\n\nWould you like to be the codemaker or codebreaker?\n"
    print "Enter your choice (codemaker/codebreaker): "
    gets.chomp.downcase
  end
end

module Message
  def self.welcome_rules
    print "\n\nWelcome to Mastermind, where codes are made and broken!\n\n"
    line
    print "RULES".rjust(25)
    line
    puts "The codemaker makes a code by choosing four colored pegs (out of"
    puts "six possible colors) in their chosen order. The codebreaker has 10"
    puts "turns to attempt to guess the correct colors in the correct order."
    puts "Colors can be used any number of times (e.g. green-green-green-green"
    puts "is a possibility). Each turn, the codebreaker is given feedback on"
    puts "their guess in the form of black and white key pegs. A black peg"
    puts "means a codebreaker's peg is the correct color and in the correct"
    puts "position. A white peg means a codebreaker's peg is the correct color"
    puts "but in the wrong position. The order of the key pegs is meaningless."
    puts "It is up to the codebreaker to find the meaning behind the key pegs"
    puts "and solve the code in as few turns as possible."
    line
  end

  def self.line
    print "\n################################################\n"
  end

  def self.do_next_computer_guess
    print "\n\nPress enter to have the computer make its next guess...\n"
    gets
  end

  def self.computer_lost(secret_code)
    print "\n\nYou somehow stumped the computer and won! Congrats!\n"
    Display::secret_code(secret_code)
  end

  def self.computer_won(secret_code, turn_count)
    print "\n\nThe computer cracked the code in #{turn_count} turns!\n"
    Display::secret_code(secret_code)
  end

  def self.you_won(secret_code, turn_count)
    print "\n\nYou cracked the code in #{turn_count} turns!"
    puts " You are a Mastermind!"
    Display::secret_code(secret_code)
  end

  def self.you_lost(secret_code)
    puts "\n\nYou failed to crack the code in the allowed number of tries.\n"
    Display::secret_code(secret_code)
    puts
  end

  def self.exit
    print "\n\nThank you for playing Mastermind!\n\n"
  end
end