#include <array>
#include <cstdint>
#include <cstring>
#include <iostream>

#define WIN32_LEAN_AND_MEAN
#include <Windows.h>

#include <DetourHook.hpp>

namespace
{
void detour_fixture()
{
}

bool create_succeeds(const std::uint8_t* bytes, std::size_t size)
{
    void* page = VirtualAlloc(nullptr, 4096, MEM_COMMIT | MEM_RESERVE, PAGE_EXECUTE_READWRITE);
    if (page == nullptr)
    {
        throw std::runtime_error("VirtualAlloc failed");
    }

    std::memset(page, 0xCC, 4096);
    std::memcpy(page, bytes, size);

    soup::DetourHook hook;
    hook.target = page;
    hook.detour = reinterpret_cast<void*>(&detour_fixture);
    bool created = false;
    try
    {
        hook.create();
        created = hook.isCreated();
        hook.destroy();
    }
    catch (...)
    {
        hook.destroy();
        VirtualFree(page, 0, MEM_RELEASE);
        return false;
    }

    VirtualFree(page, 0, MEM_RELEASE);
    return created;
}
}

int main()
{
    // Exact U43 interrupt-counter leaf at Warframe.x64.exe RVA 0x1AB150:
    // inc dword ptr [rcx+88h]; mov eax,[rcx+88h]; ret.
    constexpr std::array<std::uint8_t, 13> counter_leaf{
        0xFF, 0x81, 0x88, 0x00, 0x00, 0x00,
        0x8B, 0x81, 0x88, 0x00, 0x00, 0x00,
        0xC3,
    };

    // Exact prefix of the rejected V107 guard callback. The relative JNS is
    // deliberately inside Soup's 13-byte stolen span.
    constexpr std::array<std::uint8_t, 17> branch_heavy_guard{
        0x85, 0xD2, 0x79, 0x19, 0x53, 0x48, 0x83, 0xEC, 0x20,
        0x48, 0x8B, 0xD9, 0xE8, 0xBF, 0x28, 0x83, 0xFE,
    };

    if (!create_succeeds(counter_leaf.data(), counter_leaf.size()))
    {
        std::cerr << "FAIL relocation-safe counter leaf was rejected by the real Soup DetourHook builder\n";
        return 1;
    }
    if (create_succeeds(branch_heavy_guard.data(), branch_heavy_guard.size()))
    {
        std::cerr << "FAIL branch-heavy V107 guard unexpectedly passed the real Soup DetourHook builder\n";
        return 1;
    }

    std::cout << "DETOUR RELOCATABILITY PASS counter_leaf=create branch_guard=reject builder=Soup::DetourHook\n";
    return 0;
}
