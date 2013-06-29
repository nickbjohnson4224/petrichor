#include "petrichor.hpp"

//
// Builtin Games
//

namespace BuiltinGames {

class Nim : public Petrichor::GameImpl {
public:
    Nim(int _heap_count, int _heap_size, int _players) 
    : heap_count(_heap_count), heap_size(_heap_size) {}
        
private:
    const int heap_count;
    const int heap_size;
};

class NimState : public RockFarm::StateImpl {
    friend class Nim;

public:

    NimState(const Nim& game, const std::vector<int>& _heaps)
    : RockFarm::StateImpl(game), heaps(_heaps) {
        this->next_player = 0;
    }

private:
    
    void recompute(void) {
        this->is_finished = true;
        for (auto heap : this->heaps) {
            if (heap) {
                this->is_finished = false;
                for (int i = 1; i < heap; ++i)
            }
        }

        if (this->is_finished) {
            
    }

    std::vector<int> heaps;
}

}

//
// Game Loader (Factory Multiplexer)
//

Petrichor::GameImpl *Petrichor::load_game_impl(const std::string& url) {
    return new Nim(
}
