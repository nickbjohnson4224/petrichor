#include <iostream>
#include <memory>

#include "petrichor.hpp"

using namespace Petrichor;
using namespace std;

vector<double> playout(State state, const vector<const Agent*>& agents, Random& rand) {
    
    while (!state.is_finished()) {
        auto agent = agents[state.next_player()];
        state.move_mutate(agent->select(state, rand), rand);
    }

    return state.rewards();
}

class RandomAgent : public Agent {
public:
    move_t select(State state, Random& rand) const {
        return state.moves()[rand.next_int(state.moves().size())];
    }
};

int main(int argc, char **argv) {
    Random rand;
    
    auto state = Game("builtin:nim?heap_count=3&heap_size=5&players=2").start(rand);

    vector<const Agent*> agents { new RandomAgent(), new RandomAgent() };

    vector<double> total_reward(state.moves().size());
    for (auto move : state.moves()) {
        total_reward[move] = 0;
        for (int i = 0; i < 100; i++) {
            total_reward[move] += playout(state.move(move, rand), agents, rand)[0];
        }
        total_reward[move];
        cout << move << "\t" << total_reward[move] << endl;
    }

    return 0;
}
