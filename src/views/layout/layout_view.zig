const cfg = @import("../../app/config.zig");

const Rect = @import("../../models/layout/rect.zig").Rect;
const Panel = @import("../../models/layout/panel.zig").Panel;
const ColoredRect = @import("../../models/layout/colored_rect.zig").ColoredRect;

const LayoutRender = @import("layout_render.zig").LayoutRender;

const layout_engine = @import("layout_engine.zig");

pub fn build(
    width: i32,
    height: i32,
    title_height: i32,
) LayoutRender {
    const layout = layout_engine.computeLayout(
        width,
        height,
        title_height,
    );

    var out = LayoutRender.init();

    // title bar (always visible)
    out.push(
        ColoredRect.init(
            layout.title.rect,
            cfg.Theme.title,
        ),
    );

    switch (cfg.AppConfig.layout_style) {
        .empty => {
            // title only
        },

        .minimal => {
            out.push(
                ColoredRect.init(
                    layout.center.rect,
                    cfg.Theme.center,
                ),
            );
        },

        .full => {
            const panels = [_]struct {
                rect: Rect,
                color: u32,
            }{
                .{ .rect = layout.left.rect, .color = cfg.Theme.left_panel },
                .{ .rect = layout.center.rect, .color = cfg.Theme.center },
                .{ .rect = layout.right.rect, .color = cfg.Theme.right_panel },
                .{ .rect = layout.terminal.rect, .color = cfg.Theme.terminal },
                .{ .rect = layout.footer.rect, .color = cfg.Theme.footer },
            };

            for (panels) |p| {
                out.push(
                    ColoredRect.init(
                        p.rect,
                        p.color,
                    ),
                );
            }
        },
    }

    return out;
}
