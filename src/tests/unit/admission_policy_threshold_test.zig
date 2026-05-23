const std = @import("std");
const AdmissionPolicy = struct { threshold: u32 = 5, fn admitted(self: @This(), counter: u32) bool { return counter >= self.threshold; } };

test "AdmissionPolicy threshold 5" {
    const p = AdmissionPolicy{};
    try std.testing.expect(!p.admitted(4));
    try std.testing.expect(p.admitted(5));
}
