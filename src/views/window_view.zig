const std = @import("std");

const win = @import("../helpers/win/win32_window.zig");
const model_mod = @import("../models/window_model.zig");

pub fn create(model: *model_mod.WindowModel) !void {
    try win.createWindow(model);
}

pub fn eventLoop() void {
    win.eventLoop();
}
