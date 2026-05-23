const std = @import("std");
const C = struct { id: u8, counter: u32, created_at: i64 };
fn less(_: void, a: C, b: C) bool { return if (a.counter == b.counter) a.created_at < b.created_at else a.counter < b.counter; }

test "MemoryPressureGC remove counter ASC + created_at ASC" {
    var items = [_]C{ .{.id=1,.counter=10,.created_at=100}, .{.id=2,.counter=1,.created_at=200}, .{.id=3,.counter=1,.created_at=100} };
    std.mem.sort(C, &items, {}, less);
    try std.testing.expectEqual(@as(u8,3), items[0].id);
    try std.testing.expectEqual(@as(u8,2), items[1].id);
}
