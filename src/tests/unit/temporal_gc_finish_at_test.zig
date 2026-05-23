const std = @import("std");
fn shouldRemove(now: i64, finish_at: ?i64) bool { return finish_at != null and now >= finish_at.?; }

test "TemporalGC remove now >= finish_at" {
    try std.testing.expect(shouldRemove(100, 100));
    try std.testing.expect(shouldRemove(101, 100));
    try std.testing.expect(!shouldRemove(99, 100));
}
