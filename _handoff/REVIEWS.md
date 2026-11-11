# Draft reviews (not published)

Reproduced on base `1e7ebbfeb` with `python3 -I -B` (3.9.6) from an empty directory, no GitHub
token. Re-check each head SHA before posting: a review of a stale head is worthless.

## #421 (head fce17ffda) — validated, medium confidence (no Lean run)

> Head fce17ffda, base 1e7ebbfeb, no Lean run.
> `python3 -I -B -m unittest discover -s scripts/tests -p test_lake_locked.py`: PR test + PR wrapper OK; main's test + PR wrapper (the 8b58c3d state) FAIL `Timed out waiting for test process state`; PR test + main wrapper OK.
> Logging fake `lake`: `build Foo` runs `lake build ArkLibLintPlugin:shared StopTacticPlugin:shared`, then `lake build Foo`; `exe`/`env` unchanged; a failing pre-link warns and the real build's exit code (3) is kept.
> CI: main run 42658876075 fails on `Building StopTacticPlugin:shared … no such file or directory`; this head's prebuild and build pass.
> Non-blocking: no test covers the pre-link itself; `interaction.yml:94` still runs bare `lake build`.

## #422 (head 84dfde25a) — validated, high

> Head 84dfde25. `python3 -I -B -m unittest discover -s scripts/tests -p test_antipodal_subgroup_obstructions_optimization.py`: OK; against main's probe, 6/6 subtests fail (exit 0).
> Main `-O` with generator g+1: `"status": "PASS"`, exit 0. Stdout identical main/PR/PR `-O` (`cmp`). Bare asserts 23→0.

## #423 (head 152d321fb) — validated, high

> Head 152d321f. `main()` not run (it writes to a hard-coded /private/tmp path). `sieve_rung`+`emit_rung` for k=16..30: identical main/PR/PR `-O`.
> Main `-O`: with an odd-number `is_prime`, `sieve_rung(16)` returns 20 rows, 16 composite (first 4295032833); `is_prime(DET_LIMIT)` returns True.
> New test 4/4 fail on main, OK on PR; `test_g139_phi_certificate.py` OK with and without `-O`. Asserts 8→0.

## #424 (head 16a2ea681) — validated, medium (numpy unavailable)

> Head 16a2ea68. Main `-O` with `T = 592794967`: VERDICT printed, exit 0. New test 4/4 fail on main, OK on PR; MDS output identical. The numpy flow-map `_require(ok)` in `main()` was not exercised (numpy unavailable). Asserts 6→0.

## #425 (head c1736b5bc) — validated, high

> Head c1736b5b. Main `-O` with `lucas_witness` returning 4: 48 certificates with witness 4 (`lucasTwoFactor 1033 18 4`), exit 0. New test 4/4 fail on main, OK on PR; 264-line output identical. Asserts 7→0.

## #426 (head 438430227) — validated, high

> Head 43843022. Main `-O`: `G …479` and mask `…884` (`lifted_directions=1577058304`) both end with `hyperplane_avoidance_budget=PASS`, exit 0. New test 4/4 fail on main, OK on PR; output identical. Asserts 13→0.

## #427 (head 3c660b5bc) — validated, high

> Head 3c660b5b. Main `-O` with `A_VAL, B_VAL = 9, 7`: joint set `[0..7]`, `ALL CHECKS PASSED`, exit 0. New test 4/4 fail on main, OK on PR; output identical. Asserts 26→0.
> Pre-existing, non-blocking: `collinear` (line 206) is computed but never enforced.

## Common note for #424–#427

The tests' own guard `assert source.count(old) == 1` is stripped under `-O`; with a missing
pattern the untouched probe exits 0 and the test still fails, but without a diagnostic.
