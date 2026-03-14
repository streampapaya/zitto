const Rect = @import("rect.zig").Rect;

pub const Panel = struct {
    rect: Rect,

    pub fn init(x: i32, y: i32, w: i32, h: i32) Panel {
        return Panel{
            .rect = Rect.init(x, y, w, h),
        };
    }
};
