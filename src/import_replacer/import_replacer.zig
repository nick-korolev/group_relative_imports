const std = @import("std");

const fs = std.fs;

pub fn replace_imports(allocator: std.mem.Allocator, file_path: []const u8, prefix: []const u8, relative_dir: []const u8) !void {
    const dir_path = std.fs.path.dirname(file_path);

    const file = try fs.cwd().openFile(file_path, .{ .mode = .read_write });
    defer file.close();

    const file_size = try file.getEndPos();

    var buffer = try allocator.alloc(u8, file_size);

    _ = try file.readAll(buffer);

    var tokens = std.ArrayList([]u8).init(allocator);
    defer tokens.deinit();

    var start: usize = 0;
    const import_start_pattern = "import";
    const import_pad = import_start_pattern.len;

    while (std.mem.indexOfPos(u8, buffer, start, import_start_pattern)) |from_start| {
        const offset = from_start + import_pad;
        var left = offset;
        var token_start_index: usize = undefined;
        var token_stop_index: usize = undefined;
        var start_initialized = false;
        var stop_initialized = false;

        while (!start_initialized or !stop_initialized) {
            if (left > buffer.len - 1) break;
            const nextChar = buffer[left];
            switch (nextChar) {
                '"',
                '\'',
                => {
                    if (!start_initialized) {
                        left += 1;
                        token_start_index = left;
                        start_initialized = true;
                    } else {
                        token_stop_index = left;
                        stop_initialized = true;
                    }
                },
                else => left += 1,
            }
        }
        start = token_stop_index;
        if (token_start_index > buffer.len or token_stop_index > buffer.len) {
            continue;
        }
        const target = buffer[token_start_index..token_stop_index];

        // duplicate
        if (dir_path) |path| {
            const replaced = try std.mem.replaceOwned(u8, allocator, path, relative_dir, prefix);
            const computed_path = try std.fmt.allocPrint(allocator, "{s}/", .{replaced});

            // std.debug.print("computed_path: {s}\n", .{computed_path});
            if (std.mem.startsWith(u8, target, computed_path)) {
                try tokens.append(target);
            }
        }
    }

    // duplicate
    if (dir_path) |path| {
        const computed_path = try std.mem.replaceOwned(u8, allocator, path, relative_dir, prefix);
        for (tokens.items) |target| {
            const modified_token = try std.mem.replaceOwned(u8, allocator, target, computed_path, ".");
            buffer = try std.mem.replaceOwned(u8, allocator, buffer, target, modified_token);
        }
    }

    if (tokens.items.len != 0) {
        // std.debug.print("buffer: {s} \n", .{buffer});
        try file.seekTo(0);
        try file.writeAll(buffer);
        try file.setEndPos(buffer.len);
    }
}
