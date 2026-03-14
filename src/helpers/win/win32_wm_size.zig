const api = @import("win32_api.zig");
const types = @import("win32_types.zig");

pub fn proc(
    hwnd: types.HWND,
    lParam: isize,
) void {
    const width: i32 = @intCast(lParam & 0xFFFF);
    const height: i32 = @intCast((lParam >> 16) & 0xFFFF);

    _ = width;
    _ = height;

    // trigger redraw
    _ = api.InvalidateRect(
        hwnd,
        null,
        true,
    );
}
