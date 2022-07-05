require_relative "tictactoe.rb"

include TicTacToe

EASY = 1
MEDIUM = 2
HARD = 3

PLAY_INS =
  ["=================================================================\n",
   "|  +-----------+  | An example board is shown on the left.      |\n",
   "|  | 1 | 2 | 3 |  |                                             |\n",
   "|  +-----------+  | To play, simply enter the desired grid when |\n",
   "|  | 4 | 5 | 6 |  | it is your turn.  Enter <q> to quit.        |\n",
   "|  +-----------+  |                                             |\n",
   "|  | 7 | 8 | 9 |  |                                             |\n",
   "|  +-----------+  | Now, enter <1> to be X, or <2> to be O      |\n",
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

def play
  board = [0, 0, 0, 0, 0, 0, 0, 0, 0]
  puts
  f_print(PLAY_INS, 0, true)

  # Choose Symbols
  while (true)
    puts
    print "Choose Symbol => "
    inp = STDIN.gets.chomp.downcase

    if (inp =~ /^[1-2]$/)
      player = inp.to_i
      cpu = player == 1 ? 2 : 1
      break
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
      elsif (inp =~ /q(uit)?/)
        return
      else
        puts "Invalid Input. Enter a number between 1 - 9 ...\n\n"
        f_print(print_board(board), 0, false)
        next
      end
    else # cpu turn
      f_print(["\n", "--- COMPUTER's TURN ---\n"], 0, false)
      delay(1)
      board[get_move(board, player, cpu, 3)] = cpu
    end

    turn = turn == 1 ? 2 : 1
    puts "\n\n"
    f_print(print_board(board), 0, false)
  end
end

play

# board = [0, 1, 0,
#          0, 0, 1,
#          2, 2, 1]
# move = get_move(board, 1, 2)

# board = [0, 2, 0,
#          0, 0, 2,
#          1, 1, 2]
# move = get_move(board, 2, 1)
# puts
# puts "move: #{move}"
# f_print(print_board(board), 0)
