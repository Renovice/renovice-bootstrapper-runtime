#include <cstdint>
#include <cstddef>
#include <cstring>
#include <iostream>
#include <stdexcept>
#include "game_string_under_test.hpp"
static void require(bool b) { if (!b) throw std::runtime_error("GameString ownership regression"); }
int main() {
 const char text[] = "borrowed string longer than the inline buffer";
 for (auto version : {GV(43,0,0), GV(44,0,0)}) {
  game_version=version;
  for (size_t len : {size_t(0),size_t(1),size_t(14),size_t(15),size_t(16),sizeof(text)-1}) {
   GameString s{}; s.setUnownedData(text,len);
   require(s.getSize()==len && std::memcmp(s.getData(),text,len)==0);
   require(s.isLong()==(len>15));
   if (len>15) {
    require(s.lng.ptr==text);
    if(version==GV(44,0,0)) require(s.lng.metadata<0xff00000010000000ull);
    else require((s.lng.metadata & 0xffffffffff000000ull)==0xfffffffff0000000ull);
    s.shrink(2);require(s.getSize()==2);
    if(version==GV(44,0,0)) require(s.lng.metadata<0xff00000010000000ull);
   }
  }
 }
 game_version=GV(44,0,0);
 GameString owned{};owned.lng.ptr=const_cast<char*>(text);owned.lng.metadata=0xff00000200000020ull;
 owned.shrink(3);require(owned.lng.metadata==0xff00000200000003ull && owned.getSize()==3);
 // Captured crash header was incorrectly freed by the U44 native destructor.
 require(0xfffffffff00015c5ull>=0xff00000010000000ull);
 GameString patched{};patched.setUnownedData(text,0x15c5);
 require(patched.lng.metadata==0xff000000000015c5ull);
 std::cout<<"GAME STRING OWNERSHIP PASS: U43/U44 inline, borrowed, shrink and owned-capacity cases\n";
}
