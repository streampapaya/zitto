const api = @import("win32_api.zig");
const types = @import("win32_types.zig");

const cfg = @import("../../app/config.zig");
const layout_view = @import("../../views/layout/layout_view.zig");
const renderer = @import("win32_renderer.zig");

pub fn proc(hwnd: types.HWND) void {
    var ps: types.PAINTSTRUCT = undefined;

    const hdc = api.BeginPaint(hwnd, &ps);

    const render = layout_view.build(
        cfg.AppConfig.width,
        cfg.AppConfig.height,
    );

    renderer.render(
        hdc,
        render.slice(),
    );

    _ = api.EndPaint(hwnd, &ps);
}
