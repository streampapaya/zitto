const api = @import("win32_api.zig");
const types = @import("win32_types.zig");
const title_panel = @import("../../views/panels/title_panel.zig");
const state = @import("win32_window_state.zig");
const handler = @import("win32_wm_lbuttondown.zig");

pub fn proc(hwnd: types.HWND, lParam: isize) isize {
    if (state.mode == .fullscreen) return 0;

    var client_rect: types.RECT = undefined;
    if (!api.GetClientRect(hwnd, &client_rect)) {
        return 0;
    }

    const width = client_rect.right - client_rect.left;
    const bits: usize = @bitCast(lParam);
    const x_word: u16 = @truncate(bits);
    const y_word: u16 = @truncate(bits >> 16);
    const x = @as(i32, @as(i16, @bitCast(x_word)));
    const y = @as(i32, @as(i16, @bitCast(y_word)));

    if (title_panel.hitTest(width, x, y, state.mode, state.fullscreen_close_slide) != null) {
        return 0;
    }
    if (y < 0 or y >= 40) {
        return 0;
    }

    handler.toggleMaximizeRestore(hwnd);
    return 0;
}
