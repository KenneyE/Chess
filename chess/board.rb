class Board

  BACK_ROW = [
    Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook
  ]

  attr_accessor :squares, :player1_color, :player2_color

  def initialize(player1_color, player2_color, init_board = true)
    @squares = Array.new(8) { Array.new( 8, nil ) }
    @player1_color = player1_color
    @player2_color = player2_color

    initialize_squares(player1_color, player2_color) if init_board
  end

  def [](pos)
    @squares[pos[0]][pos[1]]
  end

  def []=(pos, val)
    @squares[pos[0]][pos[1]] = val
  end


  def get_color_pieces(color)
     self.squares.flatten.compact.select{ |piece| piece.color == color }
   end

   def get_all_pieces
     self.squares.flatten.compact
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
     return false unless in_check?(color)

     get_color_pieces(color).each do |piece|
       possible_moves = []
       from = piece.position
       piece.moves.each do |to|
         possible_moves << to unless move_into_check?(from, to)
       end

       return false unless possible_moves.empty?
     end

     true
   end

  def dup
    new_board = Board.new(self.player1_color, self.player2_color, false)

    get_all_pieces.each do |piece|
      new_board[piece.position] = piece.piece_dup(new_board)
    end

    new_board
  end

  def move_into_check?(from, to)
    new_board = self.dup
    color = self[from].color
    new_board.move_piece(from, to)
    new_board.in_check?(color)
  end

  def in_check?(color)
    king_pos = find_piece(color, King)

    other_color = :black if color == :white
    other_color = :white if color == :black
    get_color_pieces(other_color).each do |piece|
      possible_moves = piece.moves
      return true if possible_moves.include?(king_pos)
    end
    false
  end

  def move_piece(from, to)
    self[to].board = nil unless self[to].nil?

    piece = self[from]
    piece.position = to
    self[to]=piece
    self[from] = nil
  end

  protected

    def find_piece(color, target_piece)
      get_color_pieces(color).each do |piece|
        return piece.position if piece.is_a?(target_piece)
      end
      nil
    end

    def to_s
      s = "  A B C D E F G H\n"
      self.squares.each_with_index do |row, i|
        s += (8 - i).to_s + " "
        row.each_with_index do |col, j|
          s += "- " if self[[i, j]].nil?
          s += self[[i,j]].symbol + " " unless self[[i,j]].nil?
        end
        s += "\n"
      end
      s
    end

    def initialize_squares(player1_color, player2_color)
      color_key = {0 => player2_color, 1 => player2_color,
                   7 => player1_color, 6 => player1_color }

      (0..7).each do |j|
        self[[1, j]] = Pawn.new([1, j], self, color_key[1])
        self[[6, j]] = Pawn.new([6, j], self, color_key[6])
      end

      [0, 7].each do |row|
        BACK_ROW.each_with_index do |piece, col|
          self[[row, col]] = piece.new([row, col], self, color_key[row])
        end
      end
    end
end
