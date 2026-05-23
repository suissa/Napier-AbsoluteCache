const std = @import("std");
fn simple(s: []const u8, a: std.mem.Allocator) ![]u8 { return std.fmt.allocPrint(a, "+{s}
", .{s}); }
fn bulk(s: []const u8, a: std.mem.Allocator) ![]u8 { return std.fmt.allocPrint(a, "${d}
{s}
", .{s.len,s}); }
fn nilBulk() []const u8 { return "$-1
"; }
fn integer(v: i64, a: std.mem.Allocator) ![]u8 { return std.fmt.allocPrint(a, ":{d}
", .{v}); }
fn err(s: []const u8, a: std.mem.Allocator) ![]u8 { return std.fmt.allocPrint(a, "-ERR {s}
", .{s}); }

test "RESP encoder retorna bulk string, nil, integer e error" {
    const a = std.testing.allocator;
    const b = try bulk("v", a); defer a.free(b);
    const i = try integer(2, a); defer a.free(i);
    const e = try err("unknown", a); defer a.free(e);
    const s = try simple("OK", a); defer a.free(s);
    try std.testing.expectEqualStrings("$1
v
", b);
    try std.testing.expectEqualStrings("$-1
", nilBulk());
    try std.testing.expectEqualStrings(":2
", i);
    try std.testing.expectEqualStrings("-ERR unknown
", e);
    try std.testing.expectEqualStrings("+OK
", s);
}
