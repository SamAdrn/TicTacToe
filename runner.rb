require_relative "tictactoe.rb"
require "colorize"

include TicTacToe

QUIT = /q(uit)?/

INTRO =
  ["=================================================================\n",
   "|          " + "OOXX".bold.blink +
   "      " + "Welcome to TIC TAC TOE".light_red +
   "      " + "OXOX".bold.blink + "           |\n",
   "=================================================================\n",
   "|                    " + "made by: Samuel Kosasih".light_yellow +
   "                    |\n",
   "=================================================================\n",
   "| Choose a mode:                                                |\n",
   "| <" + "cas".light_green +
   ">  : play a " + "casual".light_green +
   " game with the CPU                      |\n",
   "| <" + "pro".light_yellow +
   ">  : battle an " + "expert".light_yellow +
   " CPU                                 |\n",
   "| <" + "GOD".light_red +
   ">  : " + "CPU IS A GOD".light_red +
   "                                         |\n",
   "| <" + "pvp".light_cyan +
   ">  : beat your " + "friends".light_cyan +
   " (and vice versa)                   |\n",
   "| <" + "quit".light_magenta +
   "> : " + "quit".light_magenta +
   " the game (works anywhere in the game)           |\n",
   "=================================================================\n"]

PLAY_INS =
  ["=================================================================\n",
   "|  +-----------+  | An example board is shown on the left.      |\n",
   "|  | " +
   "1".light_red + " | " +
   "2".light_yellow + " | " +
   "3".light_magenta +
   " |  |                                             |\n",
   "|  +-----------+  | To play, simply enter the desired grid when |\n",
   "|  | " +
   "4".light_cyan + " | " +
   "5".light_blue + " | " +
   "6".light_green +
   " |  | it is your turn. Choices are grids " +
   "1".light_red + " - " +
   "9".light_yellow + ".   |\n",
   "|  +-----------+  |                                             |\n",
   "|  | " +
   "7".light_green + " | " +
   "8".light_cyan + " | " +
   "9".light_yellow +
   " |  | Enter <" + "q".light_magenta +
   "> to quit anytime.                  |\n",
   "|  +-----------+  | " + "GOOD LUCK!".light_green +
   "                                  |\n",
   "=================================================================\n"]

# ============================================================================

# @!group Utility Functions

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

# ============================================================================

# @!group Play Functions

# ----------------------------------------------------------------------------

def playCPU(mode)
  board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  f_print(
    ["                                                                 \n",
     "#{mode == EASY ?
      "                         VS CPU (" + "CASUAL".light_green + ")" :
      mode == MED ?
      "                      VS CPU (" + "PROFESSIONAL".light_yellow + ")" :
      "                          VS CPU (" + "GOD".light_red + ")"}" + "\n"] +
      PLAY_INS, 0, true
  )

  # Choose Symbols
  while (true)
    f_print(
      ["                                                                 \n",
       "            --- Enter <" + "1".light_magenta +
       "> to be X, or <" + "2".light_cyan + "> to be O ---\n"],
      0, true
    )
    print "Choose Symbol => "
    inp = STDIN.gets.chomp.downcase

    if (inp =~ /^[1-2]$/)
      player = inp.to_i
      cpu = player == 1 ? 2 : 1
      break
    elsif (inp =~ QUIT)
      return -1
    else
      puts "Invalid Input.".light_red +
             " Please enter <" + "1".light_magenta +
             "> to be X, or <" + "2".light_cyan + "> to be O ..."
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
      f_print(
        ["                                                                 \n",
         "                         --- " + "YOU WIN".light_green +
         " ---\n"], 0, true
      ) if flag == 1
      f_print(
        ["                                                                 \n",
         "                        --- " + "YOU LOSE!".light_red +
         " ---\n"], 0, true
      ) if flag == 2
      f_print(
        ["                                                                 \n",
         "                           --- " + "TIE".light_yellow +
         " ---\n"], 0, true
      ) if flag == 3
      break
    end

    if (turn == player) # player turn
      f_print(
        ["                                                                 \n",
         "                        --- " + "YOUR TURN".light_magenta +
         " ---\n"], 0, true
      )
      print "Choose a spot => "
      inp = STDIN.gets.chomp.downcase

      if (inp =~ /^[1-9]$/)
        if (board[inp.to_i - 1] != 0)
          puts "This spot is " + "taken".light_red +
                 ". Choose an empty one.\n\n"
          f_print(print_board(board), 0, false)
          next
        else
          board[inp.to_i - 1] = player
        end
      elsif (inp =~ QUIT)
        return -1
      else
        puts "Invalid Input".light_red +
               ". Enter a number between 1 - 9 ...\n\n"
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

# ----------------------------------------------------------------------------

def playPVP
  board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  f_print(
    ["                                                                 \n",
     "                            " + "PVP MODE".light_cyan + "\n"] +
      PLAY_INS + ["\n"], 0, true
  )
  delay(1)

  turn = 1
  f_print(print_board(board), 0, false)

  while (true)
    # check for winning or tie combinations
    flag = win?(board, 1) ? 1 :
      win?(board, 2) ? 2 :
      !board.include?(0) ? 3 : nil

    if flag # end game
      f_print(
        ["                                                                 \n",
         "                    --- " + "PLAYER 1 (X) WINS".light_magenta +
         " ---\n"], 0, true
      ) if flag == 1
      f_print(
        ["                                                                 \n",
         "                    --- " + "PLAYER 2 (O) WINS".light_cyan +
         " ---\n"], 0, true
      ) if flag == 2
      f_print(
        ["                                                                 \n",
         "                           --- " + "TIE".light_yellow +
         " ---\n"], 0, true
      ) if flag == 3
      break
    end

    f_print( # Prompt Player 1
      ["                                                                 \n",
       "                   --- " + "PLAYER 1's (X) TURN".light_magentan +
       " ---\n"], 0, true
    ) if turn == 1
    f_print( # Prompt Player 2
      ["                                                                 \n",
       "                   --- " + "PLAYER 2's (O) TURN".light_cyan +
       " ---\n"], 0, true
    ) if turn == 2
    print "Choose a spot => "
    inp = STDIN.gets.chomp.downcase

    if (inp =~ /^[1-9]$/)
      if (board[inp.to_i - 1] != 0)
        puts "This spot is " + "taken".light_red + ". Choose an empty one.\n\n"
        f_print(print_board(board), 0, false)
        next
      else
        board[inp.to_i - 1] = turn
      end
    elsif (inp =~ QUIT)
      return -1
    else
      puts "Invalid Input".light_red + ". Enter a number between 1 - 9 ...\n\n"
      f_print(print_board(board), 0, false)
      next
    end

    turn = turn == 1 ? 2 : 1
    puts "\n\n"
    f_print(print_board(board), 0, false)
  end
end

# ----------------------------------------------------------------------------

# @!endgroup

# ============================================================================

# ----------------------------------------------------------------------------

def main
  while (true)
    puts
    f_print(INTRO, 0, true)
    puts
    print "Enter your command => "
    inp = STDIN.gets.chomp.downcase

    if inp =~ /c(as)?|p(ro)?|g(od)?|pvp/
      if (inp =~ /pvp/)
        while (true)
          if (playPVP() != -1)
            puts
            delay(1.5)
            f_print([" Try Again?  Y/N => "], 0, false)
            inp = STDIN.gets.chomp.downcase
            if inp =~ /y(es)?/ then next else break end
          end
          break
        end
      else
        mode = inp =~ /c(as)?/ ? EASY : inp =~ /p(ro)?/ ? MED : HARD
        while (true)
          if (playCPU(mode) != -1)
            puts
            delay(1.5)
            f_print([" Try Again?  Y/N => "], 0, false)
            inp = STDIN.gets.chomp.downcase
            if inp =~ /y(es)?/ then next else break end
          end
          break
        end
      end
    elsif inp =~ QUIT
        puts "see you soon!\n".light_green
      break
    else
      puts "Invalid Input".light_red + ". Please try again ..."
    end
  end
end

# ----------------------------------------------------------------------------

main()
