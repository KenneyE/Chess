class Piece
  attr_accessor :position, :board, :color, :symbol, :cursor

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
    @symbol = " "
    @cursor = false
  end

  def is_valid_move?(pos)
    return false unless pos.all? { |ind| ind.between?(0,7) }
    return true if self.board[pos].nil?
    false
  end

  def moves(pos)
    raise NotImplementedError
  end

  def is_cursor?
    self.cursor
  end

end

class SlidingPiece < Piece

  def moves(deltas)
    possible_moves = []
    # debugger
    deltas.each do |delta|
      current_pos = self.position.dup

      loop do
        current_pos[0] += delta[0]
        current_pos[1] +=  delta[1]

        # puts "Starting Pos: #{self.position}, Delta: #{delta}, Moved Pos: #{current_pos}"
        if is_valid_move?(current_pos)
           possible_moves << current_pos.dup
           # puts "BOARD -- #{self.board[current_pos].nil?}"
           next if self.board[current_pos].nil?
           #puts "COLOR -- #{self.board[current_pos].color != self.color}"
           break if self.board[current_pos].color != self.color
         else
           break
         end

      end
    end
    # puts "Possible moves: #{possible_moves}"
    possible_moves
  end
end

class SteppingPiece < Piece

  def moves(deltas)
    possible_moves = []
    deltas.each do |delta|
      current_pos = self.position.dup
      # break if current_pos.nil?
      # debugger
      current_pos[0] += delta[0]
      current_pos[1] +=  delta[1]

      possible_moves << current_pos.dup if is_valid_move?(current_pos)
    end

    possible_moves
  end

end


class King < SteppingPiece

  DELTAS = [[1, 0], [-1, 0], [0, 1], [0, -1],
            [1, 1], [1, -1], [-1, -1], [-1, 1]]

  def moves
    super(DELTAS)
  end

  def initialize(position, board, color)
    # debugger
    super(position, board, color)
    self.symbol = Board::KING_WHITE if self.color == :white
    self.symbol = Board::KING_BLACK if self.color != :white
  end
end


class Knight < SteppingPiece

  DELTAS = [ [1, 2], [2, 1], [2, -1], [1, -2],
            [-1, -2], [-2, -1], [-1, 2], [-2, 1] ]


  def moves
    super(DELTAS)
  end

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::KNIGHT_WHITE if self.color == :white
    self.symbol = Board::KNIGHT_BLACK if self.color != :white
  end

end




class Rook < SlidingPiece
  DELTAS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  attr_reader :symbol

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::ROOK_WHITE if self.color == :white
    self.symbol = Board::ROOK_BLACK if self.color != :white
  end

  def moves
    super(DELTAS)
  end
end


class Bishop < SlidingPiece

  DELTAS = [[1, 1], [-1, 1], [1, -1], [-1, -1]]
  attr_reader :symbol

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::BISHOP_WHITE if self.color == :white
    self.symbol = Board::BISHOP_BLACK if self.color != :white
  end

  def moves
    super(DELTAS)
  end
end


class Queen < SlidingPiece

  DELTAS = [ [1, 1], [1, 0], [1, -1], [0, -1],
            [-1, -1], [-1, 0], [-1, 1], [0, 1]]

  def moves
    super(DELTAS)
  end

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::QUEEN_WHITE if self.color == :white
    self.symbol = Board::QUEEN_BLACK if self.color != :white
  end

end


class Pawn < Stepping


  DELTAS = [[1, 0]
  attr_reader :symbol

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::PAWN_WHITE if self.color == :white
    self.symbol = Board::PAWN_BLACK if self.color != :white
  end

  def moves
    super(DELTAS)
  end

end

#class Pawn < Piece

#
#   attr_accessor :delta
#
#   def is_first_move?
#     return true if self.position[0] == 1 && self.color == self.board.player2_color
#     return true if self.position[0] == 6 && self.color == self.board.player1_color
#     false
#   end
#
#   def initialize(position, board, color)
#     super(position, board, color)
#     self.symbol = Board::PAWN_WHITE if self.color == :white
#     self.symbol = Board::PAWN_BLACK if self.color != :white
#   end
#
#   def moves(deltas)
#     possible_moves = []
#
#     deltas.each do |delta|
#       current_pos = self.position
#       current_pos[0] += delta[0]
#       current_pos[1] +=  delta[1]
#       possible_moves << current_pos if is_valid_move?(current_pos)
#     end
#
#     possible_moves
#   end
#
#end
