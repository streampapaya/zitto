const api = @import("win32_api.zig");
const types = @import("win32_types.zig");
const w = @import("win32_constants.zig");
const wm_paint = @import("win32_wm_paint.zig");
const wm_size = @import("win32_wm_size.zig");
const wm_nchittest = @import("win32_wm_nchittest.zig");
const wm_lbuttondown = @import("win32_wm_lbuttondown.zig");
const wm_lbuttondblclk = @import("win32_wm_lbuttondblclk.zig");
const wm_mousemove = @import("win32_wm_mousemove.zig");

pub export fn windowProc(
    hwnd: types.HWND,
    msg: u32,
    wParam: usize,
    lParam: isize,
) callconv(.c) isize {
    switch (msg) {
        w.WM_PAINT => {
            wm_paint.proc(hwnd);
            return 0;
        },
        w.WM_SIZE => {
            wm_size.proc(hwnd, lParam);
            return 0;
        },
        w.WM_NCHITTEST => {
            return wm_nchittest.proc(hwnd, lParam);
        },
        w.WM_LBUTTONDOWN => {
            return wm_lbuttondown.proc(hwnd, lParam);
        },
        w.WM_LBUTTONDBLCLK => {
            return wm_lbuttondblclk.proc(hwnd, lParam);
        },
        w.WM_MOUSEMOVE => {
            return wm_mousemove.proc(hwnd, lParam);
        },
        w.WM_DESTROY => {
            api.PostQuitMessage(0);
            return 0;
        },
        else => {},
    }

    return api.DefWindowProcW(
        hwnd,
        msg,
        wParam,
        lParam,
    );
}
