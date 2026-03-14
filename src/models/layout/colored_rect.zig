const Rect = @import("rect.zig").Rect;

pub const ColoredRect = struct {
    rect: Rect,
    color: u32,

    pub fn init(
        rect: Rect,
        color: u32,
    ) ColoredRect {
        return ColoredRect{
            .rect = rect,
            .color = color,
        };
    }
};
