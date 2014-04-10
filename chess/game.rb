require 'debugger'
load './piece_codes.rb'
load './piece.rb'
load './board.rb'

class Game

  INPUT_KEY = { "a" => 0, "b" => 1, "c" => 2, "d" => 3, "e" => 4,
                "f" => 5, "g" => 6, "h" => 7 }

  attr_accessor :player1_turn, :board, :quit
  attr_reader :player1_color, :player2_color

  def initialize(options = { :player1_color => :white, :player2_color => :black})
    @player1_color = options[:player1_color]
    @player2_color = options[:player2_color]
    @player1_turn = true
    @quit = false
  end

  def play
    self.board = Board.new(@player1_color, @player2_color)

    until game_over? || quit?
      color = swap_color

      self.board.display_board
      from, to = get_move(color)
      break if quit?
      self.board.move_piece(from, to)

      swap_player
    end

    output_result

  end

  private

    def swap_player
      self.player1_turn = !self.player1_turn
    end

    def swap_color
      if self.player1_turn
        color = :white
      else
        color = :black
      end
    end

    def game_over?
      board.check_mate?(self.player1_color) || board.check_mate?(self.player2_color)
    end

    def quit?
      @quit
    end

    def get_move(color)

      from = get_from(color)
      return nil if quit?
      puts "You Picked a: #{self.board[from].class}"

      valid_moves = self.board[from].moves
      to = get_to(from, valid_moves)
      return nil if quit?

      return from, to
    end

    def get_from(color)
      valid_from = false
      begin
        from = parse(prompt("Input starting square: "))

        next if self.board[from].nil? || self.board[from].color != color
        unless self.board[from].moves.empty?
          valid_from = true
        end
      rescue
        puts "Invalid input"
        retry
      end until valid_from
      from
    end

    def get_to(from, valid_moves)
      begin
        to = parse(prompt("Input end square: "))
      end until valid_moves.include?(to) && !self.board.move_into_check?(from, to)
      to
    end

    def prompt(s)
      puts(s)
      return gets.chomp.strip.downcase
    end

    def parse(s)
      arr = s.split("")
      return quit_game if arr[1] == "q"
      raise "Invalid Input" unless INPUT_KEY.has_key?(arr[0])
      raise "Invalid Input" unless (8 - Integer(arr[1])).between?(0,7)
      [ 8 - Integer(arr[1]),  INPUT_KEY[arr[0]]]
    end

    def quit_game
      self.quit = true
    end

    def output_result
      puts "You quit the game!" if quit?
      puts "Player 2 Weeeeens!" if board.check_mate?(self.player1_color)
      puts "Player 1 Weeeeens!" if board.check_mate?(self.player2_color)
    end

end


g = Game.new
g.play


