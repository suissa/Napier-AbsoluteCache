const std = @import("std");
const Entry = struct { memoize: bool, payload: ?[]const u8 = null };
fn maybeStore(e: *Entry, v: []const u8) void { if (e.memoize) e.payload = v; }

test "memoize=false impede payload" {
    var e = Entry{ .memoize = false };
    maybeStore(&e, "heavy");
    try std.testing.expect(e.payload == null);
}
