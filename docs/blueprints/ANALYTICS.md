# Product Analytics (Privacy‑first, Pilot)

**Principles**
- No PII by default
- Opt‑in only (per environment)
- Retention: 90 days (pilot)

**Events**
- `template_run_started` {template_id, profile, source: "workbench|cli"}
- `template_run_completed` {template_id, duration_ms, status: "ok|error"}
- `ledger_append` {event_id, template_id, status}
- `workbench_execute_clicked` {template_id}
- `workbench_sse_dropped` {duration_ms}

**Emission**
- Pilot: log to server stdout as JSON lines
- Future: export to your SIEM or internal warehouse

**Consent**
- `ANALYTICS_OPTOUT=1` disables emission