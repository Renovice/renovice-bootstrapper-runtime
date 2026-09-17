#define RENOVICE_ENGINE_DAMAGE_TEST 1
#include "../../renovice/engine_damage.cpp"
#include <fstream>
#include <iostream>

std::vector<std::string> captured;
namespace renovice::config {
void diagnostic_log(std::string_view record, DiagnosticsMode) noexcept {
    captured.emplace_back(record);
}
}
namespace {
std::uint32_t calls = 0;
bool nested = false, simulate_nested = false;
void set_integer(std::uintptr_t address, std::int32_t value) {
    const auto encoded = std::rotr(std::bit_cast<std::uint32_t>(value)
        ^ static_cast<std::uint32_t>(address >> 3) ^ 0xc55198a3u,19);
    std::memcpy(reinterpret_cast<void*>(address), &encoded, sizeof(encoded));
}
void mock_stock(void* control, void* packet) {
    ++calls;
    std::uintptr_t target = 0;
    std::memcpy(&target, static_cast<char*>(control)+0x28, sizeof(target));
    auto hp_address = target+0x50c;
    std::uint32_t encoded;
    std::memcpy(&encoded,reinterpret_cast<void*>(hp_address),4);
    set_integer(hp_address,renovice::engine_damage::decode_integer(encoded,hp_address)-133);
    if (simulate_nested && !nested) {
        nested = true;
        renovice::engine_damage::bridge<1>(control,packet);
        nested = false;
    }
}
struct Target {
    std::array<unsigned char,0x600> object{};
    std::array<unsigned char,0x2000> control{};
    std::array<std::uintptr_t,0x400/8> target_table{}, control_table{};
    std::array<unsigned char,24> health_code{}, shield_code{}, overguard_code{};
    static void getter(std::array<unsigned char,24>& code, std::uint32_t offset) {
        constexpr std::array<unsigned char,24> shape{
            0x48,0x81,0xc1,0,0,0,0,0x8b,0x01,0xc1,0xc0,0x13,0x48,0xc1,0xf9,0x03,
            0x33,0xc1,0x35,0xa3,0x98,0x51,0xc5,0xc3};
        code=shape;std::memcpy(code.data()+3,&offset,4);
    }
    Target() {
        auto table=reinterpret_cast<std::uintptr_t>(target_table.data());
        std::memcpy(object.data(),&table,8);
        table=reinterpret_cast<std::uintptr_t>(control_table.data());
        std::memcpy(control.data(),&table,8);
        auto target=reinterpret_cast<std::uintptr_t>(object.data());
        std::memcpy(control.data()+0x28,&target,8);
        getter(health_code,0x50c);getter(shield_code,0x1e34);getter(overguard_code,0x100);
        target_table[0x340/8]=reinterpret_cast<std::uintptr_t>(health_code.data());
        control_table[0x2b8/8]=reinterpret_cast<std::uintptr_t>(shield_code.data());
        control_table[0x328/8]=reinterpret_cast<std::uintptr_t>(overguard_code.data());
        set_integer(target+0x50c,1000);
        set_integer(reinterpret_cast<std::uintptr_t>(control.data())+0x1e34,0);
        set_integer(reinterpret_cast<std::uintptr_t>(control.data())+0x100,0);
    }
};
}
int main(int argc,char** argv) {
    namespace config = renovice::config;
    using namespace renovice::engine_damage;
    std::array<unsigned char,0x280> packet{};
    const float raw=500,viral=1;
    std::memcpy(packet.data()+11*4,&viral,4);
    packet[0x60+0x30]=0x20;
    std::memcpy(packet.data()+0x60+0x24,&raw,4);
    const auto immutable_packet=packet;
    for(auto& hook:hooks)hook.original=&mock_stock;
    config::Flags flags;
    flags.diagnostics_mode=config::DiagnosticsMode::battle;
    flags.diagnostics_damage_capture=config::DamageCaptureMode::engine;
    if(!reconcile(flags))return 1;
    Source source;source.body=0x1234;source.name="AreaTest.lua";source.method="RadialDamage";
    source.caster_snapshot=42;
    SourceScope scope(&source);
    Target first,second;
    bridge<0>(first.control.data(),packet.data());
    bridge<0>(second.control.data(),packet.data());
    if(calls!=2 || captured.size()!=4 || packet!=immutable_packet
        || captured[1].find("\"HealthAfter\":867")==std::string::npos
        || captured[1].find("\"HealthLoss\":133")==std::string::npos
        || captured[1].find("\"CasterSnapshot\":42")==std::string::npos
        || captured[3].find("\"HealthLoss\":133")==std::string::npos)return 2;
    const auto accepted=captured;
    captured.clear();simulate_nested=true;
    bridge<0>(first.control.data(),packet.data());
    if(calls!=4 || captured.size()!=2
        || captured[1].find("\"HealthLoss\":266")==std::string::npos)return 3;
    simulate_nested=false;captured.clear();
    flags.diagnostics_damage_source="other.lua";
    reconcile(flags);bridge<0>(first.control.data(),packet.data());
    if(calls!=5 || !captured.empty())return 4;
    flags.diagnostics_mode=config::DiagnosticsMode::off;
    reconcile(flags);bridge<0>(first.control.data(),packet.data());
    if(calls!=6 || !captured.empty() || packet!=immutable_packet)return 5;
    if(argc>1){std::ofstream log(argv[1]);for(const auto& line:accepted)log<<line<<'\n';}
    std::cout<<"NATIVE DAMAGE OBSERVER PASS real pre/post capture, two targets sharing one packet, 133 HP loss, same-boundary nesting, exact filtering, off fast path, stock called once, immutable packet\n";
}
