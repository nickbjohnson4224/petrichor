local A = 1
local B = 2

return function(params)
	local self = {}
	local board, player, winner

	-- set game parameters
	params = params or {}
	local width = params.width or 7
	local height = params.height or 6

	-- initialize state
	function self.init()
		board = {}
		for i = 1, width do
			board[#board+1] = {}
		end

		player = A
		winner = nil
	end

	-- load saved state
	function self.load(state)
		board = {}
		for i = 1, width do
			board[i] = {}
			for j = 1, height do
				board[i][j] = state.board[i][j]
			end
		end

		player = state.player
		winner = state.winner
	end

	-- save state to document
	function self.save()
		local state = {}

		state.board = {}
		for i = 1, width do
			state.board[i] = {}
			for j = 1, height do
				state.board[i][j] = board[i][j]
			end
		end

		state.player = player
		state.winner = winner

		return state
	end

	-- export a feature vector for a player
	function self.features(player)
		local features = { player }
		
		for i = 1, width do
			for j = 1, height do
				features[#features+1] = board[i][j] or 0
			end
		end
		
		return features
	end

	-- list all moves valid for this state
	function self.moves()
		if winner then return {} end

		local moves = {}
		for i = 1, width do
			if #board[i] < height then
				moves[#moves+1] = i
			end
		end

		return moves
	end

	-- perform a move
	function self.move(move)
		local col, row = move, #board[move]+1

		-- perform move
		board[col][row] = player

		-- determine if there is a winner
		repeat
			local d
			
			--
			-- check upward diagonal
			--

			d = 1

			for i = 1, 3 do
				if board[col-i] and board[col-i][row-i] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			for i = 1, 3 do
				if board[col+i] and board[col+i][row+i] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			--
			-- check downward diagonal
			--

			d = 1

			for i = 1, 3 do
				if board[col-i] and board[col-i][row+i] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			for i = 1, 3 do
				if board[col+i] and board[col+i][row-i] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			--
			-- check horizontal
			--

			d = 1

			for i = 1, 3 do
				if board[col-i] and board[col-i][row] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			for i = 1, 3 do
				if board[col+i] and board[col+i][row] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

			--
			-- check vertical
			--

			d = 1

			for i = 1, 3 do
				if board[col][row-i] == player then
					d = d + 1
				else break
				end
			end

			if d >= 4 then
				winner = player
				break
			end

		until true

		-- switch players
		if player == A then
			player = B
		else
			player = A
		end
	end

	-- list all players
	function self.players()
		return { A, B }
	end

	-- list player with control
	function self.next_player()
		return player
	end

	-- list rewards for all players (if this is an end state)
	function self.reward()
		if winner == A then
			return { [A]=1, [B]=0 }
		elseif winner == B then
			return { [A]=0, [B]=1 }
		elseif next(self.moves()) == nil then
			return { [A]=0.5, [B]=0.5 }
		else
			return nil
		end
	end

	return self
end
