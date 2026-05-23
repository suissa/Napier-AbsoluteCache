const std = @import("std");
fn expired(now: i64, finish_at: ?i64, seasonality: bool) bool { return seasonality and finish_at != null and now >= finish_at.?; }

test "seasonality=true com finish_at expira" {
    try std.testing.expect(expired(200, 100, true));
    try std.testing.expect(!expired(50, 100, true));
}
