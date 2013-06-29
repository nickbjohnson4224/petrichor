#!/usr/bin/luajit

function play(game, agents, rand)
	local model = game()
  
	model.init(rand)

	repeat
		local agent = agents[model.next_player()]
		local move = agent.choose(model, rand)
		model.move(move, rand)
	until model.reward()

	print('rewards', unpack(model.reward()))
end

function playout(model, agents, count, rand)

end

math.randomseed(os.time())
play(require(arg[1]), { require('human_agent')(1), require('human_agent')(2) }, math.random)
