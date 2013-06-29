local N = 0
local X = 1
local O = 2

return function()
	local self = {}
	local board, next_player, winner

	-- initialize the model state
	function self.init(rand)
		board = {
			N, N, N,
			N, N, N,
			N, N, N
		}
		next_player = X
	end

	-- import the state of the model
	function self.load(state)
		board = state.board
		next_player = state.next_player
	end

	-- export the state of the model
	function self.save()
		return {
			board = board,
			next_player = next_player
		}
	end

	-- export a feature vector for a player
	function self.features(player)
		return {
			next_player,
			board[1], board[2], board[3],
			board[4], board[5], board[6],
			board[7], board[8], board[9]
		}
	end

	-- list all moves valid for this model state
	function self.moves()
		if winner then 
			return {} 
		end
		
		local moves = {}
		for i = 1, 9 do
			if board[i] == N then
				moves[#moves+1] = i
			end
		end
		return moves
	end

	-- perform a move
	function self.move(move, rand)

		-- perform move
		board[move] = next_player

		-- determine if there is a winner
		repeat
			local col = (move - 1) % 3 + 1
			if board[col+0] == next_player and
				board[col+3] == next_player and
				board[col+6] == next_player then
				winner = next_player
				break
			end

			local row = (move - col) / 3
			if board[row+0] == next_player and
				board[row+1] == next_player and
				board[row+2] == next_player then
				winner = next_player
				break
			end

			if row == col and
				board[1] == next_player and
				board[5] == next_player and
				board[9] == next_player then
				winner = next_player
				break
			end

			if 4 - row == col and
				board[3] == next_player and
				board[5] == next_player and
				board[7] == next_player then
				winner = next_player
				break
			end
		until true

		-- update next player
		if next_player == X then
			next_player = O
		else
			next_player = X
		end
	end

	-- list all players
	function self.players()
		return { X, O }
	end

	-- list player with control of the model
	function self.next_player()
		return next_player
	end

	-- list rewards for all players (if this is an end state)
	function self.reward()
		if winner == X then
			return { 1, 0 }
		elseif winner == O then
			return { 0, 1 }
		elseif self.moves() == {} then
			return { 0.5, 0.5 }
		else
			return nil
		end
	end

	-- produce human-readable representation of game state
	function self.display_state()
		local symbols = { [N] = ' ', [X] = 'X', [O] = 'O' }
		return string.format(
			'%s|%s|%s\n-----\n%s|%s|%s\n-----\n%s|%s|%s',
			symbols[board[1]], symbols[board[2]], symbols[board[3]],
			symbols[board[4]], symbols[board[5]], symbols[board[6]],
			symbols[board[7]], symbols[board[8]], symbols[board[9]]
		)
	end

	-- produce human-readable representation of move
	function self.display_move(move)
		local col = (move - 1) % 3 + 1
		local row = (move - 1) / 3 + 1
		return string.format('(%d, %d)', col, row)
	end

	return self
end
