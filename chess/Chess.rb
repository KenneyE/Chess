require 'debugger'
require './piece_codes'
require './Board'
require './Piece'

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
      next if self.board[from].nil? || self.board[from].color != color
      unless self.board[from].moves.empty?
        # puts("Point 3: Moves isn't Empty!")
        valid_from = true
      end

      # puts "BOARD MOVES: #{self.board[from].moves}"
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


g = Game.new
g.play
