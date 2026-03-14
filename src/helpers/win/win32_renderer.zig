const draw = @import("win32_draw_panel.zig");
const ColoredRect = @import("../../models/layout/colored_rect.zig").ColoredRect;

pub fn render(
    hdc: ?*anyopaque,
    commands: []const ColoredRect,
) void {
    for (commands) |cmd| {
        draw.drawPanel(
            hdc,
            cmd.rect.x,
            cmd.rect.y,
            cmd.rect.w,
            cmd.rect.h,
            cmd.color,
        );
    }
}
