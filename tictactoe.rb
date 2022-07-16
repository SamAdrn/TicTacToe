# Consists of the main Tic Tac Toe game logic
# @author {https://github.com/SamAdrn Samuel Kosasih}
module TicTacToe

  # A hash constant mapping +Integer+ values to their respective symbols
  SYMS = { 0 => " ", 1 => "X", 2 => "O" }

  # +Integer+ constant to denote the game's EASY mode
  EASY = 1

  # +Integer+ constant to denote the game's MEDIUM mode
  MED = 2

  # +Integer+ constant to denote the game's IMPOSSIBLE mode
  HARD = 3

  # Displays the board provided as the argument +board+ with the translated
  # symbols. The argument +board+ must always be an +Integer+ array of size 9
  # filled with the value of +0+, +1+, or +2+, to denote the following:
  # - +0+ : Empty Spot
  # - +1+ : Spot taken by +'X'+
  # - +2+ : Spot taken by +'O'+
  #
  # The symbols represented will be based on the elements at their respective
  # indices in grid order, as in +0 1 2+ for the first row, +3 4 5+ for the
  # second row, and +6 7 8+ for the third row.
  #
  # @example Printing the board [1, 2, 1, 2, 2, 0, 0, 1, 0]
  #    X | O | X
  #    O | O |
  #      | X |
  #
  # @param board [Array<Integer>] the board to be displayed
  #
  # @return [void]
  def print_board(board)
    ["+-----------+\n",
     "| #{SYMS[board[0]]} | #{SYMS[board[1]]} | #{SYMS[board[2]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[3]]} | #{SYMS[board[4]]} | #{SYMS[board[5]]} |\n",
     "+-----------+\n",
     "| #{SYMS[board[6]]} | #{SYMS[board[7]]} | #{SYMS[board[8]]} |\n",
     "+-----------+\n"]
  end

  # Retrieves the next best move for the CPU based on the current board.
  # It decides based on the arguments given to the 4 parameters. Here, +pers+
  # denotes the perspective for the move to be based upon, whether that be the
  # player or the CPU. The function can differentiate between the two by using
  # the +player+ parameter, such that if +pers == player+, we are finding the
  # best possible move for the player.
  #
  # There are three possible modes to this function, selected using the +mode+
  # parameter, and denoted by their respective constants:
  # - +EASY+ (1) : The move is selected randomly, based on the available spots
  #   that exist in the +board+, with no basis to the decision at all.
  # - +MED+ (2)  : This mode utilizes the {#minimax} function partially, looking
  #   only two steps ahead. This mode does not really employ any strategies to
  #   win the game. However, it will block the opponent from having obvious
  #   wins, particularly in cases where the opponent already has two symbols in
  #   a row.
  # - +HARD+ (3) : This mode utilizes the {#minimax} function fully, simulating
  #   +pers+ to be a perfect player. It looks through every possibility by
  #   traversing every sequence of moves based on the available spots.
  #
  # @example Retrieving a move for a MEDIUM CPU opponent
  #    get_move(board, 0, 1, MED) # note the difference of player and pers
  #
  # @example Retrieving a move for a player
  #    get_move(board, 0, 0, HARD)
  #
  # @param board [Array<Integer>] an +Integer+ array of size 9, representing
  #    the Tic Tac Toe board
  # @param player [Integer] the symbol to represent the player
  # @param pers [Integer] the symbol to represent the perspective of the move
  #    to get
  # @param mode [Integer] an integer value to denote the mode
  #
  # @return [Integer] returns the move representing the index of the board
  def get_move(board, player, pers, mode)
    # EASY mode -- randomly select an available spot
    return 0.upto(8).select { |i| board[i] == 0 }.sample if (mode == EASY)

    # initialize tracker values, with the player being the maximizer
    best = pers == player ? -100 : 100
    move = -1

    # simulate board for all available moves
    0.upto(8) do |i|
      if (board[i] == 0) # skip taken spots
        # simulate board where p makes a move in m
        board[i] = pers

        # Store the score based on a sequence of moves starting with m.
        # The recursive call is made on the alternate perspective.
        # The MEDIUM and HARD modes depend on the mode argument to minimax.
        score = minimax(board, 0, player, pers == 1 ? 2 : 1, mode)

        # revert back to original board
        board[i] = 0

        # determine whether to update the best score and the best move based on
        # whether pers is the minimizer or the maximizer
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

  # Evaluates the odds of winning/losing based on the available spots on the
  # board. It is used in the {#get_move} function extensively to retrieve the
  # best possible move for a certain perspective +pers+.
  #
  # The function incorporates the minimax algorithm in order to evaluate the
  # best scores, where the player is always the maximizer (prefers higher
  # scores). What it does can be summarized within the following steps:
  # 1. For every available spot in +board+, simulate a move for +pers+ by
  #    recursively calling the function on the simulated board, but for the
  #    opposing perspective.
  # 2. In every recursive call, simulate a move for the remaining available
  #    spots on the board, but on the alternate perspective.
  # 3. Continue making recursive calls until an endgame is reached, in which a
  #    score is computed based on the results of that specific simulation.
  #
  # Since the function makes a number of recursive calls, we maintain a +depth+
  # counter to help the function determine how many turns until it wins or
  # loses. A tie game would always result in 0, regardless of perspective. But
  # it is important to know the proximity of a win/lose so it would have a bias
  # of picking the one in closer proximity. In this algorithm, the maximum
  # possible score returned is +10+, in which +player+ would have won. The
  # minimum score returned is +-10+, in which +player+ would have lost. These
  # are convenient values since in an empty board, the maximum depth is +9+, and
  # we will still be able to indicate a tie game.
  #
  # This function may be expensive in emptier boards. In an empty board, for
  # example, each spot would lead to 9! recursive calls. However, for each spot,
  # the maximum depth of recursion is only 9, since after all the spots in the
  # board get evaluated, the function returns a score,
  #
  # As an example, we have the board [1, 2, 1, 2, 2, 0, 0, 1, 0], where 1 and 2
  # represent distinct players, and 0 represents empty spots.
  #    X | O | X
  #    O | O |
  #      | X |
  # If it was player 1's turn (X), here is how the algorithm would evaluate
  # scores for every spot. Note that available spots are +[5, 6, 8]+.
  # - If X took spot 5, then O will take either spots 6 or 8. Regardless, the
  #   game will end in a tie. So spot 5 evaluates to a score of +0+.
  # - If X took spot 6, then O will take either spots 5 or 8. If O were to
  #   choose spot 5, then O would win the game, resulting in a score of +-8+.
  #   On the other hand, if O were to choose spot 8, then the game would result
  #   in a tie, resulting in a score of +0+. However, at this function call, the
  #   score returned will be the minimum because the current iteration takes the
  #   perspective of O (the minimizer).
  #   Therefore, spot 5 evaluates to a score of +-8+.
  # - Similarly, if X took spot 8, the same case would happen if X were to take
  #   spot 6, where O has the possibility of winning by taking spot 5.
  #   Therefore spot 8 evaluates to a score of +-8+.
  # If we present these results into a hash, then we'd have +{5 => 0, 6 => -8,
  # 8 => -8}+. The maximum score belongs to spot 5. Therefore, the function
  # will return the score 0.
  #
  # @example The function call for the evaluation above
  #    minimax([1, 2, 1, 2, 2, 0, 0, 1, 0], 0, 1, 1, HARD)
  #
  # @param board [Array<Integer>] an +Integer+ array of size 9, representing
  #    the Tic Tac Toe board to be evaluated
  # @param depth [Integer] a placeholder value to keep track of recursion depth
  # @param player [Integer] the symbol to represent the player
  # @param pers [Integer] the symbol to represent the perspective of the
  #        simulated board
  # @param mode [Integer] an integer value to denote the mode
  #
  # @return [Integer] an +Integer+ value representing the best score from all
  #          the spots on the board
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

  # Checks for winning combinations.
  #
  # @param board [Array<Integer>] an +Integer+ array of size 9, representing
  #    the Tic Tac Toe board to be checked
  # @param pers [Integer] the perspective to be checked
  #
  # @return [Boolean] an indicator whether +pers+ has won in the board +board+
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
