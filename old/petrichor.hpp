#include <stdint.h>
#include <string>
#include <vector>

namespace Petrichor {

typedef uint_fast32_t move_t;
typedef uint_fast16_t player_t;

class Random {
public:
    Random();
    Random(const std::string& state);

    // get the next 8 byte block in native byte order
    uint64_t next_block(void);

    // interpret next block as double in the range (0, 1) uniformly
    double next_unit(void);

    // interpret next block as double in the range (-1, 1) uniformly
    double next_dblunit(void);

    size_t next_int(size_t max);

    std::string save(void) const;

private: 
    void state_regen(void);

    uint64_t state[8];
    uint64_t count;
};

class GameImpl;
class Game;
class StateImpl;
class State;

class StateImpl {
public:
    StateImpl(const Game& _game) : game(_game), ref_count(1) {};
    virtual ~StateImpl() = default;

    virtual StateImpl* clone(void) const = 0;
    virtual std::string save(void) const = 0;
    virtual void move(move_t move, Random& rand) = 0;

    const Game& game;
    uint32_t ref_count;

    player_t next_player;
    std::vector<double> rewards;
    std::vector<move_t> moves;
    bool is_finished;
};

class State {
public:
    State(StateImpl* _impl) : impl(_impl) {}

    State(const State& other) : impl(other.impl) {
        impl->ref_count++;
    }

    State& operator=(const State& other) {
        if (this != &other) {
            if (!--impl->ref_count) {
                delete impl;
            }
            impl = other.impl;
            impl->ref_count++;
        }
        return *this;
    }

    ~State() {
        if (!--impl->ref_count) {
            delete impl;
        }
    }

    const Game& game(void) const {
        return impl->game;
    }

    std::string save() const {
        return impl->save();
    }

    player_t next_player(void) const {
        return impl->next_player;
    }

    const std::vector<double>& rewards(void) const {
        return impl->rewards;
    }

    const std::vector<move_t>& moves(void) const {
        return impl->moves;
    }

    bool is_finished(void) const { 
        return impl->is_finished; 
    }

    void move_mutate(move_t move, Random& rand) {
        impl->move(move, rand);
    }

    State move(move_t move, Random& rand) const {
        auto original = impl->clone();
        auto modified = impl;

        modified->move(move, rand);
        impl = original;
        
        return State(modified);
    }

    // TODO feature interface
private:
    mutable StateImpl* impl;
};

class GameImpl {
public:
    virtual ~GameImpl() = default;

    virtual StateImpl* start(Random& rand) const = 0;
    virtual StateImpl* load(const std::string& state) const = 0;

    std::vector<std::string> players;
    std::vector<std::string> moves;

    uint32_t ref_count;
};

GameImpl *load_game_impl(const std::string& url);

class Game {
public:
    Game(const std::string& url) : impl(load_game_impl(url)) {};
    ~Game() {
        if (!--impl->ref_count) {
            delete impl;
        }
    }

    State start(Random& rand) const {
        return State(impl->start(rand));
    }
    
    State load(const std::string& state) const {
        return State(impl->load(state));
    }

    const std::vector<std::string>& players(void) const {
        return impl->players;
    }

    const std::vector<std::string>& moves(void) const {
        return impl->moves;
    }

private:
    mutable GameImpl* impl;
};

class Agent {
public:
    virtual move_t select(State state, Random& rand) const = 0;
    virtual ~Agent() = default;
};

}
