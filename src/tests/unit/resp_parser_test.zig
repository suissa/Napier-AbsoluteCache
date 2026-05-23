const std = @import("std");
fn parseCmd(resp: []const u8) ![]const u8 {
    if (!std.mem.startsWith(u8, resp, "*")) return error.Invalid;
    const get = std.mem.indexOf(u8, resp, "GET") != null;
    const set = std.mem.indexOf(u8, resp, "SET") != null;
    const del = std.mem.indexOf(u8, resp, "DEL") != null;
    const hget = std.mem.indexOf(u8, resp, "HGET") != null;
    const hset = std.mem.indexOf(u8, resp, "HSET") != null;
    if (get) return "GET"; if (set) return "SET"; if (del) return "DEL"; if (hget) return "HGET"; if (hset) return "HSET";
    return error.Invalid;
}

test "RESP parser decodifica GET/SET/DEL/HGET/HSET" {
    try std.testing.expectEqualStrings("GET", try parseCmd("*2
$3
GET
$1
k
"));
    try std.testing.expectEqualStrings("SET", try parseCmd("*3
$3
SET
$1
k
$1
v
"));
    try std.testing.expectEqualStrings("DEL", try parseCmd("*2
$3
DEL
$1
k
"));
    try std.testing.expectEqualStrings("HGET", try parseCmd("*3
$4
HGET
$1
h
$1
f
"));
    try std.testing.expectEqualStrings("HSET", try parseCmd("*4
$4
HSET
$1
h
$1
f
$1
v
"));
}
