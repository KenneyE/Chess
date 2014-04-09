class Board

  attr_accessor :squares, :player1_color, :player2_color

  def initialize(player1_color, player2_color, init_board = true)
    @squares = Array.new(8) { Array.new( 8, nil ) }
    @player1_color = player1_color
    @player2_color = player2_color

    initialize_squares(player1_color, player2_color) if init_board
  end

  def initialize_squares(player1_color, player2_color)
    (0..7).each do |j|
      self[[1, j]] = Pawn.new([1, j], self, player2_color)
      self[[6, j]] = Pawn.new([6, j], self, player1_color)
    end

    self[[0, 1]] = Knight.new([0,1], self, player2_color)
    self[[0, 0]] = Rook.new([0,0], self, player2_color)
    self[[0, 2]] = Bishop.new([0,2], self, player2_color)
    self[[0, 3]] = Queen.new([0,3], self, player2_color)
    self[[0, 4]] = King.new([0,4], self, player2_color)
    self[[0, 5]] = Bishop.new([0,5], self, player2_color)
    self[[0, 6]] = Knight.new([0,6], self, player2_color)
    self[[0, 7]] = Rook.new([0,7], self, player2_color)

    self[[7, 0]] = Rook.new([7,0], self, player1_color)
    self[[7, 1]] = Knight.new([7,1], self, player1_color)
    self[[7, 2]] = Bishop.new([7,2], self, player1_color)
    self[[7, 3]] = Queen.new([7,3], self, player1_color)
    self[[7, 4]] = King.new([7,4], self, player1_color)
    self[[7, 5]] = Bishop.new([7,5], self, player1_color)
    self[[7, 6]] = Knight.new([7,6], self, player1_color)
    self[[7, 7]] = Rook.new([7,7], self, player1_color)

  end

  def [](pos)
    @squares[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @squares[pos[0]][pos[1]] = val
  end


  def get_color_pieces(color)
     pieces = self.squares.flatten.compact.select{ |piece| piece.color == color }
   end

   def get_all_pieces
     pieces = self.squares.flatten.compact
   end

  def find_piece(color, target_piece)

    get_color_pieces(color).each do |piece|
      return piece.position if piece.is_a?(target_piece)
    end

    nil
  end

  def dup
    new_board = Board.new(self.player1_color, self.player2_color, false)
    get_all_pieces.each do |piece|
      new_board[piece.position] = piece.piece_dup(new_board)
    end

    new_board
  end

  def move_into_check?(from, to)
    #puts "MOVE INTO CHECK? FROM: #{from}   TO: #{to}"
    new_board = self.dup
    new_board.move_piece(from, to)
    color = self[from].color
    new_board.in_check?(color)
  end

  def in_check?(color)
    king_pos = find_piece(color, King)
    in_check = false

    get_color_pieces(color).each do |piece|
      possible_moves = piece.moves
      in_check = possible_moves.include?(king_pos)
    end
    in_check
  end

  def move_piece(from, to)

    self[to].board = nil unless self[to].nil?

    piece = self[from]
    # p piece
    piece.position = to
    self[to]=piece
    self[from] = nil
  end

  def to_s
    s = "  A B C D E F G H\n"
    self.squares.each_with_index do |row, i|
      s += (8 - i).to_s + " "
      row.each_with_index do |col, j|
      #  if self[[i,j]].cursor
      #    s += CURSOR + " "
      #  else
          s += "- " if self[[i, j]].nil?
          s += self[[i,j]].symbol + " " unless self[[i,j]].nil?
      #  end
      end
      s += "\n"
    end
    s
  end

  def color_map
    s = "  A B C D E F G H\n"
    self.squares.each_with_index do |row, i|
      s += (8 - i).to_s + " "
      row.each_with_index do |col, j|
      #  if self[[i,j]].cursor
      #    s += CURSOR + " "
      #  else
          s += "- " if self[[i, j]].nil?
          next if self[[i, j]].nil?
          s += "W" if self[[i,j]].color == :white
          s += "B" if self[[i,j]].color == :black
      #  end
      end
      s += "\n"
    end
    s
  end

  def display_colormap
    puts
    puts self.color_map
  end


  def display_board
    system("clear")
    puts self.to_s
  end

  def check_mate?(color)

    check_mate = true
    get_color_pieces(color).each do |piece|
      possible_moves = []
      from = piece.position
      piece.moves.each do |to|
        possible_moves << to unless move_into_check?(from, to)
      end
      # possible_moves = piece.moves.reject do |to|
      #       puts "CHECKMATE CHECK FROM #{from}   #{to}"
      #       move_into_check?(from, to)
      #     end
      # puts "Color: #{color} - #{possible_moves}"
      check_mate = false unless possible_moves.empty?
    end

    # puts "CHECKMATE? #{check_mate}  IN_CHECK: #{in_check?(color)}"
    check_mate # && in_check?(color)
  end
end
