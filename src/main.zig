const std = @import("std");
const import_replacer = @import("./import_replacer/import_replacer.zig");
const directory_reader = @import("./directory_reader/directory_reader.zig");

pub fn main() !void {
    const start_time = std.time.milliTimestamp();
    defer {
        const end_time = std.time.milliTimestamp();

        const duration = end_time - start_time;
        std.debug.print("Done: {} ms\n", .{duration});
        std.debug.print("=================================================\n", .{});
    }
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();

        switch (leaked) {
            .leak => std.debug.print("Leaked", .{}),
            .ok => {},
        }
    }

    const allocator = gpa.allocator();

    var arena = std.heap.ArenaAllocator.init(allocator);
    defer arena.deinit();
    const arena_allocator = arena.allocator();

    const base_path = "/Users/nick_korolev/Documents/work/StennAppWeb/apps/fcg/src";

    const files = try directory_reader.read_directory(arena_allocator, base_path);
    defer files.deinit();

    for (files.items) |file_path| {
        try import_replacer.replace_imports(arena_allocator, file_path, "@app", base_path);
    }
    std.debug.print("=================================================\n", .{});
    std.debug.print("Checked {} files\n", .{files.items.len});
}
