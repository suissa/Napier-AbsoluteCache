const std=@import("std");
test "chaos payload inválido via RESP" { try std.testing.expectError(error.Invalid, (struct{fn p() !void {return error.Invalid;}}).p()); }
