const std = @import("std");

const Result = struct {
    target_dir: []const u8,
    prefix: []const u8,
};

const ReadError = error{
    ParamsRequired,
};

pub fn read_args(allocator: std.mem.Allocator) !Result {
    const args = try std.process.argsAlloc(allocator);

    defer std.process.argsFree(allocator, args);

    if (args.len < 2) {
        return ReadError.ParamsRequired;
    }

    const target_dir = try allocator.dupe(u8, args[1]);
    errdefer allocator.free(target_dir);

    const prefix = try allocator.dupe(u8, args[2]);
    errdefer allocator.free(prefix);

    return Result{ .target_dir = target_dir, .prefix = prefix };
}
