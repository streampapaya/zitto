const api = @import("win32_api.zig");
const animation = @import("win32_animation.zig");
const types = @import("win32_types.zig");
const title_panel = @import("../../views/panels/title_panel.zig");
const state = @import("win32_window_state.zig");

pub fn proc(hwnd: types.HWND, lParam: isize) isize {
    if (state.mode != .fullscreen) return 0;

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
    const should_show = title_panel.fullscreenHotZone(width, x, y);

    if (should_show and !state.fullscreen_close_visible) {
        state.fullscreen_close_visible = true;
        animation.animateValue(
            hwnd,
            &state.fullscreen_close_slide,
            state.fullscreen_close_slide,
            title_panel.buttonRect(width, .close).h + 8,
            6,
        );
    } else if (!should_show and state.fullscreen_close_visible) {
        state.fullscreen_close_visible = false;
        animation.animateValue(
            hwnd,
            &state.fullscreen_close_slide,
            state.fullscreen_close_slide,
            0,
            6,
        );
    }

    return 0;
}
