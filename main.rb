module Format
  def bold(text)
    "\e[1m#{text}\e[22m"
  end
  def underline(text)
    "\e[4m#{text}\e[24m"
  end
  def newLine(number)
    number.times do
      puts ""
    end
  end
  def line()
    puts "----------------------------------------------------------------------"
  end
end

module MasterMindGame
include Format
  RESULT = {
    exact: "\e[32m\u25CF\e[0m",
    close: "\e[33m\u25CF\e[0m",
    wrong: "\e[30m\u25CF\e[0m"
  }
  CODECOLORS = {
    1 => "\e[41m#{"  1  "}\e[0m",
    2 => "\e[42m#{"  2  "}\e[0m",
    3 => "\e[43m#{"  3  "}\e[0m",
    4 => "\e[44m#{"  4  "}\e[0m",
    5 => "\e[45m#{"  5  "}\e[0m",
    6 => "\e[46m#{"  6  "}\e[0m"
}
  
  def diplsayResult(exact, close, wrong)
    resultArr = Array.new()
    exact.times do
      resultArr.push(RESULT[:exact])
    end
    close.times do
      resultArr.push(RESULT[:close])
    end
    wrong.times do
      resultArr.push(RESULT[:wrong])
    end
    resultArr.join("")
  end

  def displayColors()
    puts CODECOLORS.values.join(" ")
  end

  def displayRules()
    puts bold("Let's play Mastermind!")
    puts ""
    puts underline(bold("Rules:"))
    puts ""
    puts underline(bold("Choose your role:"))
    puts "'Code-maker' or 'Code-breaker'"
    puts "-----------------------------------"
    puts underline(bold("Code-maker"))
    puts "-Choose a color code 4 colors long using the corresponding numbers. The computer will try to guess your code."
    displayColors
    puts ""
    puts underline(bold("Code-breaker"))
    puts "-The computer will create a code for the player to break. With each guess you will see a series of 4 dots."
    puts RESULT[:wrong] + " = one of the colors you chose does not exist in the code."
    puts RESULT[:close] + " = one of the colors you chose is correct, but not in the correct order in the code sequence."
    puts RESULT[:exact] + " = one of the colors you chose if correct and located in the correct order in the code sequence."
    puts ""
  end

end

class Game
  include MasterMindGame
  include Math
  def initialize()
    @maxGuesses = 13
    [1, 2, 3, 4, 5, 6].repeated_permutation(4) {|combination| @combos.push(combination)}
    @turn = 0
    @guesses = Array.new() {Hash.new()}
    @invalidCombos = Array.new() {Array.new(4)}
    @win = false
  end
  
  def generateCode(arrayLength = 4, numberRange = 1..6)
    @secretCode = Array.new()
    arrayLength.times do
    @secretCode.push(rand(numberRange))
    end
  end
  
  def getRole()
    loop do
      puts "Would you like to play as the code-maker or code-breaker?"
      userRole = gets.chomp.downcase
      if userRole.include?("make")
        return"make"
      elsif userRole.include?("break")
        return "break"
      end
    end
  end

  def startGame()
    loop do
      initialize()
      displayRules()
      userRole = getRole()
      if userRole == "make"
        makerGame
      elsif userRole == "break"
        breakerGame
      end
      gameOver()
      unless playAgain?()
        puts "Thanks for playing!"
        break
      end
    end
  end  

  def userGuess()
    puts "Try to break the computers secret code!"
    loop do
      guess = gets.chomp.split("")
      if guess.length == 4
        if guess.all? {|number| (1..6).include?(number.to_i)}
          @guesses.push()
          @guesses[@turn-1] = {
            guessDisplay: Array.new(),
            guess: Array.new()
          }
          guess.each { |num| @guesses[@turn-1][:guess].push(num.to_i)}
          guess.each { |num| @guesses[@turn-1][:guessDisplay].push(CODECOLORS[num.to_i])}
          break
        end
      end
      puts "Please make sure your guess is 4 numbers ranging from 1 to 6."
    end
  end
  
  def win()
      @win = true
  end

  def checkGuess(guess)
    if guess.eql?(@secretCode)
      @guesses[@turn-1][:result] = [RESULT[:exact], RESULT[:exact], RESULT[:exact], RESULT[:exact]]
      win()
    else
      exact = 0
      close = 0
      wrong = 0
      tempArr = @secretCode.values_at(0..-1)
      tempguess = guess.values_at(0..-1)
      resultArr = Array.new()
      for i in (1..4)
        if tempguess[i-1] == tempArr[i-1]
          puts i
          resultArr.push(RESULT[:exact])
          tempguess[i-1] = 0
          tempArr[i-1] = 0
        end
      end
        tempguess.each_with_index do |number, index|
          tempArr.each_with_index do |secretNumber, secretIndex|
            if number == secretNumber && number > 0
              resultArr.push(RESULT[:close])
              tempArr[secretIndex] = 0
              tempguess[index] = 0
              break
            end
          end
        end
      wrong = 4 - resultArr.length
      wrong.times do
        resultArr.push(RESULT[:wrong])
      end
      @guesses[@turn-1][:result] = resultArr
    end
  end

  def turnCount()
   @turn += 1
  end

  def displayResult()
    newLine(10)
    line()
    for i in (1..@guesses.length)
      puts "Turn ##{i} | #{@guesses[i-1][:guessDisplay].join(" ")} | #{@guesses[i-1][:result].join(" ")}"
      line()
    end
  end

  def gameOver()
    if @win == true
      puts bold("Congratulations! You Cracked the Code!")
    else
      puts bold("Better luck next time!")
    end
  end

  def playAgain?()
    userInput = ""
    until userInput == "y" || userInput == "n" do
      puts "Do you want to play again? y / n"
      userInput = gets.chomp.downcase() 
    end
    if userInput == "y"
      return true
    else
      return false
    end
  end

  def breakerGame()
    generateCode()
    until @win || @turn > 12 do
    turnCount()
    userGuess()
    checkGuess(@guesses[@guesses.length-1][:guess])
    displayResult()
    end
  end

  def makerGame()
    generateCode()

  end

end
