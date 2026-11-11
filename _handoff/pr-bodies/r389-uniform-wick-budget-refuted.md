Branch: `feat/r389-uniform-wick-budget-refuted` (head `7c5c65a96`, 2 commit(s) on base `1e7ebbfeb`)

Title: feat(ProximityPrize): refute UniformSubgroupWickBudget for every constant

## Summary

`R389WickBudgetSupBound.UniformSubgroupWickBudget C` asks for one inflation constant `C` making
the DC-subtracted Wick budget hold for every finite field and every torsion subgroup at depth
`⌈(log q)/2⌉₊`. Its docstring and DISPROOF_LOG entry `[164-r389-subfield-wick-budget]` recorded
a subfield obstruction as a written argument, "not kernel-checked", and explicitly did not
record the predicate as refuted. This PR kernel-checks it:
`not_uniformSubgroupWickBudget (C : ℝ) : ¬ UniformSubgroupWickBudget C`.

The witness is a subfield subgroup. Prime fields are not touched: see "What remains open".

## Requirement served

`approvedScope`: settle a named hypothesis; its consumer `sup_le_of_uniformSubgroupWickBudget`
is vacuous.

## Mathematical change

New file `Research/ProximityPrize/Frontier/_R389UniformWickBudgetRefuted.lean`:

- `pred_le_card_torsionSet` — in characteristic `p`, `μ_{p−1}` contains the `p − 1` nonzero
  elements of the prime subfield.
- `card_torsionSet_le_of_budget` — in a finite field of characteristic `p` with more than `p`
  elements, a budget at `μ_{p−1}` forces `|μ_{p−1}| ≤ 9·C·log q`: a primitive additive character
  is trivial on `μ_{p−1}` (in-tree `FFModelW4.ffThin_prizeLaw_countermodel`), so the R389 sup
  bound `sup_le_three_sqrt_of_dcEnergyBudget` applies with `‖η_1‖ = |μ_{p−1}|`.
- `not_uniformSubgroupWickBudget_of_nonneg` — `F = GF(p²)`, `p > (36·⌈C⌉₊)²`, using
  `log p ≤ 2(√p − 1)`.
- `not_uniformSubgroupWickBudget_of_neg` — `F = ZMod 2`, `d = 1`: depth `1`, negative budget,
  nonnegative DC floor (`R240GeneralRFoldVariance.dc_floor`).
- `not_uniformSubgroupWickBudget`.

The exact subfield energy of the written argument is not needed.

## Verification

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_R389UniformWickBudgetRefuted.lean
'ArkLib.ProximityGap.R389UniformWickBudgetRefuted.not_uniformSubgroupWickBudget_of_neg' depends on axioms: [propext, Classical.choice, Quot.sound]
'ArkLib.ProximityGap.R389UniformWickBudgetRefuted.not_uniformSubgroupWickBudget' depends on axioms: [propext, Classical.choice, Quot.sound]
✅ OK (5s) — Research/ProximityPrize/Frontier/_R389UniformWickBudgetRefuted.lean
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_R389WickBudgetSupBound.lean
✅ OK (8s) — Research/ProximityPrize/Frontier/_R389WickBudgetSupBound.lean
$ ./scripts/check-imports.sh
Canonical sources and local import graph are consistent.
Research import boundary passed: ArkLib does not import Research.
Generated ArkLib: 1152 canonical imports; ArkLibExtensions: 2903 modules in 2589 globs.
Generated Research/ProximityPrize/All.lean: 3353 imports
```

(axiom lists unwrapped from the multi-line output.) Forbidden-token precheck, sorry census, KB
and docs checks pass.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. No new named residual.
- New file; `All.lean` regenerated with `scripts/update-research-lib.py`. `_R389WickBudgetSupBound.lean`
  only has docstring edits (it stays frontier-import-free).
- `DISPROOF_LOG.md`: new entry `[164-r389-uniform-wick-budget-refuted]`.
- The refutation is uniform in `C`; it does not pick a bad value of a free parameter. It does use
  that the Prop quantifies over all finite fields.

## What remains open

- The prime-field budget (the sponsor target) and the prize-shaped subgroups `μ_{2^k} ⊂ 𝔽_p`:
  open in both directions, exactly as the R389 docstring says. `GF(p)^× ⊂ GF(p²)` has no
  cancellation at all and is not a model of the prize regime.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
