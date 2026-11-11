Branch: `feat/jac-complete-sum-lift-roots-of-unity` (commit `bdb026d70`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): prove CompleteSumLift for the n-th roots of unity

## Summary

`CompleteSumLift χ s G` — `m·T(s) = Σ_{u ∈ F^*} χ^s(u^m − 1)` with `m = orderOf χ` — is a
hypothesis of `_JacAutocorrWeilDescentToCurveSum.lean` (JAC0) and `_JacVarietyCollapsesToCurve.lean`
(JAC4), described as "exact identity; named, its proof is the m-to-1 fibration". It is now proved
at the intended `G = μ_n`, `n = (q − 1)/m`, in both files.

## Requirement served

`approvedScope`: discharge a named hypothesis used by `Tsum_le_weil_distinctRoots`,
`weil_deficit_is_sqrt_m` (JAC0) and `squared_yields_curve_ceiling` (JAC4).

## Mathematical change

`PowMapFiberCard.lean` (namespace `ProximityGap.Frontier.PowMapFiberCard`), finite-field form:

- `sum_erase_zero_pow_eq_nsmul_sum_image` — for `m ∣ q − 1`,
  `Σ_{u≠0} g(u^m) = m • Σ_{t ∈ (F^*)^m} g t` (from the existing cyclic-group lift on `Fˣ`).
- `card_image_pow_erase_zero` — `|(F^*)^m| = (q − 1)/m`.
- `image_pow_erase_zero_eq_filter` — `(F^*)^m = {t : t^((q−1)/m) = 1}`.

JAC0 and JAC4 each:

- `completeSumLift_powImage`, `completeSumLift_rootsOfUnity`.
- one consumer with the lift discharged: `Tsum_rootsOfUnity_le_weil_distinctRoots` (JAC0),
  `squared_yields_curve_ceiling_rootsOfUnity` (JAC4).

`CompleteSumLift χ s G` is false for a general finset `G`; the docstrings now say so.

## Verification

```
$ ./scripts/lake-locked.sh build Research.ProximityPrize.Frontier.PowMapFiberCard \
    Research.ProximityPrize.Frontier._JacAutocorrWeilDescentToCurveSum \
    Research.ProximityPrize.Frontier._JacVarietyCollapsesToCurve
Build completed successfully (9057 jobs).
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/PowMapFiberCard.lean
✅ OK (6s) — Research/ProximityPrize/Frontier/PowMapFiberCard.lean
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_JacAutocorrWeilDescentToCurveSum.lean
✅ OK (6s) — Research/ProximityPrize/Frontier/_JacAutocorrWeilDescentToCurveSum.lean
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_JacVarietyCollapsesToCurve.lean
✅ OK (6s) — Research/ProximityPrize/Frontier/_JacVarietyCollapsesToCurve.lean
```

All new theorems report `[propext, Classical.choice, Quot.sound]`.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. No new named residual.
- Imports added: both Jacobi files import `PowMapFiberCard` (a Mathlib-only file).
- No file other than `All.lean` imports the three modified files.

## What remains open

- The Weil / curve-ceiling hypothesis of the consumers (`hweil`, `WeilCurveCeiling`) is untouched:
  Mathlib has no curve bound.
- The files' verdict is unchanged: the completed sum has degree `m ≈ n³` and its `√q` ceiling is
  vacuous at prize scale. This PR removes a hypothesis; it does not improve any bound.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
