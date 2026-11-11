Branch: `feat/b18-divided-difference-complete-homog` (commit `21030cede`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): prove DividedDifferenceEqCompleteHomog (B18) over every field

## Summary

`Research/ProximityPrize/Frontier/_BridgeB18.lean` stated the general B18 identity as the named
Prop `DividedDifferenceEqCompleteHomog F` ("named open Prop, NOT a theorem"), with only the two-
and three-node cases proved. It is now a theorem over every field:
`dividedDifferenceEqCompleteHomog (K) : DividedDifferenceEqCompleteHomog K`.

This is the classical symmetric-function identity only. See "What remains open".

## Requirement served

`approvedScope`: discharge a named hypothesis of the tree. The file header reduced the general
case to "one explicitly-named recursion bridge" that was never supplied.

## Mathematical change

For `k + 1` distinct nodes `t_i` and `a ≥ k`: `Σ_i t_i^a / Π_{j≠i}(t_i − t_j) = h_{a−k}(t)`.

New declarations (namespace `ArkLib.ProximityGap.BridgeB18`):

- `ddiff_singleton`.
- `ddiff_pow_succ` — one-node recursion `DD_s(x^{a+1}) = DD_{s∖{i₀}}(x^a) + t_{i₀}·DD_s(x^a)`,
  the exact mirror of the existing `hsym_front_recursion`.
- `ddiff_pow_zero_eq_zero` — `DD_s(1) = 0` for `|s| ≥ 2`, obtained by applying the recursion at
  two different nodes and subtracting.
- `ddiff_pow_eq_hsym_list` — for a duplicate-free list `l`: the divided difference of `x^a` is
  `0` if `a + 1 < |l|` and `hsym (a + 1 − |l|) l` otherwise (induction on `a`).
- `dividedDifferenceEqCompleteHomog`.

The Newton two-sided recursion the docstring expected is not needed.

## Verification

Base `1e7ebbfeb`, Lean `4.35.0`, Lake `5.0.0-src+eb6cafb`.

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_BridgeB18.lean
'ArkLib.ProximityGap.BridgeB18.ddiff_pow_succ' depends on axioms: [propext, Classical.choice, Quot.sound]
'ArkLib.ProximityGap.BridgeB18.ddiff_pow_zero_eq_zero' depends on axioms: [propext, Classical.choice, Quot.sound]
'ArkLib.ProximityGap.BridgeB18.ddiff_pow_eq_hsym_list' depends on axioms: [propext, Classical.choice, Quot.sound]
✅ OK (5s) — Research/ProximityPrize/Frontier/_BridgeB18.lean
```

`dividedDifferenceEqCompleteHomog` reports the same three axioms. `validate.sh` up to the build
step: 712 Python tests OK (skipped=10), import surfaces consistent, forbidden-token precheck
clean, sorry census unchanged, KB lint and docs integrity passed.

TODO before opening: paste the real `./scripts/validate.sh` result (the full build was not
completed in the cloud container).

## Assumption audit

- New axioms: none. `sorry` / `admit` / `native_decide`: none.
- New named residuals or hypotheses: none. One named open Prop becomes a theorem.
- Imports: unchanged. No other file imports `_BridgeB18` (except `All.lean`).

## What remains open

- The E4 cascade-decay analysis that would consume this identity is untouched; nothing is
  claimed about the size of the cascade values over a finite field.
- No bearing on δ* or issue #164.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
