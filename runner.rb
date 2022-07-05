require_relative "tictactoe.rb"

include TicTacToe

QUIT = /q(uit)?/

INTRO =
  ["=================================================================\n",
   "|          OOXX      Welcome to TIC TAC TOE      OXOX           |\n",
   "=================================================================\n",
   "|                    made by: Samuel Kosasih                    |\n",
   "=================================================================\n",
   "| Choose a mode:                                                |\n",
   "| <cas>  : play a casual game with the CPU                      |\n",
   "| <pro>  : battle an expert CPU                                 |\n",
   "| <GOD>  : CPU IS A GOD                                         |\n",
   "| <pvp>  : beat your friends (and vice versa)                   |\n",
   "| <quit> : quit the game (works anywhere in the game)           |\n",
   "=================================================================\n"]

PLAY_INS =
  ["=================================================================\n",
   "|  +-----------+  | An example board is shown on the left.      |\n",
   "|  | 1 | 2 | 3 |  |                                             |\n",
   "|  +-----------+  | To play, simply enter the desired grid when |\n",
   "|  | 4 | 5 | 6 |  | it is your turn. Choices are grids 1 - 9.   |\n",
   "|  +-----------+  |                                             |\n",
   "|  | 7 | 8 | 9 |  | Enter <q> to quit anytime.                  |\n",
   "|  +-----------+  | GOOD LUCK!                                  |\n",
   "=================================================================\n"]

# ============================================================================

# @!group Utility Methods

# ----------------------------------------------------------------------------

# This method retrieves the current width of the player's terminal.
# It is mainly used to compute the number of spaces to be printed for a string
# to be centered within the string.
#
# If the terminal width retrieved is invalid, then return a default value of
# +80+.
#
# @return [Integer] the width of the terminal's current viewport
def terminal_width
  w = `tput cols`.to_i
  w == 0 ? 80 : w
end

# ----------------------------------------------------------------------------

# This method is used to create a delay between statement evaluations while
# ensuring output buffer is flushed to +STDOUT+.
#
# @param x [Float] number of seconds the thread should be suspended
#
# @return [void]
def delay(x)
  STDOUT.flush
  sleep(x.to_f)
end

# ----------------------------------------------------------------------------

# This method helps display output in a more proper format.
#
# Specifically, it allows any output to be centered within the terminal
# in accordance to its width during the method call. More options allow:
# - Specifying a delay between each line of output through calling
#   method {#delay}.
# - Alignment based on the first line of output.
#
# To accommodate these options, the output argument must be in the form of a
# +Array<String>+, to create more explicit indications of newlines.
#
# @param str_arr [Array<String>] the output array to be printed
# @param del [Float] the number of seconds delayed between each printed line
# @param align [Boolean] an option to apply the alignment rule to the output
#
# @return [void]
#
# @see #delay
# @see #terminal_width
def f_print(str_arr, del, align)
  w = terminal_width
  # if align, set a fixed number of spaces based on the first line
  if (align) then fixed_spacing = (w - str_arr[0].length) / 2 end
  str_arr.each do |line|
    1.upto(align ? fixed_spacing : (w - line.length) / 2) { print " " }
    print line
    delay(del.to_f)
  end
end

# ----------------------------------------------------------------------------

# @!endgroup

# ============================================================================

def playCPU(mode)
  board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  puts
  f_print(["VS CPU (#{mode == EASY ? "CASUAL" :
    mode == MED ? "PROFESSIONAL" : "GOD"})\n"], 0, false)
  f_print(PLAY_INS, 0, true)

  # Choose Symbols
  while (true)
    f_print(["Now, enter <1> to be X, or <2> to be O\n"], 0, false)
    print "Choose Symbol => "
    inp = STDIN.gets.chomp.downcase

    if (inp =~ /^[1-2]$/)
      player = inp.to_i
      cpu = player == 1 ? 2 : 1
      break
    elsif (inp =~ QUIT)
      return -1
    else
      puts "Invalid Input. Please enter <1> to be X or <2> to be O ..."
      next
    end
  end

  turn = rand(1..2)
  f_print(print_board(board), 0, false)

  while (true)
    # check for winning or tie combinations
    flag = win?(board, player) ? 1 :
      win?(board, cpu) ? 2 :
      !board.include?(0) ? 3 : nil

    if flag # end game
      f_print(["\n", "--- YOU WIN ---\n"], 0, false) if flag == 1
      f_print(["\n", "--- YOU LOSE ---\n"], 0, false) if flag == 2
      f_print(["\n", "--- TIE ---\n"], 0, false) if flag == 3
      break
    end

    if (turn == player) # player turn
      f_print(["\n", "--- YOUR TURN ---\n"], 0, false)
      print "Choose a spot => "
      inp = STDIN.gets.chomp.downcase

      if (inp =~ /^[1-9]$/)
        if (board[inp.to_i - 1] != 0)
          puts "This grid is taken. Choose an empty one.\n\n"
          f_print(print_board(board), 0, false)
          next
        else
          board[inp.to_i - 1] = player
        end
      elsif (inp =~ QUIT)
        return -1
      else
        puts "Invalid Input. Enter a number between 1 - 9 ...\n\n"
        f_print(print_board(board), 0, false)
        next
      end
    else # cpu turn
      f_print(["\n", "--- COMPUTER's TURN ---\n"], 0, false)
      delay(1)
      board[get_move(board, player, cpu, mode)] = cpu
    end

    turn = turn == 1 ? 2 : 1
    puts "\n\n"
    f_print(print_board(board), 0, false)
  end
end

def playPVP
  board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  puts
  f_print(["PVP MODE\n"], 0, false)
  f_print(PLAY_INS, 0, true)
  delay(1)

  turn = 1
  f_print(print_board(board), 0, false)

  while (true)
    # check for winning or tie combinations
    flag = win?(board, 1) ? 1 :
      win?(board, 2) ? 2 :
      !board.include?(0) ? 3 : nil

    if flag # end game
      f_print(["\n", "--- PLAYER 1 (X) WINS ---\n"], 0, false) if flag == 1
      f_print(["\n", "--- PLAYER 2 (O) WINS ---\n"], 0, false) if flag == 2
      f_print(["\n", "--- TIE ---\n"], 0, false) if flag == 3
      break
    end

    f_print(["\n", "--- PLAYER #{turn}'s (#{SYMS[turn]}) TURN ---\n"], 0, false)
    print "Choose a spot => "
    inp = STDIN.gets.chomp.downcase

    if (inp =~ /^[1-9]$/)
      if (board[inp.to_i - 1] != 0)
        puts "This grid is taken. Choose an empty one.\n\n"
        f_print(print_board(board), 0, false)
        next
      else
        board[inp.to_i - 1] = turn
      end
    elsif (inp =~ QUIT)
      return -1
    else
      puts "Invalid Input. Enter a number between 1 - 9 ...\n\n"
      f_print(print_board(board), 0, false)
      next
    end

    turn = turn == 1 ? 2 : 1
    puts "\n\n"
    f_print(print_board(board), 0, false)
  end
end

def main
  while (true)
    puts
    f_print(INTRO, 0, false)
    puts
    print "Enter your command => "
    inp = STDIN.gets.chomp.downcase

    if inp =~ /c(as)?|p(ro)?|g(od)?|pvp|/
      if (inp =~ /pvp/)
        while (true)
          if (playPVP() != -1)
            delay(1.5)
            f_print(["Try Again?  Y/N => "], 0, false)
            inp = STDIN.gets.chomp.downcase
            if inp =~ /y(es)?/ then next else break end
          end
          break
        end
      else
        mode = inp =~ /c(as)?/ ? EASY : inp =~ /p(ro)?/ ? MED : HARD
        while (true)
          if (playCPU(mode) != -1)
            delay(1.5)
            f_print(["Try Again?  Y/N => "], 0, false)
            inp = STDIN.gets.chomp.downcase
            if inp =~ /y(es)?/ then next else break end
          end
          break
        end
      end
    elsif inp =~ QUIT
      break
    else
      puts "Invalid Input. Please try again ..."
    end
  end
end

main()