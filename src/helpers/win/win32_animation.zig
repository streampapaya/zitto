const api = @import("win32_api.zig");
const types = @import("win32_types.zig");

pub fn animateValue(
    hwnd: types.HWND,
    value: *i32,
    from: i32,
    to: i32,
    steps: i32,
) void {
    if (steps <= 0 or from == to) {
        value.* = to;
        _ = api.InvalidateRect(hwnd, null, true);
        _ = api.UpdateWindow(hwnd);
        return;
    }

    var i: i32 = 0;
    while (i <= steps) : (i += 1) {
        value.* = from + @divTrunc((to - from) * i, steps);
        _ = api.InvalidateRect(hwnd, null, true);
        _ = api.UpdateWindow(hwnd);
        api.Sleep(8);
    }
}

pub fn animateWindowRect(
    hwnd: types.HWND,
    from: types.RECT,
    to: types.RECT,
    steps: i32,
) void {
    if (steps <= 0) {
        _ = api.SetWindowPos(
            hwnd,
            null,
            to.left,
            to.top,
            to.right - to.left,
            to.bottom - to.top,
            w_flags,
        );
        return;
    }

    var i: i32 = 0;
    while (i <= steps) : (i += 1) {
        const left = from.left + @divTrunc((to.left - from.left) * i, steps);
        const top = from.top + @divTrunc((to.top - from.top) * i, steps);
        const width = (from.right - from.left) + @divTrunc(((to.right - to.left) - (from.right - from.left)) * i, steps);
        const height = (from.bottom - from.top) + @divTrunc(((to.bottom - to.top) - (from.bottom - from.top)) * i, steps);

        _ = api.SetWindowPos(hwnd, null, left, top, width, height, w_flags);
        api.Sleep(8);
    }
}

const w_flags = 0x0004 | 0x0010;
