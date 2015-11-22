require_relative 'model'
require_relative 'view'

class Array
  def difference(other)
    cpy = dup
    other.each do |e|
      ndx = cpy.index(e)
      cpy.delete_at(ndx) if ndx
    end
    cpy
  end
end

class GameCycler
  attr_accessor :continue
  def initialize
    @continue = nil
  end

  def game_factory
    Game.new(get_user_input)
  end

  def get_user_input
    @get_user_input ||= GetUserInput.new
  end

  def start
    Message::welcome_rules
    until self.continue == 'no'
      game_factory.do_game
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = get_user_input.play_again
      end
    end
    Message::exit
  end
end

class Game
  attr_accessor :current_guess, :turn_count, :get_user_input
  def initialize(get_user_input)
    @get_user_input = get_user_input
    @current_guess = nil
    @turn_count = 0
  end

  def board
    @board ||= Board.new
  end

  def codemaker
    @codemaker ||= CodeMaker.new(board)
  end

  def game_flow
    self.current_guess = get_user_input.get_code_guess(board.code_peg_colors)
    codemaker.key_peg_response(current_guess)
    puts "secret code: #{board.secret_code}"
    Display::board(board.board_array)
    self.turn_count += 1
  end

  def do_game
    board.secret_code = codemaker.random_peg_set
    until (turn_count == 10) || (board.secret_code == current_guess)
      game_flow
    end
    Message::you_lost(board.secret_code) if turn_count == 10
    Message::you_won(current_guess, turn_count) if board.secret_code == \
      current_guess
  end
end

class GetUserInput
  def play_again
    Prompt::play_again
  end

  def get_code_guess(code_peg_colors_hash)
    code_guess = []
    (1..4).each do |i|
      answer = nil
      answer = Prompt::get_code_guess(i, code_peg_colors_hash.keys) until \
        code_peg_colors_hash.keys.include?(answer)
      code_guess << code_peg_colors_hash[answer]
    end
    code_guess
  end
end

class CodeMaker
  attr_accessor :board
  def initialize(board)
    @board = board
  end

  def random_peg_set
    set = []
    4.times {set << board.code_peg_colors.values.sample}
    set
  end

  def black_peg_finder(guess_array)
    pegs = []
    guess_array.each_with_index do |peg, index|
      pegs << peg if peg == board.secret_code[index]
    end
    pegs
  end

  def white_peg_finder(guess_array, secret_code_diff)
    pegs = []
    guess_array.each do |peg|
      secret_index = secret_code_diff.index(peg)
      unless secret_index.nil?
        pegs << peg
        secret_code_diff.delete_at(secret_index)
      end
    end
    pegs
  end

  def key_peg_response(guess_array)
    black_pegs = black_peg_finder(guess_array)
    guess_array_diff = guess_array.difference(black_pegs)
    secret_code_diff = board.secret_code.difference(black_pegs)
    black_pegs.collect! {|peg| board.key_peg_colors["black"]}
    white_pegs = white_peg_finder(guess_array_diff, secret_code_diff)
    white_pegs.collect! {|peg| board.key_peg_colors["white"]}
    board.peg_placer(guess_array, black_pegs, white_pegs)
  end
end

### GAME STARTER ###
GameCycler.new.start