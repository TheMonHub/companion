local ffi = require("ffi")

ffi.cdef[[
typedef void* HWND;
typedef int BOOL;
typedef int INT;
typedef unsigned int UINT;

static const int SWP_NOSIZE = 0x0001;
static const int SWP_NOMOVE = 0x0002;
static const int SWP_NOACTIVATE = 0x0010;
static const int HWND_TOPMOST = -1;
static const int HWND_NOTOPMOST = -2;

BOOL SetWindowPos(
    HWND hWnd,
    HWND hWndInsertAfter,
    INT X,
    INT Y,
    INT cx,
    INT cy,
    UINT uFlags
);

HWND GetActiveWindow();
]]

local user32 = ffi.load("user32")

local hwnd = user32.GetActiveWindow()

user32.SetWindowPos(hwnd, ffi.cast("HWND", ffi.C.HWND_TOPMOST), 0, 0, 0, 0,
        bit.bor(ffi.C.SWP_NOMOVE, ffi.C.SWP_NOSIZE, ffi.C.SWP_NOACTIVATE))

return