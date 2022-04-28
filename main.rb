class Game
  attr_reader :winner, :empty_array, :guess, :winner_array, :number_correct
  def initialize
    @winner = pick_word
    puts @winner
    board
    @guess = gets.chomp
    @winner_array = winner.split("")
    @number_correct = winner_array.count(guess)
    move
  end

  def pick_word
    lines = File.readlines('google-10000-english-no-swears.txt')
    word = lines.sample
    if word.length > 5 && word.length < 14
        word
    else pick_word
    end
  end

  def board
    @empty_array = []
    (@winner.length - 1).times {@empty_array << '_'}
    p @empty_array
  end

  def move
    case @number_correct
    when 0
      exit
    when 1
      @empty_array[@winner_array.index @guess] = @guess
      p @empty_array
    when (2..5)
      @empty_array[@winner_array.index @guess] = @guess
      @winner_array[@winner_array.index @guess] = 0
      @number_correct -= 1
      move
    end
  end
end

Game.new