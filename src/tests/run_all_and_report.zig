const std = @import("std");

const TestCase = struct {
    name: []const u8,
    path: []const u8,
};

const tests = [_]TestCase{
    .{ .name = "snapshot_validation", .path = "src/persistence/SnapshotValidation.zig" },

    .{ .name = "unit_count_min_sketch", .path = "src/tests/unit/count_min_sketch_test.zig" },
    .{ .name = "unit_admission_policy_threshold", .path = "src/tests/unit/admission_policy_threshold_test.zig" },
    .{ .name = "unit_memoize_false", .path = "src/tests/unit/memoize_false_test.zig" },
    .{ .name = "unit_seasonality_finish_at", .path = "src/tests/unit/seasonality_finish_at_test.zig" },
    .{ .name = "unit_temporal_gc_finish_at", .path = "src/tests/unit/temporal_gc_finish_at_test.zig" },
    .{ .name = "unit_memory_pressure_gc_order", .path = "src/tests/unit/memory_pressure_gc_order_test.zig" },
    .{ .name = "unit_key_builder_hash", .path = "src/tests/unit/key_builder_hash_test.zig" },
    .{ .name = "unit_resp_parser", .path = "src/tests/unit/resp_parser_test.zig" },
    .{ .name = "unit_resp_encoder", .path = "src/tests/unit/resp_encoder_test.zig" },
    .{ .name = "unit_memory_leak", .path = "src/tests/unit/memory_leak_test.zig" },

    .{ .name = "integration_redis_cli_set_get_del", .path = "src/tests/integration/redis_cli_set_get_del_test.zig" },
    .{ .name = "integration_node_redis_get_set_hget_hset", .path = "src/tests/integration/node_redis_get_set_hget_hset_test.zig" },
    .{ .name = "integration_event_calculed_generates_metadata", .path = "src/tests/integration/event_calculed_generates_metadata_test.zig" },
    .{ .name = "integration_fifth_call_admits_payload", .path = "src/tests/integration/fifth_call_admits_payload_test.zig" },
    .{ .name = "integration_black_friday_precompute_keys", .path = "src/tests/integration/black_friday_precompute_keys_test.zig" },
    .{ .name = "integration_finish_at_removes_seasonality", .path = "src/tests/integration/finish_at_removes_seasonality_test.zig" },

    .{ .name = "benchmark_1m_get", .path = "src/tests/benchmark/bench_1m_get_test.zig" },
    .{ .name = "benchmark_1m_set_small", .path = "src/tests/benchmark/bench_1m_set_small_test.zig" },
    .{ .name = "benchmark_1m_observe_no_payload", .path = "src/tests/benchmark/bench_1m_observe_no_payload_test.zig" },
    .{ .name = "benchmark_1m_observe_threshold", .path = "src/tests/benchmark/bench_1m_observe_threshold_test.zig" },
    .{ .name = "benchmark_persistence_on_off", .path = "src/tests/benchmark/bench_persistence_on_off_test.zig" },
    .{ .name = "benchmark_latency_memory_stats", .path = "src/tests/benchmark/bench_latency_memory_stats_test.zig" },

    .{ .name = "chaos_kill_during_snapshot", .path = "src/tests/chaos/kill_during_snapshot_test.zig" },
    .{ .name = "chaos_invalid_resp_payload", .path = "src/tests/chaos/invalid_resp_payload_test.zig" },
    .{ .name = "chaos_invalid_event_hash", .path = "src/tests/chaos/invalid_event_hash_test.zig" },
    .{ .name = "chaos_finish_at_past", .path = "src/tests/chaos/finish_at_past_test.zig" },
    .{ .name = "chaos_memory_pressure_artificial", .path = "src/tests/chaos/memory_pressure_artificial_test.zig" },
    .{ .name = "chaos_event_adapter_disconnected", .path = "src/tests/chaos/event_adapter_disconnected_test.zig" },
};

const Result = struct {
    name: []const u8,
    path: []const u8,
    ok: bool,
    elapsed_ms: i128,
    stdout: []u8,
    stderr: []u8,
    exit_code: i32,
};

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    var results = std.ArrayList(Result).init(allocator);
    defer {
        for (results.items) |r| {
            allocator.free(r.stdout);
            allocator.free(r.stderr);
        }
        results.deinit();
    }

    var ok_count: usize = 0;
    var fail_count: usize = 0;

    for (tests) |t| {
        const start_ms = std.time.milliTimestamp();

        var child = std.process.Child.init(&[_][]const u8{ "zig", "test", t.path }, allocator);
        child.stdout_behavior = .Pipe;
        child.stderr_behavior = .Pipe;

        const term = child.spawnAndWait() catch |err| {
            const end_ms = std.time.milliTimestamp();
            const msg = try std.fmt.allocPrint(allocator, "failed to start zig test: {s}", .{@errorName(err)});
            const err_copy = try allocator.dupe(u8, msg);
            allocator.free(msg);

            try results.append(.{
                .name = t.name,
                .path = t.path,
                .ok = false,
                .elapsed_ms = end_ms - start_ms,
                .stdout = try allocator.dupe(u8, ""),
                .stderr = err_copy,
                .exit_code = -1,
            });
            fail_count += 1;
            continue;
        };

        const stdout_bytes = if (child.stdout) |s| try s.readToEndAlloc(allocator, 1024 * 1024) else try allocator.dupe(u8, "");
        const stderr_bytes = if (child.stderr) |s| try s.readToEndAlloc(allocator, 1024 * 1024) else try allocator.dupe(u8, "");

        const end_ms = std.time.milliTimestamp();
        const code: i32 = switch (term) {
            .Exited => |c| c,
            .Signal => |c| @intCast(c),
            .Stopped => |c| @intCast(c),
            .Unknown => -2,
        };
        const ok = term == .Exited and code == 0;
        if (ok) ok_count += 1 else fail_count += 1;

        try results.append(.{
            .name = t.name,
            .path = t.path,
            .ok = ok,
            .elapsed_ms = end_ms - start_ms,
            .stdout = stdout_bytes,
            .stderr = stderr_bytes,
            .exit_code = code,
        });
    }

    try writeHtmlReport(allocator, results.items, ok_count, fail_count);
}

fn escapeHtml(allocator: std.mem.Allocator, s: []const u8) ![]u8 {
    var out = std.ArrayList(u8).init(allocator);
    errdefer out.deinit();
    for (s) |ch| {
        switch (ch) {
            '&' => try out.appendSlice("&amp;"),
            '<' => try out.appendSlice("&lt;"),
            '>' => try out.appendSlice("&gt;"),
            '"' => try out.appendSlice("&quot;"),
            else => try out.append(ch),
        }
    }
    return out.toOwnedSlice();
}

fn writeHtmlReport(allocator: std.mem.Allocator, items: []const Result, ok_count: usize, fail_count: usize) !void {
    var html = std.ArrayList(u8).init(allocator);
    defer html.deinit();

    const generated_at = std.time.timestamp();

    try html.appendSlice(
        "<!doctype html><html><head><meta charset=\"utf-8\">"
        ++ "<meta name=\"viewport\" content=\"width=device-width,initial-scale=1\">"
        ++ "<title>Napier Test Report</title>"
        ++ "<style>body{background:#0b1020;color:#e5e7eb;font-family:Inter,system-ui,Arial,sans-serif;padding:24px;}"
        ++ ".card{background:#111827;border:1px solid #1f2937;border-radius:12px;padding:16px;margin-bottom:14px;}"
        ++ ".ok{color:#34d399}.fail{color:#f87171}.muted{color:#9ca3af}.mono{font-family:ui-monospace,Menlo,monospace;}"
        ++ "pre{background:#030712;border:1px solid #1f2937;padding:12px;border-radius:8px;overflow:auto;}"
        ++ "</style></head><body>"
    );

    try html.writer().print("<h1>Napier AbsoluteCache - Test Report</h1><p class=\"muted\">generated_at_unix={d}</p>", .{generated_at});
    try html.writer().print("<div class=\"card\"><b class=\"ok\">PASS: {d}</b> &nbsp; <b class=\"fail\">FAIL: {d}</b> &nbsp; <span class=\"muted\">TOTAL: {d}</span></div>", .{ ok_count, fail_count, items.len });

    for (items) |r| {
        const stdout_esc = try escapeHtml(allocator, r.stdout);
        defer allocator.free(stdout_esc);
        const stderr_esc = try escapeHtml(allocator, r.stderr);
        defer allocator.free(stderr_esc);

        try html.writer().print(
            "<div class=\"card\"><h3>{s}</h3><p class=\"mono muted\">{s}</p><p>Status: <b class=\"{s}\">{s}</b> | exit={d} | elapsed={d}ms</p>",
            .{ r.name, r.path, if (r.ok) "ok" else "fail", if (r.ok) "PASS" else "FAIL", r.exit_code, r.elapsed_ms },
        );

        if (r.stdout.len > 0) try html.writer().print("<details><summary>stdout</summary><pre>{s}</pre></details>", .{stdout_esc});
        if (r.stderr.len > 0) try html.writer().print("<details><summary>stderr</summary><pre>{s}</pre></details>", .{stderr_esc});

        try html.appendSlice("</div>");
    }

    try html.appendSlice("</body></html>");

    const report_path = "test-report.html";
    const file = try std.fs.cwd().createFile(report_path, .{ .truncate = true });
    defer file.close();
    try file.writeAll(html.items);

    std.debug.print("report generated: {s}\n", .{report_path});
}
