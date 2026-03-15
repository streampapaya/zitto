const api = @import("win32_api.zig");
const animation = @import("win32_animation.zig");
const types = @import("win32_types.zig");
const w = @import("win32_constants.zig");
const title_panel = @import("../../views/panels/title_panel.zig");
const state = @import("win32_window_state.zig");

pub fn proc(hwnd: types.HWND, lParam: isize) isize {
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

    const button = title_panel.hitTest(width, x, y, state.mode, state.fullscreen_close_slide) orelse return 0;
    switch (button) {
        .minimize => _ = api.ShowWindow(hwnd, w.SW_MINIMIZE),
        .action => handleAction(hwnd),
        .close => handleCloseButton(hwnd),
    }

    return 0;
}

fn handleAction(hwnd: types.HWND) void {
    var current_rect: types.RECT = undefined;
    if (!api.GetWindowRect(hwnd, &current_rect)) return;

    const monitor = api.MonitorFromWindow(hwnd, w.MONITOR_DEFAULTTONEAREST);
    var info = types.MONITORINFO{
        .cbSize = @sizeOf(types.MONITORINFO),
        .rcMonitor = undefined,
        .rcWork = undefined,
        .dwFlags = 0,
    };
    if (!api.GetMonitorInfoW(monitor, &info)) return;

    switch (state.mode) {
        .windowed => {
            state.normal_rect = current_rect;
            animation.animateWindowRect(hwnd, current_rect, info.rcWork, 10);
            state.mode = .maximized;
        },
        .maximized => {
            animation.animateWindowRect(hwnd, current_rect, info.rcMonitor, 10);
            state.mode = .fullscreen;
            state.fullscreen_close_visible = false;
            state.fullscreen_close_slide = 0;
            animation.animateValue(
                hwnd,
                &state.title_slide,
                state.title_slide,
                40,
                6,
            );
        },
        .fullscreen => {},
    }
}

fn handleCloseButton(hwnd: types.HWND) void {
    switch (state.mode) {
        .fullscreen => exitFullscreen(hwnd),
        .windowed, .maximized => _ = api.DestroyWindow(hwnd),
    }
}

pub fn toggleMaximizeRestore(hwnd: types.HWND) void {
    switch (state.mode) {
        .windowed => maximizeToWorkArea(hwnd),
        .maximized => restoreToWindowed(hwnd),
        .fullscreen => {},
    }
}

fn maximizeToWorkArea(hwnd: types.HWND) void {
    var current_rect: types.RECT = undefined;
    if (!api.GetWindowRect(hwnd, &current_rect)) return;

    const monitor = api.MonitorFromWindow(hwnd, w.MONITOR_DEFAULTTONEAREST);
    var info = types.MONITORINFO{
        .cbSize = @sizeOf(types.MONITORINFO),
        .rcMonitor = undefined,
        .rcWork = undefined,
        .dwFlags = 0,
    };
    if (!api.GetMonitorInfoW(monitor, &info)) return;

    state.normal_rect = current_rect;
    animation.animateWindowRect(hwnd, current_rect, info.rcWork, 10);
    state.mode = .maximized;
}

fn restoreToWindowed(hwnd: types.HWND) void {
    var current_rect: types.RECT = undefined;
    if (!api.GetWindowRect(hwnd, &current_rect)) return;
    animation.animateWindowRect(hwnd, current_rect, state.normal_rect, 10);
    state.mode = .windowed;
}

fn exitFullscreen(hwnd: types.HWND) void {
    var current_rect: types.RECT = undefined;
    if (!api.GetWindowRect(hwnd, &current_rect)) return;

    const monitor = api.MonitorFromWindow(hwnd, w.MONITOR_DEFAULTTONEAREST);
    var info = types.MONITORINFO{
        .cbSize = @sizeOf(types.MONITORINFO),
        .rcMonitor = undefined,
        .rcWork = undefined,
        .dwFlags = 0,
    };
    if (!api.GetMonitorInfoW(monitor, &info)) return;

    state.fullscreen_close_visible = false;
    animation.animateValue(hwnd, &state.fullscreen_close_slide, state.fullscreen_close_slide, 0, 4);
    animation.animateValue(hwnd, &state.title_slide, state.title_slide, 0, 6);
    animation.animateWindowRect(hwnd, current_rect, info.rcWork, 10);
    state.mode = .maximized;
}
