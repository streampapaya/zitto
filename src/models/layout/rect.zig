pub const Rect = struct {
    x: i32,
    y: i32,
    w: i32,
    h: i32,

    pub fn init(x: i32, y: i32, w: i32, h: i32) Rect {
        return Rect{
            .x = x,
            .y = y,
            .w = w,
            .h = h,
        };
    }
};
