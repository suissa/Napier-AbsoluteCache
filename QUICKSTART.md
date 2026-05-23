# Napier AbsoluteCache — QUICKSTART

Este guia rápido mostra como executar os testes adicionados no projeto, individualmente e em lote.

## Pré-requisitos

- Zig instalado e disponível no `PATH`
- Estar na raiz do repositório (`/workspace/Napier-AbsoluteCache`)

Verificação:

```bash
zig version
```

---

## Rodar todos os testes de uma vez

### Via Makefile

```bash
make test-all
```

### Via script runner com relatório HTML (tema escuro)

```bash
zig run src/tests/run_all_and_report.zig
```

Saída esperada do relatório:

- Arquivo: `test-report.html`

---

## Rodar cada teste isoladamente

### Snapshot / Persistência

```bash
make test-snapshot-validation
```

### Unit

```bash
make test-unit-count-min-sketch
make test-unit-admission-policy-threshold
make test-unit-memoize-false
make test-unit-seasonality-finish-at
make test-unit-temporal-gc-finish-at
make test-unit-memory-pressure-gc-order
make test-unit-key-builder-hash
make test-unit-resp-parser
make test-unit-resp-encoder
make test-unit-memory-leak
```

### Integration

```bash
make test-integration-redis-cli-set-get-del
make test-integration-node-redis-get-set-hget-hset
make test-integration-event-calculed-generates-metadata
make test-integration-fifth-call-admits-payload
make test-integration-black-friday-precompute-keys
make test-integration-finish-at-removes-seasonality
```

### Benchmark

```bash
make test-benchmark-1m-get
make test-benchmark-1m-set-small
make test-benchmark-1m-observe-no-payload
make test-benchmark-1m-observe-threshold
make test-benchmark-persistence-on-off
make test-benchmark-latency-memory-stats
```

### Chaos

```bash
make test-chaos-kill-during-snapshot
make test-chaos-invalid-resp-payload
make test-chaos-invalid-event-hash
make test-chaos-finish-at-past
make test-chaos-memory-pressure-artificial
make test-chaos-event-adapter-disconnected
```

---

## Dicas

- Se quiser rodar o agregador original de testes do repositório:

```bash
zig test src/unit_tests.zig
```

- Se algum comando falhar por ambiente (por exemplo, sem `zig`), instale Zig e execute novamente.
