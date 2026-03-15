pub const HWND = ?*anyopaque;
pub const HINSTANCE = ?*anyopaque;
pub const HBRUSH = ?*anyopaque;

pub const MSG = extern struct {
    hwnd: HWND,
    message: u32,
    wParam: usize,
    lParam: isize,
    time: u32,
    pt_x: i32,
    pt_y: i32,
};

pub const PAINTSTRUCT = extern struct {
    hdc: ?*anyopaque,
    fErase: bool,
    rcPaint_left: i32,
    rcPaint_top: i32,
    rcPaint_right: i32,
    rcPaint_bottom: i32,
    fRestore: bool,
    fIncUpdate: bool,
    rgbReserved: [32]u8,
};

pub const RECT = extern struct {
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
};

pub const HMONITOR = ?*anyopaque;

pub const MONITORINFO = extern struct {
    cbSize: u32,
    rcMonitor: RECT,
    rcWork: RECT,
    dwFlags: u32,
};

pub const WNDCLASSW = extern struct {
    style: u32,
    lpfnWndProc: *const fn (HWND, u32, usize, isize) callconv(.c) isize,
    cbClsExtra: i32,
    cbWndExtra: i32,
    hInstance: HINSTANCE,
    hIcon: ?*anyopaque,
    hCursor: ?*anyopaque,
    hbrBackground: HBRUSH,
    lpszMenuName: ?[*:0]const u16,
    lpszClassName: [*:0]const u16,
};
