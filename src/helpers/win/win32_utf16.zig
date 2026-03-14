const std = @import("std");

pub fn toWide(
    allocator: std.mem.Allocator,
    text: []const u8,
) ![:0]u16 {
    const utf16 = try std.unicode.utf8ToUtf16LeAlloc(
        allocator,
        text,
    );

    var result = try allocator.alloc(u16, utf16.len + 1);
    @memcpy(result[0..utf16.len], utf16);
    result[utf16.len] = 0;
    return result[0..utf16.len :0];
}
