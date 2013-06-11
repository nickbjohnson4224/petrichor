#include "rockfarm.hpp"

using namespace RockFarm;

RockFarm::Random::Random() {
    // TODO
}

RockFarm::Random::Random(const std::string& state) {
    // TODO
}

uint64_t RockFarm::Random::next_block(void) {
    uint64_t block = this->state[this->count & 0x7];
    if ((++count & 0x7) == 0) {
        this->state_regen();
    }
    return block;
}

double RockFarm::Random::next_unit(void) {
    uint64_t block = this->next_block();
    block = (block & 0xFFFFFFFFFFFFFULL) | 0x3FF0000000000000ULL;
    return (*(reinterpret_cast<double*>(&block))) - 1.0;
}

double RockFarm::Random::next_dblunit(void) {
    uint64_t block = this->next_block();
    block = (block & 0xFFFFFFFFFFFFFULL) | 0x4000000000000000ULL;
    return (*(reinterpret_cast<double*>(&block))) - 3.0;
}

size_t RockFarm::Random::next_int(size_t max) {
    return this->next_block() % (max + 1);
}

void RockFarm::Random::state_regen(void) {
    // TODO
}
