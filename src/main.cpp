#include <winapi/winbase.h>
#include <xboxkrnl/xboxkrnl.h>
#include <xbdm.h>

void XbSleep(int milliseconds) {
	LARGE_INTEGER interval {
		.QuadPart = (long long) milliseconds * -10000
	};
	KeDelayExecutionThread(KernelMode, FALSE, &interval);
}

static VOID NTAPI DxtMainThread(PKSTART_ROUTINE StartRoutine, PVOID StartContext) {
	// A simple busy-loop. More interesting things could be put here
	while(1) {    
		XbSleep(1000);
	}
}

extern "C" {
	VOID NTAPI DxtEntry(ULONG* pfUnload) {
		ULONG stack_size = 8192;
		ULONG tls_size = 0;

		// Create a thread
		HANDLE handle;
		HANDLE id;
		NTSTATUS status = PsCreateSystemThreadEx(&handle, 0, stack_size, tls_size, &id, (PKSTART_ROUTINE)NULL, NULL, FALSE, FALSE, DxtMainThread);

		// Stay resident in memory.
		*pfUnload = FALSE;
	}
}
