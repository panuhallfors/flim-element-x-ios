---
name: update-snapshots
description: >-
  Capture and save new Preview/UI test snapshots for Element X iOS. Use when
  the user asks to update snapshots, record snapshots, re-record failing
  snapshot tests, or fix snapshot mismatches after a UI change.
disable-model-invocation: true
---

# Update snapshots

Re-record reference images under `*/Sources/__Snapshots__/`. Git LFS tracks them — `git lfs install` if missing.

Prefer **PreviewTests** (covers `TestablePreview` screens). UITests only when a flow snapshot changed.

## Preconditions

- Work in the `ios/` submodule root.
- Simulator for PreviewTests: **iPhone SE (3rd generation)**, iOS from `CI.defaultOSVersion` (currently **26.5**).
- Region/language once per sim: Settings → General → Language & Region → United States, English (US) only.
- Prefer Xcode MCP tools over raw `xcodebuild` when available; otherwise use the tools CLI below.

## PreviewTests (default)

Overwrite failures + missing refs:

```bash
swift run tools ci preview-tests --record
```

Expected: swift-snapshot-testing marks recording runs as failed. Success = xcresult exists + new/changed PNGs under `PreviewTests/Sources/__Snapshots__/`.

`--record` flips `RECORD_FAILURES` to enabled in `PreviewTests/SupportingFiles/PreviewTests.xctestplan`. **Always flip it back off** after the run (leave the plan dirty otherwise):

```json
"enabled": false,
"key": "RECORD_FAILURES",
"value": "true"
```

Scoped refresh (one screen): delete that screen’s folder under `PreviewTests/Sources/__Snapshots__/`, then run PreviewTests **without** `--record` (new screens / missing refs auto-write). Or keep `--record` / `RECORD_FAILURES` and run only the matching test class.

## UITests

No `ci ui-tests --record`. Either:

1. Enable `RECORD_FAILURES` in `UITests/SupportingFiles/UITests.xctestplan`, run the UITests scheme on the environments in `UITests/Sources/Application.swift` (`checkEnvironments`), then disable `RECORD_FAILURES` again; or
2. Delete the stale snapshots for that flow under `UITests/Sources/__Snapshots__/`, re-run the test so missing refs are written.

## After recording

1. Confirm only intended `__Snapshots__` PNGs changed (`git status` / `git diff --stat`).
2. Do **not** commit `*.xctestplan` record-flag flips.
3. Do not commit unless the user asks. Snapshots are LFS binaries — stage the `__Snapshots__` paths normally when committing.

## CI alternative

On a PR in the iOS fork, maintainers can add the `record-snapshots` label → workflow runs `swift run -q tools ci preview-tests --record` and pushes Preview snapshot commits. Use locally when you need the files in-tree now.
