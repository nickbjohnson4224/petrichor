import lupa

def load_game(uri, params=None):
    lang, path = uri.split(':', 1)
    if lang == 'lua':
        return LuaGame(module='lua.game.' + path, params=params)

class LuaGame(object):
    
    def __init__(self, module=None, script='', params=None):
        self._runtime = lupa.LuaRuntime()

        if module is not None:
            self._game = self._runtime.require(module)
        elif script is not None:
            self._game = self._runtime.execute(script)

        self._params = params
        self._players = None

    def _new_model(self):
        if self._params is None:
            return self._game()
        else:
            return self._game(self._params)

    @property
    def players(self):
        if self._players is None:
            self._players = list(self._new_model().players())
        return self._players

    def start(self):
        model = self._new_model()

        model.init()
        return LuaGameModel(self, model)

    def load(self, state):
        model = self._new_model()

        model.load(state)
        return LuaGameModel(self, model)

def lua_table_to_document(table):

    if isinstance(table, int) or \
       isinstance(table, float) or \
       isinstance(table, basestring) or \
       table is None:
        return table

    keys = list(table)
    if len(keys) == 0:
        return []
    if keys[0] == 1 and keys[-1] == len(keys):
        return [lua_table_to_document(value) for value in table.values()]
    return {key: lua_table_to_document(table[key]) for key in keys}

class LuaGameModel(object):

    def __init__(self, game, model):
        self.game = game
        self._runtime = game._runtime
        self._model = model
        self._clear_caches()

    def _clear_caches(self):
        self._state_cache = None
        self._document = None
        self._moves = None
        self._player = None
        self._children = None
        self._reward = None

    @property
    def _state(self):
        if self._state_cache is None:
            self._state_cache = self._model.save()
        return self._state_cache

    def clone(self):
        return self.game.load(self._state)

    def features(self, player):
        return list(self._model.features(player).values())

    @property
    def moves(self):
        if self._moves is None:
            self._moves = list(self._model.moves().values())
        return self._moves

    def move(self, move):
        self._clear_caches()
        self._model.move(move)
        return self

    def lua_inject(self, script, *args):
        self._clear_caches()
        return self._runtime.execute(script)(self._model, *args)

    @property
    def player(self):
        if self._player is None:
            self._player = self._model.next_player()
        return self._player

    @property
    def reward(self):
        if self._reward is None:
            reward = self._model.reward()
            if reward is None:
                return None
            else:
                self._reward = dict(reward)
        return self._reward

    @property
    def document(self):
        if self._document is None:
            self._document = lua_table_to_document(self._state)
        return self._document

    def child(self, move):
        clone = self.clone()
        clone.move(move)
        return clone

    @property
    def children(self):
        if self._children is None:
            self._children = (self.child(move) for move in self.moves)
        return self._children
