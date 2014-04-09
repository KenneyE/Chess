require 'debugger'
require './piece_codes'

class Game
  attr_accessor :player1_turn, :board
  attr_reader :player1_color, :player2_color


  def initialize(options = { :player1_color => :white, :player2_color => :black})
    @player1_color = options[:player1_color]
    @player2_color = options[:player2_color]
    @player1_turn = true
  end


  def play

    quit = false
    self.board = Board.new(@player1_color, @player2_color)



    until board.check_mate?(self.player1_color) || board.check_mate?(self.player2_color) || quit
      if self.player1_turn
        color = :white
      else
        color = :black
      end

      self.board.display_board


      from, to = get_move(color)

      self.board.move_piece(from, to)
      self.player1_turn = !self.player1_turn

    end
  end

  def get_move(color)
    valid_from = false
    #puts "Color #{color}"
    begin
      #self.board.display_colormap
      from = parse(prompt("Input starting square: "))
      #puts "From Color #{self.board[from].color}"
      #p self.board[from]
      #puts "From: #{from}"
      next if self.board[from].nil?
      if self.board[from].color == color
        puts("Point 2")
        valid_from = true
      end
      if self.board[from].moves.empty?
        puts("Point 3")
        valid_from = false
      end

      #puts "BOARD MOVES: #{self.board[from].moves}"
    end until valid_from

    #puts "From: #{self.board[from].symbol}"

    valid_moves = self.board[from].moves

    begin
      to = parse(prompt("Input end square: "))
    end until valid_moves.include?(to)

    #puts "To: #{self.board[to].class}"
    return from, to
  end

  def prompt(s)
    puts(s)
    return gets.chomp.strip.downcase
  end

  def parse(s)

    alpha = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4,
              "f" => 5, "g" => 6, "h" => 7 }
    arr = s.split("")
    [ alpha[arr[0]], Integer(arr[1])-1].reverse
  end
end

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


class Piece
  attr_accessor :position, :board, :color, :symbol, :cursor

  def is_valid_move?(pos)
    return false if !pos[0].between?(0, 7) || !pos[1].between?(0, 7)
    return true if self.board[pos].nil?
    return false if self.board[pos].color == self.color
    true
  end

  def initialize(position, board, color)
    @position = position
    @board = board
    @color = color
    @symbol = " "
    @cursor = false
  end


  def moves(pos)
    raise NotImplementedError
  end

  def is_cursor?
    self.cursor
  end


  # def invalid_position?
  # end

end

class SlidingPiece < Piece

  def moves(deltas)
    possible_moves = []

    deltas.each do |delta|
      current_pos = self.position

      loop do

        current_pos[0] += delta[0]
        current_pos[1] +=  delta[1]

        puts "Delta: #{delta} Current Position: #{current_pos}"
        if is_valid_move?(current_pos)
           possible_moves << current_pos
           #puts "BOARD -- #{self.board[current_pos].nil?}"
           next if self.board[current_pos].nil?
           #puts "COLOR -- #{self.board[current_pos].color != self.color}"
           break if self.board[current_pos].color != self.color
         else
           break
         end

      end
    end
    puts "Possible moves: #{possible_moves}"
    possible_moves
  end

end

class SteppingPiece < Piece

  def moves(deltas)
    possible_moves = []

    deltas.each do |delta|
      current_pos = self.position
      # break if current_pos.nil?
      # debugger
      current_pos[0] += delta[0]
      current_pos[1] +=  delta[1]

      possible_moves << current_pos if is_valid_move?(current_pos)
    end

    possible_moves
  end

end


class King < SteppingPiece

  DELTAS = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [1, -1], [-1, -1], [-1, 1]]


  def moves
    super(DELTAS)
  end

  def initialize(position, board, color)
    # debugger
    super(position, board, color)
    self.symbol = Board::KING_WHITE if self.color == :white
    self.symbol = Board::KING_BLACK if self.color != :white
  end

  # def moves(deltas)
  #   possible_moves = []
  #
  #   deltas.each do |delta|
  #     current_pos = self.position
  #     current_pos[0] += delta[0]
  #     current_pos[1] +=  delta[1]
  #     possible_moves << current_pos if is_valid_move?(current_pos)
  #   end
  #
  #   possible_moves
  # end


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

  DELTAS = [ [1, 2], [2, 1], [2, -1], [1, -2],
            [-1, -2], [-2, -1], [-1, 2], [-2, 1]]


  def moves
    super(DELTAS)
  end

  def initialize(position, board, color)
    super(position, board, color)
    self.symbol = Board::QUEEN_WHITE if self.color == :white
    self.symbol = Board::QUEEN_BLACK if self.color != :white
  end

end


class Pawn < SlidingPiece


  DELTAS = [[1, 0], [-1, 0], [0, 1], [0, -1]]
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
