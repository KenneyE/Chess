class Code

  COLORS = ['R', 'G', 'B', 'Y', 'O', 'P']
  attr_reader :sequence

  def initialize(value)
    @sequence = value
  end

  def self.parse(value)
    input = value.strip.upcase.split(",").split('')

    if input.length != 4
      raise "Please enter 4 values"
    elsif !input.all? { |letter| COLORS.include?(letter) }
      raise "Please only input valid colors"
    end
    Code.new(input)
  end

  def self.random
    secret = []

    4.times do
      secret << COLORS.sample
    end

    Code.new(secret)
  end

  #num of correct colors
  def check_colors(guess)
    num_correct = 0
    secret_copy = self.sequence.dup
    guess.sequence.each do |color|
      if secret_copy.include?(color)
        num_correct += 1
        secret_copy.delete_at(secret_copy.index(color))
      end
    end

    num_correct
  end

  def check_positions(guess)
    num_correct = 0
    guess.sequence.each_with_index do |color, i|
      num_correct += 1 if self.sequence[i] == color
    end

    num_correct
  end

  def ==(guess)
    self.sequence == guess.sequence
  end
end

class Game

  attr_accessor :secret, :guess, :num_guesses

  def initialize
    @num_guesses = 0
  end

  def prompt_for_guess
    begin
      puts "Enter the code: "
      code = gets.chomp
      Code.parse(code)
    rescue
      puts "Not a valid input!"
      retry
    end
  end

  def win?
    return false if self.num_guesses.zero?
    self.secret == self.guess
  end

  def play
    self.secret = Code.random

    until self.num_guesses == 10 || win?

      self.guess = prompt_for_guess

      num_correct_colors = self.secret.check_colors(guess)
      num_correct_positions = self.secret.check_positions(guess)

      puts "You have #{num_correct_colors} correct colors and #{num_correct_positions} correct positions"
      puts "Code is #{self.secret.sequence}"

      self.num_guesses += 1
    end
  end
end
