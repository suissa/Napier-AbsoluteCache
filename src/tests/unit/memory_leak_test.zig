const std = @import("std");

test "Memory não vaza alocação" {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const a = gpa.allocator();
    const buf = try a.alloc(u8, 128);
    a.free(buf);
}
