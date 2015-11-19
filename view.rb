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

  def self.board(board_hash)
    board_hash.each do |code_pegs, key_pegs|
      print peg_array_to_string(code_pegs, 2).rjust(75) + 
        "#{peg_array_to_string(key_pegs, 1)}\n\n".rjust(50)
    end
  end
end