module TicTacToe
  SYMS = { 0 => " ", 1 => "X", 2 => "O" }

  def print_board(board)
    ["+-----------+\n",
     "| #{SYMS[board[0]]} | #{SYMS[board[1]]} | #{SYMS[board[2]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[3]]} | #{SYMS[board[4]]} | #{SYMS[board[5]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[6]]} | #{SYMS[board[7]]} | #{SYMS[board[8]]} |\n",
     "+-----------+\n"]
  end

  # X wins: 10,   O wins: -10,    tie: 0
  # p: perspective
  def minimax(board, depth, p)
    # check for available spots on the board
    spots = 0.upto(8).select { |i| board[i] == 0 }

    # check for wins
    if (win?(board, p)) # player wins
      return 10 - depth
    elsif (win?(board, p == 1 ? 2 : 1)) # opponent wins
      return depth - 10
    elsif (spots.empty?) # tie game
      return 0
    end

    # if no winning or tie combination, continue to check for moves

    # increment depth for every recursive call
    depth += 1

    # initialize hash of possible moves
    moves = {}

    # find possible moves based on available spots
    spots.each do |m|
      # simulate board where p makes a move in m
      board[m] = p

      # store the score based on move made by p. the recursive call is
      # made on the perspective of the other player
      moves[m] = minimax(board, depth, p == 1 ? 2 : 1)

      # revert back to original board
      board[m] = 0
    end

    # find optimal move for player p
    return p == 1 ? moves.max_by { |k, v| v }[0] : moves.min_by { |k, v| v }[0]
  end

  def win?(board, p)
    ((board[0] == p && board[1] == p && board[2] == p) ||
     (board[3] == p && board[4] == p && board[5] == p) ||
     (board[6] == p && board[7] == p && board[8] == p) ||
     (board[0] == p && board[3] == p && board[6] == p) ||
     (board[1] == p && board[4] == p && board[7] == p) ||
     (board[2] == p && board[5] == p && board[8] == p) ||
     (board[0] == p && board[4] == p && board[8] == p) ||
     (board[2] == p && board[4] == p && board[6] == p)) ? true : false
  end
end
