return function(player)
	local self = {}

	function self.choose(model, rand)
		io.write(model.display_state(), '\n')
		local moves = model.moves()
		for i, move in ipairs(moves) do
			io.write(i, ') ', model.display_move(move), '\t')
		end
		io.write('\n')

		local move_index
		repeat
			io.write('> ')
			io.flush()
			move_index = io.read('*number')
			if move_index == nil then
				io.read('*line')
			end
		until moves[move_index] ~= nil

		return moves[move_index]
	end

	return self
end
