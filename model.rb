class Board
  attr_accessor :board_array, :secret_code
  def initialize
    @board_array = []
    @secret_code = nil
  end

  def code_peg_colors
    # ANSI codes
    {"red" => 41, "green" => 42, "yellow" => 43, "blue" => 44, "magenta" => 45,\
      "cyan" => 46}
  end

  def code_peg_permutations
    code_peg_colors.values.repeated_permutation(4).to_a
  end

  def key_peg_colors
    # ANSI codes
    {"white" => 47, "black" => 40}
  end

  def peg_placer(code_pegs, key_pegs)
    board_array << {code_pegs => key_pegs}
  end
end