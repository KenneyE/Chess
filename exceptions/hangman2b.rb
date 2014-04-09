class Hangman

  TRIES = 7

  attr_accessor :guessing_player, :checking_player, :current_state

  def initialize(guessing_player, checking_player)
    @guessing_player = guessing_player.downcase.strip
    @checking_player = checking_player.downcase.strip
    @current_state = []
  end

  def play
    if self.guessing_player == "human"
      guesser = HumanPlayer.new
    else
      guesser = ComputerPlayer.new
    end

    if self.checking_player == "human"
      checker = HumanPlayer.new
    else
      checker = ComputerPlayer.new
    end

    guesses = []

    secret_length = checker.pick_secret_word
    guesser.receive_secret_length(secret_length)
    self.current_state = Array.new(secret_length, "_")
    incorrect_count = 0

    until incorrect_count == TRIES || won?

      begin
        g = guesser.guess
        STDIN.flush
        puts "Already guessed #{g} " if guesses.include?(g)
      end while guesses.include?(g)



      guesses << g

      indices = checker.check_guess(g)

      indices.each do |i|
        self.current_state[i] = g
      end

      display_state

      incorrect_count += 1 if indices.empty?
      guesser.handle_guess_response(indices, g)

    end

    puts "The correct word was #{checker.secret.join("")}" if !won? && checker.is_a?(ComputerPlayer)
    puts "The answer is #{self.current_state.join}" if won?
  end

  def won?
    !self.current_state.include?("_")
  end


  def display_state
    if self.current_state.include?("_")
      puts self.current_state.join(" ")
    end
  end


end

class HumanPlayer

  def initialize
  end

  def pick_secret_word
    begin
      puts "Please enter a word length: "
      Integer(gets.chomp)
    rescue ArgumentError
      puts "Please enter an integer"
      retry
    end
  end

  def receive_secret_length(secret_length)
      puts "Length is #{secret_length} letters."
  end

  def guess
    begin
      puts "Please enter a letter: "
      guess = gets.chomp.upcase[0]
      raise "Not a character" unless guess.between?("A","Z")
    rescue
      puts "Not in the alphabet"
      retry
    end
  end

  def check_guess(guess)
    begin
      puts "Other player guessed #{guess}"
      puts "Enter indices of letter (ENTER if none)"
      input = gets.chomp

      indices = input.chomp.strip.split(",").collect{ |s| Integer(s) - 1 }
    rescue ArgumentError
      puts "Please enter an integer"
      retry
    end

    indices
  end

  def handle_guess_response(indices, guess)
   # indices.each { |index| self.current_state[index] = guess}
   #  won?
  end

end


class ComputerPlayer
  attr_accessor :secret, :dictionary, :guesses

  def initialize
    @secret = []
    @guesses = []
    @dictionary = intake_dictionary
  end

  def pick_secret_word
    self.secret = self.dictionary.sample.split("")
    self.secret.length
  end

  def receive_secret_length( word_length )
    self.dictionary.select! { | word | word.length == word_length }
  end

  def guess

    if self.dictionary.empty?
      puts "Can't find a word that matches that!"
      raise "Invalid Word"
    end

    valid_guess = false

    until valid_guess
      letter = self.dictionary.sample.split("").sample
      valid_guess = true unless self.guesses.include? letter
    end
    self.guesses << letter
    letter
  end

  def check_guess(guess)
    secret.each_index.select{|i| secret[i] == guess}
  end

  def handle_guess_response(indices, guess)

    if indices.empty?
      self.dictionary.reject! {|word| word.include?(guess)}
    else
      indices.each do |index|
        self.dictionary.select! {|word| word[index] == guess}
      end
    end
  end

  def intake_dictionary
    dictionary = File.readlines('dictionary.txt')
    dictionary.map! {|entry| entry.chomp.upcase}
  end

  # def filter_dictionary(length)
  #   dictionary.select! { | | }
  # end
end
