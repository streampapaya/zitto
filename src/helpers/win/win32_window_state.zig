const types = @import("win32_types.zig");

pub const DisplayMode = enum {
    windowed,
    maximized,
    fullscreen,
};

pub var mode: DisplayMode = .windowed;
pub var normal_rect = types.RECT{
    .left = 200,
    .top = 200,
    .right = 1400,
    .bottom = 900,
};
pub var title_slide: i32 = 0;
pub var fullscreen_close_slide: i32 = 0;
pub var fullscreen_close_visible: bool = false;
