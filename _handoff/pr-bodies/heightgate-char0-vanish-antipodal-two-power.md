Branch: `feat/heightgate-char0-vanish-antipodal-two-power` (commit `a634bd41f`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): prove Char0VanishImpliesAntipodal at every 2-power

## Summary

`Research/ProximityPrize/Frontier/HeightGateNormBound.lean` kept the last step of the height gate
as the named obligation `Char0VanishImpliesAntipodal n` ("elementary, true, Mathlib gap"). The
2-power Lam–Leung kernel characterization is already in the tree
(`LamLeungTwoPow.vanishing_iff_antipodal_coeffs`) but was never wired to this Prop. This PR does
the wiring and records that the 2-power restriction is necessary.

## Requirement served

`approvedScope`: discharge a named obligation of the height-gate file.

## Mathematical change

- `char0VanishImpliesAntipodal_two_pow (a) : Char0VanishImpliesAntipodal (2 ^ a)` — apply the
  kernel characterization to the `0/1` indicator of `S`; `a = 0` is direct.
- `not_char0VanishImpliesAntipodal_six : ¬ Char0VanishImpliesAntipodal 6` — for a primitive
  sixth root `z`, `1 + z² + z⁴ = 0` but `{0, 2, 4}` is not closed under `i ↦ i + 3`.

## Verification

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/HeightGateNormBound.lean
✅ OK (294s) — Research/ProximityPrize/Frontier/HeightGateNormBound.lean
```

(294 s on a cold disk cache.) Both theorems report `[propext, Classical.choice, Quot.sound]`.
Import surfaces, forbidden-token precheck, sorry census, KB and docs checks pass.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. No new named residual.
- Import added: `ArkLib.Data.CodingTheory.ProximityGap.LamLeungTwoPow` (Research → ArkLib, allowed).
- This is wiring of an existing theorem: no new Lam–Leung content. The 2-power fact is in tree
  twice already (`LamLeungTwoPow.vanishing_iff_antipodal_coeffs`, and
  `VanishingTwoPowSumIsAntipodalPairing` in `Frontier/_AvX_VanishingTwoPowSumIsAntipodalP.lean`
  with `ℕ`-weights); only the link to the named Prop is new, and the Prop has no Lean consumer.
- `docs/kb/deltastar-sweep-A01-heightgate-normbound-2026-06-14.md`: dated update line.

## What remains open

- The gate itself fires only for `n ≤ 32` at the prize prime (`gate_NOT_fires_64`), and
  `HeightBoundRescuesGate` stays refuted for `n = 2^k`, `k ≥ 11`. None of that changes.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
