
def minimax_value(game, depth, value, model=None):

    if model is None:
        model = game.start()

    if depth == 0:
        return value(model)

    if len(model.moves) == 0:
        return value(model)

    return max(
        (minimax_value(game, depth-1, value, model=child) 
         for child in model.children),
        key=lambda v: v[model.player]
    )

def minimax_choose(game, depth, value, model=None):
    
    if model is None:
        model = game.start()

    return max(
        ((move, minimax_value(game, depth-1, value, model=model.child(move)))
         for move in model.moves),
        key=lambda v: v[1][model.player]
    )
