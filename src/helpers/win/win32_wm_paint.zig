const api = @import("win32_api.zig");
const types = @import("win32_types.zig");

const cfg = @import("../../app/config.zig");
const layout_view = @import("../../views/layout/layout_view.zig");
const title_panel = @import("../../views/panels/title_panel.zig");
const draw = @import("win32_draw_panel.zig");
const renderer = @import("win32_renderer.zig");
const state = @import("win32_window_state.zig");

pub fn proc(hwnd: types.HWND) void {
    var ps: types.PAINTSTRUCT = undefined;
    const hdc = api.BeginPaint(hwnd, &ps);
    var client_rect: types.RECT = undefined;

    if (!api.GetClientRect(hwnd, &client_rect)) {
        _ = api.EndPaint(hwnd, &ps);
        return;
    }

    const width = client_rect.right - client_rect.left;
    const height = client_rect.bottom - client_rect.top;
    const title_height = @max(0, cfg.AppConfig.title_height - state.title_slide);

    const render = layout_view.build(
        width,
        height,
        title_height,
    );

    renderer.render(
        hdc,
        render.slice(),
    );

    title_panel.paint(
        hdc,
        width,
        state.mode,
        state.title_slide,
        state.fullscreen_close_slide,
    );
    if (state.mode != .fullscreen) {
        draw.drawFrame(hdc, 0, 0, width, height, cfg.Theme.window_border);
    }

    _ = api.EndPaint(hwnd, &ps);
}
