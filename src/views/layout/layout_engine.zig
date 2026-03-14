const panel = @import("../../models/layout/panel.zig");

pub const Layout = struct {
    title: panel.Panel,
    left: panel.Panel,
    center: panel.Panel,
    right: panel.Panel,
    terminal: panel.Panel,
    footer: panel.Panel,
};

pub fn computeLayout(
    width: i32,
    height: i32,
) Layout {
    const title_h = 40;
    const footer_h = 25;
    const left_w = 220;
    const right_w = 260;
    const terminal_h = 200;

    return Layout{
        .title = panel.Panel.init(
            0,
            0,
            width,
            title_h,
        ),

        .left = panel.Panel.init(
            0,
            title_h,
            left_w,
            height - title_h - footer_h,
        ),

        .center = panel.Panel.init(
            left_w,
            title_h,
            width - left_w - right_w,
            height - title_h - footer_h,
        ),

        .right = panel.Panel.init(
            width - right_w,
            title_h,
            right_w,
            height - title_h - footer_h,
        ),

        .terminal = panel.Panel.init(
            left_w,
            height - terminal_h - footer_h,
            width - left_w - right_w,
            terminal_h,
        ),

        .footer = panel.Panel.init(
            0,
            height - footer_h,
            width,
            footer_h,
        ),
    };
}
