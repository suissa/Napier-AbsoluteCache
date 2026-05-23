const std = @import("std");
fn keyHash(s: []const u8) u64 { return std.hash.Wyhash.hash(0, s); }

test "KeyBuilder gera hash determinístico" {
    const a = keyHash("memo.Product.PriceAgent.calculateFinalPrice.abc");
    const b = keyHash("memo.Product.PriceAgent.calculateFinalPrice.abc");
    try std.testing.expectEqual(a, b);
}
