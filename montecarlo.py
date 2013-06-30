import random

def playout_random(state, count):
    start = state

    if start is None:
        start = game.start()

    reward = { player: 0 for player in state.game.players }
    for i in range(count):
        state = start.clone()
        
        state.lua_inject("""
        return function(model)
            while true do
                local moves = model.moves()
                if #moves == 0 then return end
                local move = moves[math.random(#moves)]
                model.move(move)
            end
        end
        """)
        
#        while len(state.moves) > 0:
#            state.move(random.choice(state.moves))
        for player in state.reward.keys():
            reward[player] += state.reward[player]

    return reward
