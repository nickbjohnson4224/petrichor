return function(player)
	local self = {}

	function self.choose(model, rand)
		local moves = model.moves()
		return moves[rand(#moves)]
	end

	return self
end
