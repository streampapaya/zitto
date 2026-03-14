const controller = @import("../controllers/window_controller.zig");

pub fn run() !void {
    try controller.start();
}
