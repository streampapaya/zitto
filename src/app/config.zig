pub const LayoutStyle = enum {
    full,
    minimal,
    empty,
};

pub const AppConfig = struct {
    pub const app_name = "ZITTO";
    pub const window_class = "ZITTO_CLASS";

    // default resolution
    pub const width: i32 = 1920;
    pub const height: i32 = 1080;

    pub const title_height: i32 = 40;

    pub const layout_style = LayoutStyle.empty;
};

pub const Theme = struct {
    pub const background = 0x00F2F2F2;
    pub const title = 0x00DCDCDC;
    pub const left_panel = 0x00E6E6E6;
    pub const right_panel = 0x00E6E6E6;
    pub const center = 0x00FFFFFF;
    pub const terminal = 0x00EDEDED;
    pub const footer = 0x00D8D8D8;
};
