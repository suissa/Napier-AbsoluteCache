const std = @import("std");

const CountMinSketch = struct {
    counters: [4][64]u32 = [_][64]u32{[_]u32{0} ** 64} ** 4,
    fn idx(seed: u64, key: []const u8) usize {
        var h = std.hash.Wyhash.init(seed);
        h.update(key);
        return @intCast(h.final() % 64);
    }
    fn inc(self: *CountMinSketch, key: []const u8) void {
        inline for (0..4) |d| self.counters[d][idx(d + 1, key)] += 1;
    }
    fn query(self: *const CountMinSketch, key: []const u8) u32 {
        var m: u32 = std.math.maxInt(u32);
        inline for (0..4) |d| m = @min(m, self.counters[d][idx(d + 1, key)]);
        return m;
    }
};

test "CountMinSketch increment/query" {
    var cms = CountMinSketch{};
    cms.inc("k"); cms.inc("k"); cms.inc("k");
    try std.testing.expect(cms.query("k") >= 3);
}
