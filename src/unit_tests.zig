//! Copyright 2026 Andrea Vaccaro
//! Licensed under the Apache License, Version 2.0
//! http://www.apache.org/licenses/LICENSE-2.0
//!
//! This file is part of "Rapto".
//! It contains the implementation of unit tests and semantic analysis.

comptime {
    _ = @import("code.zig");
    _ = @import("frames.zig");
    _ = @import("main.zig");
    _ = @import("Memory.zig");
    _ = @import("Memory/field.zig");
    _ = @import("Memory/field/collection.zig");
    _ = @import("Memory/field/collection/List.zig");
    _ = @import("Memory/field/collection/Map.zig");
    _ = @import("Memory/field/scalar.zig");
    _ = @import("Memory/field/scalar/Decimal.zig");
    _ = @import("Memory/field/scalar/Flag.zig");
    _ = @import("Memory/field/scalar/Integer.zig");
    _ = @import("Memory/field/scalar/Point.zig");
    _ = @import("Memory/field/scalar/String.zig");
    _ = @import("Memory/field/scalar/Void.zig");
    _ = @import("Memory/object.zig");
    _ = @import("state_machine.zig");
    _ = @import("tagged_pointer.zig");
    _ = @import("Task.zig");
    _ = @import("Task/Query.zig");
    _ = @import("Task/Query/Flags.zig");
    _ = @import("persistence/SnapshotValidation.zig");
    _ = @import("tests/unit/count_min_sketch_test.zig");
    _ = @import("tests/unit/admission_policy_threshold_test.zig");
    _ = @import("tests/unit/memoize_false_test.zig");
    _ = @import("tests/unit/seasonality_finish_at_test.zig");
    _ = @import("tests/unit/temporal_gc_finish_at_test.zig");
    _ = @import("tests/unit/memory_pressure_gc_order_test.zig");
    _ = @import("tests/unit/key_builder_hash_test.zig");
    _ = @import("tests/unit/resp_parser_test.zig");
    _ = @import("tests/unit/resp_encoder_test.zig");
    _ = @import("tests/unit/memory_leak_test.zig");
    _ = @import("tests/integration/redis_cli_set_get_del_test.zig");
    _ = @import("tests/integration/node_redis_get_set_hget_hset_test.zig");
    _ = @import("tests/integration/event_calculed_generates_metadata_test.zig");
    _ = @import("tests/integration/fifth_call_admits_payload_test.zig");
    _ = @import("tests/integration/black_friday_precompute_keys_test.zig");
    _ = @import("tests/integration/finish_at_removes_seasonality_test.zig");
    _ = @import("tests/benchmark/bench_1m_get_test.zig");
    _ = @import("tests/benchmark/bench_1m_set_small_test.zig");
    _ = @import("tests/benchmark/bench_1m_observe_no_payload_test.zig");
    _ = @import("tests/benchmark/bench_1m_observe_threshold_test.zig");
    _ = @import("tests/benchmark/bench_persistence_on_off_test.zig");
    _ = @import("tests/benchmark/bench_latency_memory_stats_test.zig");
    _ = @import("tests/chaos/kill_during_snapshot_test.zig");
    _ = @import("tests/chaos/invalid_resp_payload_test.zig");
    _ = @import("tests/chaos/invalid_event_hash_test.zig");
    _ = @import("tests/chaos/finish_at_past_test.zig");
    _ = @import("tests/chaos/memory_pressure_artificial_test.zig");
    _ = @import("tests/chaos/event_adapter_disconnected_test.zig");
    _ = @import("zprof.zig");
}
