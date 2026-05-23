ZIG ?= zig

.PHONY: test-all test-report \
	test-snapshot-validation \
	test-unit-count-min-sketch test-unit-admission-policy-threshold test-unit-memoize-false test-unit-seasonality-finish-at test-unit-temporal-gc-finish-at test-unit-memory-pressure-gc-order test-unit-key-builder-hash test-unit-resp-parser test-unit-resp-encoder test-unit-memory-leak \
	test-integration-redis-cli-set-get-del test-integration-node-redis-get-set-hget-hset test-integration-event-calculed-generates-metadata test-integration-fifth-call-admits-payload test-integration-black-friday-precompute-keys test-integration-finish-at-removes-seasonality \
	test-benchmark-1m-get test-benchmark-1m-set-small test-benchmark-1m-observe-no-payload test-benchmark-1m-observe-threshold test-benchmark-persistence-on-off test-benchmark-latency-memory-stats \
	test-chaos-kill-during-snapshot test-chaos-invalid-resp-payload test-chaos-invalid-event-hash test-chaos-finish-at-past test-chaos-memory-pressure-artificial test-chaos-event-adapter-disconnected

test-snapshot-validation:
	$(ZIG) test src/persistence/SnapshotValidation.zig

# Unit
test-unit-count-min-sketch:
	$(ZIG) test src/tests/unit/count_min_sketch_test.zig

test-unit-admission-policy-threshold:
	$(ZIG) test src/tests/unit/admission_policy_threshold_test.zig

test-unit-memoize-false:
	$(ZIG) test src/tests/unit/memoize_false_test.zig

test-unit-seasonality-finish-at:
	$(ZIG) test src/tests/unit/seasonality_finish_at_test.zig

test-unit-temporal-gc-finish-at:
	$(ZIG) test src/tests/unit/temporal_gc_finish_at_test.zig

test-unit-memory-pressure-gc-order:
	$(ZIG) test src/tests/unit/memory_pressure_gc_order_test.zig

test-unit-key-builder-hash:
	$(ZIG) test src/tests/unit/key_builder_hash_test.zig

test-unit-resp-parser:
	$(ZIG) test src/tests/unit/resp_parser_test.zig

test-unit-resp-encoder:
	$(ZIG) test src/tests/unit/resp_encoder_test.zig

test-unit-memory-leak:
	$(ZIG) test src/tests/unit/memory_leak_test.zig

# Integration
test-integration-redis-cli-set-get-del:
	$(ZIG) test src/tests/integration/redis_cli_set_get_del_test.zig

test-integration-node-redis-get-set-hget-hset:
	$(ZIG) test src/tests/integration/node_redis_get_set_hget_hset_test.zig

test-integration-event-calculed-generates-metadata:
	$(ZIG) test src/tests/integration/event_calculed_generates_metadata_test.zig

test-integration-fifth-call-admits-payload:
	$(ZIG) test src/tests/integration/fifth_call_admits_payload_test.zig

test-integration-black-friday-precompute-keys:
	$(ZIG) test src/tests/integration/black_friday_precompute_keys_test.zig

test-integration-finish-at-removes-seasonality:
	$(ZIG) test src/tests/integration/finish_at_removes_seasonality_test.zig

# Benchmark
test-benchmark-1m-get:
	$(ZIG) test src/tests/benchmark/bench_1m_get_test.zig

test-benchmark-1m-set-small:
	$(ZIG) test src/tests/benchmark/bench_1m_set_small_test.zig

test-benchmark-1m-observe-no-payload:
	$(ZIG) test src/tests/benchmark/bench_1m_observe_no_payload_test.zig

test-benchmark-1m-observe-threshold:
	$(ZIG) test src/tests/benchmark/bench_1m_observe_threshold_test.zig

test-benchmark-persistence-on-off:
	$(ZIG) test src/tests/benchmark/bench_persistence_on_off_test.zig

test-benchmark-latency-memory-stats:
	$(ZIG) test src/tests/benchmark/bench_latency_memory_stats_test.zig

# Chaos
test-chaos-kill-during-snapshot:
	$(ZIG) test src/tests/chaos/kill_during_snapshot_test.zig

test-chaos-invalid-resp-payload:
	$(ZIG) test src/tests/chaos/invalid_resp_payload_test.zig

test-chaos-invalid-event-hash:
	$(ZIG) test src/tests/chaos/invalid_event_hash_test.zig

test-chaos-finish-at-past:
	$(ZIG) test src/tests/chaos/finish_at_past_test.zig

test-chaos-memory-pressure-artificial:
	$(ZIG) test src/tests/chaos/memory_pressure_artificial_test.zig

test-chaos-event-adapter-disconnected:
	$(ZIG) test src/tests/chaos/event_adapter_disconnected_test.zig

test-report:
	$(ZIG) run src/tests/run_all_and_report.zig

test-all: \
	test-snapshot-validation \
	test-unit-count-min-sketch test-unit-admission-policy-threshold test-unit-memoize-false test-unit-seasonality-finish-at test-unit-temporal-gc-finish-at test-unit-memory-pressure-gc-order test-unit-key-builder-hash test-unit-resp-parser test-unit-resp-encoder test-unit-memory-leak \
	test-integration-redis-cli-set-get-del test-integration-node-redis-get-set-hget-hset test-integration-event-calculed-generates-metadata test-integration-fifth-call-admits-payload test-integration-black-friday-precompute-keys test-integration-finish-at-removes-seasonality \
	test-benchmark-1m-get test-benchmark-1m-set-small test-benchmark-1m-observe-no-payload test-benchmark-1m-observe-threshold test-benchmark-persistence-on-off test-benchmark-latency-memory-stats \
	test-chaos-kill-during-snapshot test-chaos-invalid-resp-payload test-chaos-invalid-event-hash test-chaos-finish-at-past test-chaos-memory-pressure-artificial test-chaos-event-adapter-disconnected
