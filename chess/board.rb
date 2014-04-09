class Board

  attr_accessor :squares, :player1_color, :player2_color

  def initialize(player1_color, player2_color)
    @squares = Array.new(8) { Array.new( 8, nil ) }
    @player1_color = player1_color
    @player2_color = player2_color

    initialize_squares(player1_color, player2_color)
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


  def find_piece(color, target_piece)
    pieces = self.squares.flatten.compact

    pieces.each do |piece|
      return piece.position if piece.is_a?(target_piece) && piece.color == color
    end

    nil
  end

  def in_check?(pos, color)
    self.squares.each_with_index do |row, i|
      row.each_with_index do |col, j|
        piece = self[[i,j]]
        next if piece.nil? || piece.color != color
        moves = piece.moves
        if moves.any? { |move| move == pos }
          return true
        end
      end
    end
    false
  end

  def move_piece(from, to)
    piece = self[from]
    piece.position = to
    self[to]=piece
    self[from] = nil
  end

  def to_s
    s = "  A B C D E F G H\n"
    self.squares.each_with_index do |row, i|
      s += (i + 1).to_s + " "
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
      s += (i + 1).to_s + " "
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
    # system("clear")
    puts self.to_s
  end

  def check_mate?(color)
    king_pos = find_piece(color, King)
    piece = self[king_pos]
    arr = piece.moves + king_pos

    check_mate = arr.all? {|move| in_check?(color, move) }
  end


end
