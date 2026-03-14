const types = @import("win32_types.zig");
const cfg = @import("../../app/config.zig");
const w = @import("win32_constants.zig");

pub fn proc(
    lParam: isize,
) isize {
    const y = @as(i32, @intCast((lParam >> 16) & 0xFFFF));

    if (y < cfg.AppConfig.title_height) {
        return w.HTCAPTION;
    }

    return w.HTCLIENT;
}
