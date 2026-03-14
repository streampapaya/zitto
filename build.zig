const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "zitto",
        .root_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize,
        }),
    });

    exe.root_module.linkSystemLibrary("user32", .{ .use_pkg_config = .no });
    exe.root_module.linkSystemLibrary("gdi32", .{ .use_pkg_config = .no });
    exe.root_module.linkSystemLibrary("kernel32", .{ .use_pkg_config = .no });

    b.installArtifact(exe);

    const run_cmd = b.addRunArtifact(exe);

    const run_step = b.step("run", "Run ZITTO");
    run_step.dependOn(&run_cmd.step);
}
