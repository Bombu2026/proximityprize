Branch: `feat/gf65537-genuine-char-sum-bridge` (commit `6ae2b822b`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): prove GFCharSumBridge for the genuine μ₃₂ character sum at p = 65537

## Summary

`Research/ProximityPrize/Frontier/_GFCeilingInstance65537.lean` proves `etaGF > 2√32` for the
explicit cosine sum `etaGF` and carried its identification with the genuine character sum as the
hypothesis `GFCharSumBridge` ("verified numerically in the probe"). The identification is now a
theorem, so the ceiling holds for the genuine sum with no hypothesis.

Out-of-window instance (β ≈ 3.2), exactly as the file already says.

## Requirement served

`approvedScope`: discharge a named hypothesis used by `eta1_ceiling` and its two ratio forms.

## Mathematical change

New declarations (namespace `ArkLib.ProximityGap.Frontier.GFCeiling65537`):

- `mu32 := {x : ZMod 65537 | x³² = 1}`, `eta1 := Σ_{x ∈ mu32} ZMod.stdAddChar x`.
- `two_pow_sixteen` (`2¹⁶ = −1`), `orderOf_two` (`= 32`), `mu32_eq_image`
  (`mu32 = {2^k : k < 32}`: 32 distinct roots of a degree-32 polynomial).
- `eta1_eq_etaGF : eta1 = etaGF` (the sum is real), by pairing `2^(16+k) = −2^k`.
- `gfCharSumBridge_eta1 : GFCharSumBridge eta1.re`, `eta1_re_ceiling`, `eta1_im`.

## Verification

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_GFCeilingInstance65537.lean
✅ OK (4s) — Research/ProximityPrize/Frontier/_GFCeilingInstance65537.lean
```

`mu32_eq_image`, `eta1_eq_etaGF`, `gfCharSumBridge_eta1`, `eta1_re_ceiling` each report
`[propext, Classical.choice, Quot.sound]`. Import surfaces, forbidden-token precheck, sorry
census, KB and docs checks pass.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. One `decide` (`(−1 : ZMod 65537) ≠ 1`);
  primality of 65537 by `norm_num`.
- Imports added (Mathlib only): `Analysis.SpecialFunctions.Complex.CircleAddChar`,
  `Algebra.Polynomial.Roots`, `GroupTheory.OrderOfElement`, `Tactic`.

## What remains open

- `n = 32`, `p = 65537` is out of the prize window (`p < n⁴`). No claim on in-window primes.
- No bound in either direction on `M(n)` for prize-shaped parameters.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
