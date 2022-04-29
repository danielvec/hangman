class Game
  attr_reader :winner, :empty_array, :guess, :winner_array, :number_correct, :lives
  def initialize
    @winner = pick_word
    @winner_array = winner.split("")
    @lives = 7
    board
    guess
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

  def guess
    @guess = gets.chomp
    @number_correct = winner_array.count(@guess)
    move
  end

  def move
    case @number_correct
    when 0
      @lives -= 1
    when 1
      @empty_array[@winner_array.index @guess] = @guess
      p @empty_array
    when (2..5)
      @empty_array[@winner_array.index @guess] = @guess
      @winner_array[@winner_array.index @guess] = 0
      @number_correct -= 1
      move
    end
    puts "#{@lives} lives remaining"
    unless @empty_array.include? "_"
        puts "you won"
        exit
    end
    if @lives > 0
        guess
    else
        puts "sorry you lose. the word was #{@winner}"
        exit
    end
  end
end

Game.new