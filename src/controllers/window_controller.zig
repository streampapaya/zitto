const std = @import("std");

const view = @import("../views/window_view.zig");
const model_mod = @import("../models/window_model.zig");

pub fn start() !void {
    var model = model_mod.WindowModel{};

    try view.create(&model);

    view.eventLoop();
}
