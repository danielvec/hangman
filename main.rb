require 'yaml'

# play a game of hangman with the option of saving the game
class Game
  attr_reader :winner, :empty_array, :guess, :winner_array, :number_correct,
              :lives, :wrong_guesses

  def initialize
    choose_game_type
  end

  def choose_game_type
    puts "Type 'new' for a new game or 'load' to load a saved game"
    game_type = gets.chomp
    case game_type
    when 'new'
      new_game
    when 'load'
      load_game
    end
  end

  def new_game
    @winner = pick_word
    @wrong_guesses = []
    @lives = 7
    @winner_array = @winner.split('')
    board
    make_guess
  end

  def pick_word
    lines = File.readlines('google-10000-english-no-swears.txt')
    word = lines.sample
    if word.length > 5 && word.length < 14
      word
    else
      pick_word
    end
  end

  def board
    @empty_array = []
    (@winner.length - 1).times { @empty_array << '_' }
    p @empty_array
  end

  def make_guess
    @guess = gets.chomp.downcase
    if @guess == 'save'
      save_game
    else
      @number_correct = @winner_array.count(@guess)
      move
    end
  end

  def move
    make_move
    post_move_output
    check_if_won
    check_if_lost
  end

  def make_move
    case @number_correct
    when 0
      @lives -= 1
      @wrong_guesses << @guess
    when 1
      @empty_array[@winner_array.index @guess] = @guess
    when (2..5)
      @empty_array[@winner_array.index @guess] = @guess
      @winner_array[@winner_array.index @guess] = 0
      @number_correct -= 1
      move
    end
  end

  def check_if_won
    return if @empty_array.include? '_'

    puts 'you won'
    exit
  end

  def check_if_lost
    if @lives.positive?
      make_guess
    else
      puts "sorry you lose. the word was #{@winner}"
      exit
    end
  end

  def post_move_output
    p @empty_array
    puts "wrong guesses: #{@wrong_guesses.join(',')}"
    puts "#{@lives} lives remaining"
    puts "type 'save' to save game"
  end

  def save_game
    info = { winner: @winner, winner_array: @winner_array, wrong_guesses: @wrong_guesses,
             lives: @lives, empty_array: @empty_array }
    File.open('game.yml', 'w') do |file|
      file.write(info.to_yaml)
    end
    exit
  end

  def load_game
    saved = YAML.load(File.read('game.yml'))
    @winner = saved[:winner]
    @winner_array = saved[:winner_array]
    @wrong_guesses = saved[:wrong_guesses]
    @lives = saved[:lives]
    @empty_array = saved[:empty_array]
    post_move_output
    make_guess
  end
end

Game.new