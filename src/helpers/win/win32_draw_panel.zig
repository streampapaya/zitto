const api = @import("win32_api.zig");
const types = @import("win32_types.zig");

pub fn fillRect(
    hdc: ?*anyopaque,
    left: i32,
    top: i32,
    right: i32,
    bottom: i32,
    color: u32,
) void {
    const brush = api.CreateSolidBrush(color);
    const rect = types.RECT{
        .left = left,
        .top = top,
        .right = right,
        .bottom = bottom,
    };

    _ = api.FillRect(hdc, &rect, brush);
    _ = api.DeleteObject(brush);
}

pub fn drawPanel(
    hdc: ?*anyopaque,
    x: i32,
    y: i32,
    w: i32,
    h: i32,
    color: u32,
) void {
    fillRect(
        hdc,
        x,
        y,
        x + w,
        y + h,
        color,
    );
}

pub fn drawFrame(
    hdc: ?*anyopaque,
    x: i32,
    y: i32,
    w: i32,
    h: i32,
    color: u32,
) void {
    if (w <= 0 or h <= 0) return;

    fillRect(hdc, x, y, x + w, y + 1, color);
    fillRect(hdc, x, y + h - 1, x + w, y + h, color);
    fillRect(hdc, x, y, x + 1, y + h, color);
    fillRect(hdc, x + w - 1, y, x + w, y + h, color);
}

pub fn drawLine(
    hdc: ?*anyopaque,
    x: i32,
    y: i32,
    w: i32,
    h: i32,
    color: u32,
) void {
    if (w <= 0 or h <= 0) return;
    fillRect(hdc, x, y, x + w, y + h, color);
}

pub fn drawCircle(
    hdc: ?*anyopaque,
    x: i32,
    y: i32,
    size: i32,
    fill_color: u32,
    border_color: u32,
) void {
    if (size <= 0) return;

    const brush = api.CreateSolidBrush(fill_color);
    const pen = api.CreatePen(@import("win32_constants.zig").PS_SOLID, 1, border_color);
    const old_brush = api.SelectObject(hdc, brush);
    const old_pen = api.SelectObject(hdc, pen);

    _ = api.Ellipse(hdc, x, y, x + size, y + size);

    _ = api.SelectObject(hdc, old_brush);
    _ = api.SelectObject(hdc, old_pen);
    _ = api.DeleteObject(brush);
    _ = api.DeleteObject(pen);
}
