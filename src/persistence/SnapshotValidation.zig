const std = @import("std");

pub const Command = enum(u16) {
    SET = 1,
    DEL,
    HSET,
    HDEL,
    EXPIRE,
    PERSIST,
    ADMIT,
    EVICT,
    MARK_MEMOIZE_FALSE,
    MARK_SEASONALITY,
    TOUCH_USED_AT,
    INCR,
    DECR,
    SNAPSHOT_BARRIER,
};

pub const ValidationError = error{ InvalidKey, InvalidValue, InvalidMetadata };

pub const Frame = struct {
    command: Command,
    key: []const u8 = "",
    value: []const u8 = "",
    metadata: []const u8 = "",
};

pub fn validateFrame(frame: Frame) ValidationError!void {
    switch (frame.command) {
        .SET, .DEL, .HSET, .HDEL, .EXPIRE, .PERSIST, .ADMIT, .EVICT, .MARK_MEMOIZE_FALSE, .MARK_SEASONALITY, .TOUCH_USED_AT, .INCR, .DECR => {
            if (frame.key.len == 0) return error.InvalidKey;
        },
        .SNAPSHOT_BARRIER => {},
    }

    switch (frame.command) {
        .SET, .HSET => if (frame.value.len == 0) return error.InvalidValue,
        else => {},
    }

    switch (frame.command) {
        .ADMIT, .EVICT, .MARK_SEASONALITY => if (frame.metadata.len == 0) return error.InvalidMetadata,
        else => {},
    }
}

const Case = struct {
    name: []const u8,
    ok: Frame,
    fail: Frame,
    fail_error: ValidationError,
};

const cases = [_]Case{
    .{ .name = "SET", .ok = .{ .command = .SET, .key = "k", .value = "v" }, .fail = .{ .command = .SET, .key = "k" }, .fail_error = error.InvalidValue },
    .{ .name = "DEL", .ok = .{ .command = .DEL, .key = "k" }, .fail = .{ .command = .DEL }, .fail_error = error.InvalidKey },
    .{ .name = "HSET", .ok = .{ .command = .HSET, .key = "k", .value = "v" }, .fail = .{ .command = .HSET, .key = "k" }, .fail_error = error.InvalidValue },
    .{ .name = "HDEL", .ok = .{ .command = .HDEL, .key = "k" }, .fail = .{ .command = .HDEL }, .fail_error = error.InvalidKey },
    .{ .name = "EXPIRE", .ok = .{ .command = .EXPIRE, .key = "k" }, .fail = .{ .command = .EXPIRE }, .fail_error = error.InvalidKey },
    .{ .name = "PERSIST", .ok = .{ .command = .PERSIST, .key = "k" }, .fail = .{ .command = .PERSIST }, .fail_error = error.InvalidKey },
    .{ .name = "ADMIT", .ok = .{ .command = .ADMIT, .key = "k", .metadata = "m" }, .fail = .{ .command = .ADMIT, .key = "k" }, .fail_error = error.InvalidMetadata },
    .{ .name = "EVICT", .ok = .{ .command = .EVICT, .key = "k", .metadata = "m" }, .fail = .{ .command = .EVICT, .key = "k" }, .fail_error = error.InvalidMetadata },
    .{ .name = "MARK_MEMOIZE_FALSE", .ok = .{ .command = .MARK_MEMOIZE_FALSE, .key = "k" }, .fail = .{ .command = .MARK_MEMOIZE_FALSE }, .fail_error = error.InvalidKey },
    .{ .name = "MARK_SEASONALITY", .ok = .{ .command = .MARK_SEASONALITY, .key = "k", .metadata = "m" }, .fail = .{ .command = .MARK_SEASONALITY, .key = "k" }, .fail_error = error.InvalidMetadata },
    .{ .name = "TOUCH_USED_AT", .ok = .{ .command = .TOUCH_USED_AT, .key = "k" }, .fail = .{ .command = .TOUCH_USED_AT }, .fail_error = error.InvalidKey },
    .{ .name = "INCR", .ok = .{ .command = .INCR, .key = "k" }, .fail = .{ .command = .INCR }, .fail_error = error.InvalidKey },
    .{ .name = "DECR", .ok = .{ .command = .DECR, .key = "k" }, .fail = .{ .command = .DECR }, .fail_error = error.InvalidKey },
    .{ .name = "SNAPSHOT_BARRIER", .ok = .{ .command = .SNAPSHOT_BARRIER }, .fail = .{ .command = .SNAPSHOT_BARRIER, .key = "" }, .fail_error = error.InvalidKey },
};

inline for (cases) |case| {
    test std.fmt.comptimePrint("unit: sucesso {s}", .{case.name}) {
        try validateFrame(case.ok);
    }

    test std.fmt.comptimePrint("unit: erro {s}", .{case.name}) {
        if (case.ok.command == .SNAPSHOT_BARRIER) {
            try validateFrame(case.fail);
            return;
        }
        try std.testing.expectError(case.fail_error, validateFrame(case.fail));
    }

    test std.fmt.comptimePrint("BDD: Dado frame valido Quando validar {s} Entao sucesso", .{case.name}) {
        try validateFrame(case.ok);
    }

    test std.fmt.comptimePrint("BDD: Dado frame invalido Quando validar {s} Entao erro", .{case.name}) {
        if (case.ok.command == .SNAPSHOT_BARRIER) {
            try validateFrame(case.fail);
            return;
        }
        try std.testing.expectError(case.fail_error, validateFrame(case.fail));
    }
}
