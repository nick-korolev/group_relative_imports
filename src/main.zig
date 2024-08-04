const std = @import("std");
const tokenizer = @import("./tokenizer/tokenizer.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        const leaked = gpa.deinit();

        switch (leaked) {
            .leak => std.debug.print("Leaked", .{}),
            .ok => {},
        }
    }
    _ = try tokenizer.generate_tokens("./data/TestComponent/index.tsx");
}
