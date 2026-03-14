const api = @import("win32_api.zig");

pub fn drawPanel(
    hdc: ?*anyopaque,
    x: i32,
    y: i32,
    w: i32,
    h: i32,
    color: u32,
) void {
    const brush = api.CreateSolidBrush(color);

    _ = api.Rectangle(
        hdc,
        x,
        y,
        x + w,
        y + h,
    );

    _ = api.DeleteObject(brush);
}
