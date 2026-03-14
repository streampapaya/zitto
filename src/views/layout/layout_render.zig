const ColoredRect = @import("../../models/layout/colored_rect.zig").ColoredRect;

pub const LayoutRender = struct {
    rects: [6]ColoredRect,
    count: usize,

    pub fn init() LayoutRender {
        return .{
            .rects = undefined,
            .count = 0,
        };
    }

    pub fn push(
        self: *LayoutRender,
        rect: ColoredRect,
    ) void {
        self.rects[self.count] = rect;
        self.count += 1;
    }

    pub fn slice(self: *const LayoutRender) []const ColoredRect {
        return self.rects[0..self.count];
    }
};
