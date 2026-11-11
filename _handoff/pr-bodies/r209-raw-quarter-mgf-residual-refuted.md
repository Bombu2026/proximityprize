Branch: `feat/r209-raw-quarter-mgf-residual-refuted` (commit `2b16abee6`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): refute NonzeroQuarterMGFResidual at prize scale

## Summary

`NonzeroQuarterMGFResidual ψ G` (R209) is `Σ_{b≠0} exp(‖η_G(b)‖/4) ≤ 2(|F| − 1)`, with the raw
modulus as score. `_DyadicRawQuarterMGFRefuted.lean` proved an abstract Parseval-scale refutation
of that shape; no theorem negated the named residual. This PR adds the instantiation:
`not_nonzeroQuarterMGFResidual`.

## Requirement served

`approvedScope`: settle a named hypothesis. The R209 consumers
(`dyadicTailMGF_of_nonzero_quarterMGFResidual`, `prize_sq_of_nonzero_quarterMGFResidual`) are
vacuous on the stated range.

## Mathematical change

`not_nonzeroQuarterMGFResidual (hψ : ψ.IsPrimitive) (G) (hn : 128 ≤ G.card)
(hthin : 2 * G.card ≤ Fintype.card F) : ¬ NonzeroQuarterMGFResidual ψ G`.

Proof: `not_rawQuarterMGFBound_of_parseval_scale` applied to `t b = ‖η_G(b)‖` with
`GaussPeriodParsevalFloor.sum_sq_erase_zero` (`Σ_{b≠0} ‖η_G(b)‖² = |F||G| − |G|²`). No subgroup
structure on `G` is used.

## Verification

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_R209NonzeroQuarterMGFResidualConsumer.lean
✅ OK (3s) — Research/ProximityPrize/Frontier/_R209NonzeroQuarterMGFResidualConsumer.lean
$ ./scripts/lake-locked.sh build Research.ProximityPrize.Frontier._R210NonzeroBulkPlusSpikesMGFConsumer
Build completed successfully (3179 jobs).
```

(`_R210…` is the only importer of the modified file.) The new theorem reports
`[propext, Classical.choice, Quot.sound]`. Import surfaces, forbidden-token precheck, sorry
census, KB and docs checks pass.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. No new named residual.
- Imports added: `_DyadicRawQuarterMGFRefuted` (Mathlib-only file) and
  `ArkLib.Data.CodingTheory.ProximityGap.GaussPeriodParsevalFloor`.
- This is an instantiation of an in-tree brick, already described informally in
  `docs/kb/deltastar-466-dyadic-raw-mgf-normalization-audit-2026-07-09.md`.

## What remains open

- The normalized-square residual of R211/R213 (`exp(‖η‖²/(4|G|))`) is not affected.
- No bound on a Gauss period is obtained.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
