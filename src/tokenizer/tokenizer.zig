const std = @import("std");

const fs = std.fs;

pub fn generate_tokens(dest: []const u8) !void {
    const file = try fs.cwd().openFile(dest, .{});
    defer file.close();

    const file_size = try file.getEndPos();

    const buffer = try std.heap.page_allocator.alloc(u8, file_size);
    defer std.heap.page_allocator.free(buffer);

    _ = try file.readAll(buffer);

    std.debug.print("{s}", .{buffer});
}
