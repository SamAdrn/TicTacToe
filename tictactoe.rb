module TicTacToe
  SYMS = { 0 => " ", 1 => "X", 2 => "O" }

  EASY = 1
  MED = 2
  HARD = 3

  def print_board(board)
    ["+-----------+\n",
     "| #{SYMS[board[0]]} | #{SYMS[board[1]]} | #{SYMS[board[2]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[3]]} | #{SYMS[board[4]]} | #{SYMS[board[5]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[6]]} | #{SYMS[board[7]]} | #{SYMS[board[8]]} |\n",
     "+-----------+\n"]
  end

  def get_move(board, player, pers, mode)
    return 0.upto(8).select { |i| board[i] == 0 }.sample if (mode == EASY)

    best = pers == player ? -100 : 100
    move = -1
    0.upto(8) do |i|
      if (board[i] == 0)
        # simulate board where p makes a move in m
        board[i] = pers

        # store the score based on a sequence of moves starting with m.
        # The recursive call is made on the alternate perspective.
        score = minimax(board, 0, player, pers == 1 ? 2 : 1, mode)

        # revert back to original board
        board[i] = 0

        if (pers == player)
          if (score >= best)
            move = i
            best = score
          end
        else
          if (score <= best)
            move = i
            best = score
          end
        end
      end
    end

    return move
  end

  # X wins: 10,   O wins: -10,    tie: 0
  # player = human, opp = AI
  # p: perspective
  def minimax(board, depth, player, pers, mode)

    # check for available spots on the board
    spots = 0.upto(8).select { |i| board[i] == 0 }

    # check for wins
    if (win?(board, player)) # player wins
      return 10 - depth
    elsif (win?(board, player == 1 ? 2 : 1)) # opponent wins
      return depth - 10
    elsif (spots.empty?) # tie game
      return 0
    end

    # if no winning or tie combination, continue to check for moves

    # initialize array of scores
    scores = []

    if (mode != MED || depth <= 1)
      spots.each do |m|
        # simulate board where p makes a move in m
        board[m] = pers

        # Store the score based on a sequence of moves starting with m.
        # The recursive call is made on the alternate perspective.
        scores << minimax(board, depth + 1, player, pers == 1 ? 2 : 1, mode)

        # revert back to original board
        board[m] = 0
      end
    end

    # find optimal move for player based on perspective
    return 0 if scores.empty?
    return pers == player ? scores.max : scores.min
  end

  def win?(board, pers)
    ((board[0] == pers && board[1] == pers && board[2] == pers) ||
     (board[3] == pers && board[4] == pers && board[5] == pers) ||
     (board[6] == pers && board[7] == pers && board[8] == pers) ||
     (board[0] == pers && board[3] == pers && board[6] == pers) ||
     (board[1] == pers && board[4] == pers && board[7] == pers) ||
     (board[2] == pers && board[5] == pers && board[8] == pers) ||
     (board[0] == pers && board[4] == pers && board[8] == pers) ||
     (board[2] == pers && board[4] == pers && board[6] == pers)) ? true : false
  end
end
