const std = @import("std");
const tokenizer = @import("./tokenizer/tokenizer.zig");

pub fn main() !void {
    const start_time = std.time.milliTimestamp();
    defer {
        const end_time = std.time.milliTimestamp();

        const duration = end_time - start_time;
        std.debug.print("Done: {} ms\n", .{duration});
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

    const tokens = try tokenizer.generate_tokens(arena_allocator, "./data/TestComponent/index.tsx", "@app", "./data");
    defer tokens.deinit();

    for (tokens.items) |token| {
        std.debug.print("token: {s}\n", .{token});
    }
}
