const cfg = @import("../../app/config.zig");
const Rect = @import("../../models/layout/rect.zig").Rect;
const draw = @import("../../helpers/win/win32_draw_panel.zig");
const state = @import("../../helpers/win/win32_window_state.zig");

pub const Button = enum {
    minimize,
    action,
    close,
};

const button_size: i32 = 24;
const button_gap: i32 = 8;
const button_right_pad: i32 = 8;
const fullscreen_hot_zone: i32 = 72;

pub fn buttonRect(width: i32, button: Button) Rect {
    const index: i32 = switch (button) {
        .close => 0,
        .action => 1,
        .minimize => 2,
    };

    const x = width - button_right_pad - button_size - (index * (button_size + button_gap));
    const y = @divTrunc(cfg.AppConfig.title_height - button_size, 2);

    return Rect.init(x, y, button_size, button_size);
}

pub fn fullscreenCloseRect(width: i32, slide: i32) Rect {
    const x = width - button_right_pad - button_size;
    const y = -button_size + slide;
    return Rect.init(x, y, button_size, button_size);
}

pub fn fullscreenHotZone(width: i32, x: i32, y: i32) bool {
    return x >= width - fullscreen_hot_zone and y <= fullscreen_hot_zone;
}

pub fn hitTest(width: i32, x: i32, y: i32, mode: state.DisplayMode, close_slide: i32) ?Button {
    if (mode == .fullscreen) {
        const close_rect = fullscreenCloseRect(width, close_slide);
        if (pointInCircle(close_rect, x, y)) return .close;
        return null;
    }

    if (y < 0 or y >= cfg.AppConfig.title_height) return null;

    const buttons = [_]Button{ .minimize, .action, .close };
    for (buttons) |button| {
        const rect = buttonRect(width, button);
        if (pointInCircle(rect, x, y)) {
            return button;
        }
    }

    return null;
}

pub fn paint(
    hdc: ?*anyopaque,
    width: i32,
    mode: state.DisplayMode,
    title_slide: i32,
    close_slide: i32,
) void {
    if (mode != .fullscreen or title_slide < cfg.AppConfig.title_height) {
        const buttons = [_]Button{ .minimize, .action, .close };
        const title_y = -title_slide;

        for (buttons) |button| {
            var rect = buttonRect(width, button);
            rect.y += title_y;
            draw.drawCircle(hdc, rect.x, rect.y, rect.w, cfg.Theme.title_button_bg, cfg.Theme.window_border);
            drawGlyph(hdc, rect, button, mode);
        }

        draw.drawLine(
            hdc,
            0,
            title_y + cfg.AppConfig.title_height - 1,
            width,
            1,
            cfg.Theme.title_divider,
        );
    }

    if (mode == .fullscreen and close_slide > 0) {
        const rect = fullscreenCloseRect(width, close_slide);
        draw.drawCircle(hdc, rect.x, rect.y, rect.w, cfg.Theme.title_button_bg, cfg.Theme.window_border);
        drawGlyph(hdc, rect, .action, .fullscreen);
    }
}

fn drawGlyph(hdc: ?*anyopaque, rect: Rect, button: Button, mode: state.DisplayMode) void {
    switch (button) {
        .minimize => draw.drawLine(
            hdc,
            rect.x + 6,
            rect.y + rect.h - 7,
            rect.w - 12,
            2,
            cfg.Theme.button_glyph,
        ),
        .action => if (mode == .windowed)
            draw.drawFrame(
                hdc,
                rect.x + 6,
                rect.y + 6,
                rect.w - 12,
                rect.h - 12,
                cfg.Theme.button_glyph,
            )
        else
            drawFullscreenGlyph(hdc, rect),
        .close => drawCloseGlyph(hdc, rect),
    }
}

fn drawFullscreenGlyph(hdc: ?*anyopaque, rect: Rect) void {
    draw.drawLine(hdc, rect.x + 6, rect.y + 6, 6, 2, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + 6, rect.y + 6, 2, 6, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + rect.w - 12, rect.y + 6, 6, 2, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + rect.w - 8, rect.y + 6, 2, 6, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + 6, rect.y + rect.h - 8, 6, 2, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + 6, rect.y + rect.h - 12, 2, 6, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + rect.w - 12, rect.y + rect.h - 8, 6, 2, cfg.Theme.button_glyph);
    draw.drawLine(hdc, rect.x + rect.w - 8, rect.y + rect.h - 12, 2, 6, cfg.Theme.button_glyph);
}

fn drawCloseGlyph(hdc: ?*anyopaque, rect: Rect) void {
    const start_x = rect.x + 7;
    const start_y = rect.y + 7;
    const size = 10;

    var i: i32 = 0;
    while (i < size) : (i += 1) {
        draw.drawLine(hdc, start_x + i, start_y + i, 2, 2, cfg.Theme.button_glyph);
        draw.drawLine(hdc, start_x + (size - 1 - i), start_y + i, 2, 2, cfg.Theme.button_glyph);
    }
}

fn pointInCircle(rect: Rect, x: i32, y: i32) bool {
    const radius = @divTrunc(rect.w, 2);
    const center_x = rect.x + radius;
    const center_y = rect.y + radius;
    const dx = x - center_x;
    const dy = y - center_y;
    return dx * dx + dy * dy <= radius * radius;
}
