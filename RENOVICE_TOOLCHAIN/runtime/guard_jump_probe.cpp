// Toolchain probe for verify_guard_nonunwinding_jump.ps1 (2026-10-08).
// Mirrors the native fault guard of renovice/injection.cpp: a noexcept leaf arms a vectored
// exception handler and a jump buffer, calls through further frames (noexcept when
// MIDDLE_NOEXCEPT=1, each holding a call that may throw, so the frame carries a terminate scope)
// into native code that faults; the handler jumps back to the leaf.
//   BUILTIN_JUMP=0: CRT setjmp/std::longjmp (unwinding on the MSVC target)
//   BUILTIN_JUMP=1: __builtin_setjmp/__builtin_longjmp (non-unwinding, what the guard uses)
// Prints RECOVERED and exits 0 when the leaf regains control.
#include <windows.h>
#include <csetjmp>
#include <cstdio>

#if BUILTIN_JUMP
static void* jump[5];
#define PROBE_SETJMP(b) __builtin_setjmp(b)
#define PROBE_LONGJMP(b) __builtin_longjmp(b, 1)
#else
static jmp_buf jump;
#define PROBE_SETJMP(b) setjmp(b)
#define PROBE_LONGJMP(b) longjmp(b, 1)
#endif

#if MIDDLE_NOEXCEPT
#define PROBE_NOEXCEPT noexcept
#else
#define PROBE_NOEXCEPT
#endif

static LONG CALLBACK handler(EXCEPTION_POINTERS* info)
{
	if (info->ExceptionRecord->ExceptionCode == EXCEPTION_ACCESS_VIOLATION) PROBE_LONGJMP(jump);
	return EXCEPTION_CONTINUE_SEARCH;
}

extern "C" __declspec(noinline) void native_fault(volatile int* p)
{
	*p = 1;
}

__declspec(noinline) void may_throw(int x)
{
	if (x == 42) throw x;
	std::printf(".");
}

__declspec(noinline) void inner_leaf(volatile int* p) PROBE_NOEXCEPT
{
	may_throw(1);
	native_fault(p);
	may_throw(2);
}

__declspec(noinline) int middle(volatile int* p) PROBE_NOEXCEPT
{
	may_throw(3);
	inner_leaf(p);
	may_throw(4);
	return 1;
}

__declspec(noinline) void guarded_leaf(volatile int* p) noexcept
{
	PVOID h = AddVectoredExceptionHandler(1, handler);
	if (PROBE_SETJMP(jump) != 0)
	{
		RemoveVectoredExceptionHandler(h);
		std::printf("RECOVERED\n");
		return;
	}
	middle(p);
	RemoveVectoredExceptionHandler(h);
	std::printf("NO FAULT\n");
}

int main()
{
	guarded_leaf(nullptr);
	std::fflush(stdout);
	return 0;
}
