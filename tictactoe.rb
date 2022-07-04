module TicTacToe
  class Game
    SYMS = { 0 => " ", 1 => "X", 2 => "O" }

    def initialize
      @board = Array.new(9) { 0 }
    end

    def printed_board
      ["+-----------+\n",
       "| #{SYMS[@board[0]]} | #{SYMS[@board[1]]} | #{SYMS[@board[2]]} |\n",
       "+-----------+\n",
       "| #{SYMS[@board[3]]} | #{SYMS[@board[4]]} | #{SYMS[@board[5]]} |\n",
       "+-----------+\n",
       "| #{SYMS[@board[6]]} | #{SYMS[@board[7]]} | #{SYMS[@board[8]]} |\n",
       "+-----------+\n"]
    end

    def empty_spots
      @board.select.with_index { |v, i| if (v == 0) then i end }
    end

    def win?(p)
      ((@board[0] == p && @board[1] == p && @board[2] == p) ||
       (@board[3] == p && @board[4] == p && @board[5] == p) ||
       (@board[6] == p && @board[7] == p && @board[8] == p) ||
       (@board[0] == p && @board[3] == p && @board[6] == p) ||
       (@board[1] == p && @board[4] == p && @board[7] == p) ||
       (@board[2] == p && @board[5] == p && @board[8] == p) ||
       (@board[0] == p && @board[4] == p && @board[8] == p) ||
       (@board[2] == p && @board[4] == p && @board[6] == p)) ? true : false
    end
  end
end
