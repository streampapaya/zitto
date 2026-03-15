const types = @import("win32_types.zig");
const w = @import("win32_constants.zig");
const api = @import("win32_api.zig");
const cfg = @import("../../app/config.zig");
const title_panel = @import("../../views/panels/title_panel.zig");
const state = @import("win32_window_state.zig");

pub fn proc(
    hwnd: types.HWND,
    lParam: isize,
) isize {
const bits: usize = @bitCast(lParam);
    const screen_x_word: u16 = @truncate(bits);
    const screen_y_word: u16 = @truncate(bits >> 16);
    const screen_x = @as(i32, @as(i16, @bitCast(screen_x_word)));
    const screen_y = @as(i32, @as(i16, @bitCast(screen_y_word)));
    var rect: types.RECT = undefined;

    if (!api.GetWindowRect(hwnd, &rect)) {
        return w.HTCLIENT;
    }

    const local_x = screen_x - rect.left;
    const local_y = screen_y - rect.top;

    if (title_panel.hitTest(rect.right - rect.left, local_x, local_y, state.mode, state.fullscreen_close_slide) != null) {
        return w.HTCLIENT;
    }

    const visible_title_height = cfg.AppConfig.title_height - state.title_slide;
    if (state.mode != .fullscreen and local_y >= 0 and local_y < visible_title_height) {
        return w.HTCAPTION;
    }

    return w.HTCLIENT;
}
