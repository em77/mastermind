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
      answer = get_user_input.get_make_break_choice
      if answer == 'codemaker'
        game_factory.do_game_computer
      else
        game_factory.do_game_player
      end
      self.continue = nil
      until self.continue == 'yes' || self.continue == 'no'
        self.continue = get_user_input.play_again
      end
    end
    Message::exit
  end
end

class Game
  attr_accessor :current_guess, :turn_count, :get_user_input, \
    :current_key_pegs, :codemaker, :codebreaker
  def initialize(get_user_input)
    @get_user_input = get_user_input
    @current_guess = nil
    @current_key_pegs = nil
    @turn_count = 0
  end

  def board
    @board ||= Board.new
  end

  def codemaker_factory(computer)
    CodeMaker.new(board, computer)
  end

  def codebreaker_factory(codemaker)
    CodeBreaker.new(board, codemaker)
  end

  def game_flow_player
    self.current_guess = get_user_input.get_code(board.code_peg_colors)
    self.current_key_pegs = codemaker.key_peg_response(current_guess, \
      board.secret_code)
    board.peg_placer(current_guess, current_key_pegs)
    Display::board(board.board_array)
    self.turn_count += 1
  end

  def game_flow_computer
    if turn_count == 0
      self.current_guess = codebreaker.first_guess
    else
      get_user_input.do_next_computer_guess
      codebreaker.perm_cleanser(current_guess, current_key_pegs)
      self.current_guess = codebreaker.next_guess
    end
    self.current_key_pegs = codemaker.key_peg_response(current_guess, \
        board.secret_code)
    board.peg_placer(current_guess, current_key_pegs)
    Display::board(board.board_array)
    self.turn_count += 1
  end

  def end_game_messages_computer
    if turn_count == 10
      Message::computer_lost(board.secret_code)
    elsif board.secret_code == current_guess
      Message::computer_won(board.secret_code, turn_count)
    end
  end

  def end_game_messages_player
    if turn_count == 10
      Message::you_lost(board.secret_code)
    elsif board.secret_code == current_guess
      Message::you_won(current_guess, turn_count)
    end
  end

  def do_game_computer
    @codemaker = codemaker_factory(false)
    @codebreaker = codebreaker_factory(codemaker)
    board.secret_code = get_user_input.get_code(board.code_peg_colors)
    until (turn_count == 10) || (board.secret_code == current_guess)
      game_flow_computer
    end
    end_game_messages_computer
  end

  def do_game_player
   @codemaker = codemaker_factory(true)
    board.secret_code = codemaker.random_peg_set
    until (turn_count == 10) || (board.secret_code == current_guess)
      game_flow_player
    end
    end_game_messages_player
  end
end

class GetUserInput
  def play_again
    Prompt::play_again
  end

  def get_code(code_peg_colors_hash)
    code_guess = []
    (1..4).each do |i|
      answer = nil
      answer = Prompt::get_code(i, code_peg_colors_hash.keys) until \
        code_peg_colors_hash.keys.include?(answer)
      code_guess << code_peg_colors_hash[answer]
    end
    code_guess
  end

  def do_next_computer_guess
    Message::do_next_computer_guess
  end

  def get_make_break_choice
    answer = nil
    until (answer == 'codemaker') || (answer == 'codebreaker')
      answer = Prompt::get_make_break_choice
    end
    answer
  end
end

class CodeMaker
  attr_accessor :board, :computer
  def initialize(board, computer)
    @board = board
    @computer = computer
  end

  def random_peg_set
    set = []
    4.times {set << board.code_peg_colors.values.sample}
    set
  end

  def black_peg_finder(guess_array, secret_code)
    pegs = []
    guess_array.each_with_index do |peg, index|
      pegs << peg if peg == secret_code[index]
    end
    pegs
  end

  def white_peg_finder(guess_array, secret_code_diff)
    pegs = []
    guess_array.each do |peg|
      if secret_code_diff.include?(peg)
        pegs << peg
        secret_code_diff.delete(peg)
      end
    end
    pegs
  end

  def key_peg_response(guess_array, secret_code)
    black_pegs = black_peg_finder(guess_array, secret_code)
    guess_array_diff = guess_array.difference(black_pegs)
    secret_code_diff = secret_code.difference(black_pegs)
    black_pegs.collect! {|peg| board.key_peg_colors["black"]}
    white_pegs = white_peg_finder(guess_array_diff, secret_code_diff)
    white_pegs.collect! {|peg| board.key_peg_colors["white"]}
    black_pegs + white_pegs
  end
end

class CodeBreaker
  attr_accessor :perm, :board, :codemaker
  def initialize(board, codemaker)
    @board = board
    @codemaker = codemaker
    @perm = board.code_peg_permutations.shuffle!
  end

  def first_guess
    [41, 41, 42, 42]
  end

  def perm_cleanser(current_guess, key_pegs)
    new_perm = []
    perm.each do |p|
      if codemaker.key_peg_response(current_guess, p) == key_pegs
        new_perm << p
      end
    end
    self.perm = new_perm.dup
  end

  def next_guess
    perm[0]
  end
end

### GAME STARTER ###
GameCycler.new.start