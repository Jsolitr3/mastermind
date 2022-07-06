module Format
  def bold(text)
    "\e[1m#{text}\e[22m"
  end
  def underline(text)
    "\e[4m#{text}\e[24m"
  end
end

module MasterMindInformation
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
  
  def displayColors()
    puts CODECOLORS.values.join(" ")
  end

  def displayRules()
    puts underline(bold("Choose your role:"))
    puts "'Code-maker' or 'Code-breaker'"
    puts "-----------------------------------"
    puts underline(bold("Code-maker"))
    puts "-Choose a color code 4 colors long using the corresponding numbers. The computer will try to guess your code."
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
  include MasterMindInformation
  @@combos = Array.new() {Array.new()}
  def initialize()
    comboLoop()
  end

  def comboLoop()
    for a in (1..6)
      for b in (1..6)
        for c in (1..6)
          for d in (1..6)
            @@combos.push([a, b, c, d])
          end
        end
      end
    end
    puts @@combos.length
  end
  
  def check
    puts @@combos
  end

end


