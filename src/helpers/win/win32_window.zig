const std = @import("std");

const cfg = @import("../../app/config.zig");

const utf = @import("win32_utf16.zig");
const types = @import("win32_types.zig");
const api = @import("win32_api.zig");
const w = @import("win32_constants.zig");
const wndproc = @import("win32_window_proc.zig");
const state = @import("win32_window_state.zig");

const model_mod = @import("../../models/window_model.zig");

pub fn createWindow(model: *model_mod.WindowModel) !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    const allocator = gpa.allocator();

    const className = try utf.toWide(
        allocator,
        cfg.AppConfig.window_class,
    );

    const title = try utf.toWide(
        allocator,
        cfg.AppConfig.app_name,
    );

    var wcls = types.WNDCLASSW{
        .style = w.CS_DBLCLKS,
        .lpfnWndProc = wndproc.windowProc,
        .cbClsExtra = 0,
        .cbWndExtra = 0,
        .hInstance = api.GetModuleHandleW(null),
        .hIcon = null,
        .hCursor = api.LoadCursorW(null, @ptrFromInt(w.IDC_ARROW)),
        .hbrBackground = @ptrFromInt(6),
        .lpszMenuName = null,
        .lpszClassName = className.ptr,
    };

    _ = api.RegisterClassW(&wcls);

    state.mode = .windowed;
    state.title_slide = 0;
    state.fullscreen_close_slide = 0;
    state.fullscreen_close_visible = false;
    state.normal_rect = .{
        .left = model.pos_x,
        .top = model.pos_y,
        .right = model.pos_x + model.width,
        .bottom = model.pos_y + model.height,
    };

    _ = api.CreateWindowExW(
        0,
        className.ptr,
        title.ptr,
        w.WS_POPUP | w.WS_VISIBLE,
        model.pos_x,
        model.pos_y,
        model.width,
        model.height,
        null,
        null,
        wcls.hInstance,
        null,
    );
}

pub fn eventLoop() void {
    var msg: types.MSG = undefined;

    while (api.GetMessageW(&msg, null, 0, 0) > 0) {
        _ = api.TranslateMessage(&msg);
        _ = api.DispatchMessageW(&msg);
    }
}
