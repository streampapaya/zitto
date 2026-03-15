const types = @import("win32_types.zig");

pub extern "user32" fn CreateWindowExW(
    dwExStyle: u32,
    lpClassName: [*:0]const u16,
    lpWindowName: [*:0]const u16,
    dwStyle: u32,
    X: i32,
    Y: i32,
    nWidth: i32,
    nHeight: i32,
    hWndParent: types.HWND,
    hMenu: ?*anyopaque,
    hInstance: types.HINSTANCE,
    lpParam: ?*anyopaque,
) types.HWND;

pub extern "user32" fn DestroyWindow(
    hwnd: types.HWND,
) bool;

pub extern "user32" fn RegisterClassW(
    lpWndClass: *types.WNDCLASSW,
) u16;

pub extern "user32" fn DefWindowProcW(
    hwnd: types.HWND,
    msg: u32,
    wParam: usize,
    lParam: isize,
) isize;

pub extern "user32" fn LoadCursorW(
    hInstance: types.HINSTANCE,
    lpCursorName: ?[*:0]const u16,
) ?*anyopaque;

pub extern "user32" fn GetMessageW(
    lpMsg: *types.MSG,
    hwnd: types.HWND,
    wMsgFilterMin: u32,
    wMsgFilterMax: u32,
) i32;

pub extern "user32" fn TranslateMessage(
    lpMsg: *types.MSG,
) bool;

pub extern "user32" fn DispatchMessageW(
    lpMsg: *types.MSG,
) isize;

pub extern "user32" fn PostQuitMessage(
    exitCode: i32,
) void;

pub extern "kernel32" fn GetModuleHandleW(
    name: ?[*:0]const u16,
) types.HINSTANCE;

pub extern "user32" fn BeginPaint(
    hwnd: types.HWND,
    ps: *types.PAINTSTRUCT,
) ?*anyopaque;

pub extern "user32" fn EndPaint(
    hwnd: types.HWND,
    ps: *types.PAINTSTRUCT,
) bool;

pub extern "gdi32" fn CreateSolidBrush(
    color: u32,
) ?*anyopaque;

pub extern "gdi32" fn CreatePen(
    iStyle: i32,
    cWidth: i32,
    color: u32,
) ?*anyopaque;

pub extern "gdi32" fn SelectObject(
    hdc: ?*anyopaque,
    obj: ?*anyopaque,
) ?*anyopaque;

pub extern "gdi32" fn DeleteObject(
    obj: ?*anyopaque,
) bool;

pub extern "gdi32" fn Rectangle(
    hdc: ?*anyopaque,
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
) bool;

pub extern "gdi32" fn Ellipse(
    hdc: ?*anyopaque,
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
) bool;

pub extern "user32" fn FillRect(
    hdc: ?*anyopaque,
    rect: *const types.RECT,
    hbr: ?*anyopaque,
) i32;

pub extern "user32" fn InvalidateRect(
    hwnd: types.HWND,
    rect: ?*anyopaque,
    erase: bool,
) bool;

pub extern "user32" fn GetWindowRect(
    hwnd: types.HWND,
    rect: *types.RECT,
) bool;

pub extern "user32" fn GetClientRect(
    hwnd: types.HWND,
    rect: *types.RECT,
) bool;

pub extern "user32" fn ShowWindow(
    hwnd: types.HWND,
    nCmdShow: i32,
) bool;

pub extern "user32" fn IsZoomed(
    hwnd: types.HWND,
) bool;

pub extern "user32" fn UpdateWindow(
    hwnd: types.HWND,
) bool;

pub extern "user32" fn SetWindowPos(
    hwnd: types.HWND,
    hWndInsertAfter: types.HWND,
    X: i32,
    Y: i32,
    cx: i32,
    cy: i32,
    uFlags: u32,
) bool;

pub extern "user32" fn MonitorFromWindow(
    hwnd: types.HWND,
    dwFlags: u32,
) types.HMONITOR;

pub extern "user32" fn GetMonitorInfoW(
    hMonitor: types.HMONITOR,
    lpmi: *types.MONITORINFO,
) bool;

pub extern "kernel32" fn Sleep(
    dwMilliseconds: u32,
) void;
