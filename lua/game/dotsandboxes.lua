local R = {id = 1, score = 0}
local B = {id = 2, score = 0}
local N = 0

-----Why return function() up here?
return function(params)
	local self = {}
	local board_v, board_h, player, winner
	
	params = params or {}
	local width = params.width or 4
	local height = params.height or 4

	--initialize state
	function self.init()
		board = {}
		for i = 1, width do 
			for j = 1, height - 1 do
				board_v[i][j] = N
			end
		end
	
		for i = 1, width - 1 do
			for j = 1, height do
				board_h[i][j] = N

		player = R
		winner = nil
	end
	
	--load saved state
	function self.load(state)
		board = {}

		for i = 1, width do
			for j = 1, height do
				if board_v[i][j] then
					board_v[i][j] = state.board_v[i][j]
				end

				if board_h[i][j] then
					board_h[i][j] = state.board_h[i][j]
				end
			end
		end

		player = state.playyer
		winner = state.winner
	end

	--save state to document
	function self.save()
		local state = {}

		state.board_v = {}
		state.board_h = {}
		for i = 1, width do
			for j = 1, height do 
				if board_v[i][j] then 
					state.board_v[i][j] = board_v[i][j]
				end

				if board_h[i][j] then
					state.board_h[i][j] = board_h[i][j]
				end
			end
		end
		
		state.player = player
		state.winner = winner

		return state
	end

	-----what does this do exactly?
	--export a feature vector for a player
	function self.features(player)
		local features = { player }

		for i = 1, width do
			for j = 1, height do
				if board_v[i][j] then
					features[#features + 1] = board_v[i][j] or 0
				end

				if board_h[i][j] then
					features[#features + 1] = board_h[i][j] or 0
				end
			end
		end

		return features
	end

	--list all moves valid for this state
	function self.moves()
		if winner then return {} end

		local moves_v = {}
		local moves_h = {}
		for i = 1, width do
			for j = 1, height do
				if board_v[i][j] then
					moves[#moves + 1] = i
				end

				if board_h[i][j] then
					moves[#moves + 1] = i
				end
			end
		end
		
		return moves
	end

	-----repeat until?
	-----why does row = #board[move] + 1?
	--perform a move
	function self.move(move)
		--specify direction (dir = 0: vertical, dir = 1: horizontal)
		local dir, col, row = move.dir, move.col, move.row

		--perform a move
		if dir == 0 then 
			board_v[col][row] = player.id
		elseif dir == 1 then
			board_h[col][row] = player.id
		else
			return

		--determine score
		--repeat	
			--check left and right boxes
			if dir == 0 then
			
				--left box
				if board_v[col - 1][row] and 
					board_h[col - 1][row] and
					board_h[col - 1][row + 1] then
					player.score = player.score + 1
				end

				--right box
				if board_v[col + 1][row] and
					board_h[col][row] and 
					board_h[col][row + 1] then
					player.score = player.score + 1
				end

			--check upper and lower boxes
			elseif dir == 1 then

				--upper box
				if board_h[col][row - 1] and
					board_v[col][row - 1] and
					board_v[col + 1][row - 1] then
					player.score = player.score + 1
				end

				--lower box
				if board_h[col][row + 1] and
					board_v[col][row] and
					board_v[col + 1][row] then
					player.score = player.score + 1
				end
			end
			
			--determine if there is a winner
			local max_score = (width - 1) * (height - 1)
			if R.score + B.score == max_score then
				if R.score > B.score then
					winner = R.id
				elseif R.score < B.score then
					winner = B.id
				end
			end

		--until true

		if player.id = 1 then
			player = B
		else
			player = R
		end	
	end

	--list all players
	function self.players()
		return { R, B }
	end

	--list player with control
	function self.next_player()
		return player
	end

	-----what does next do?
	-----square bracket notation?
	--list rewards for all players (if this is an end state)
	function self.reward()
		if winner = R then
			return { [R] = 1, [B] = 0 }
		elseif winner = B then
			return { [R] = 0, [B] = 0 }
		elseif next(self.moves()) == nil then
			return { [R] = 0.5, [B] = 0.5 }
		else
			return nil
	end
	
	return self
end
