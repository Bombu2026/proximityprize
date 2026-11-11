Branch: `feat/e3-matchable-count-closed-form` (commits `744e652b1` + `19cf0fd3`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): prove MatchableCountClosedForm for every even n

## Summary

`Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean` named the combinatorial input
`MatchableCountClosedForm` — the number of antipodally matchable 6-tuples over `ZMod n` is
`15n³ − 45n² + 40n` for every even `n` — and proved it only at `n = 2, 4` by `decide`
("`decide` cannot reach `n ≥ 8`"). It is now a theorem for every even `n`, and the E₃ bridge
carries a single hypothesis.

This is a field-independent count. It is not a closure of `E₃(μ_n)`: see "What remains open".

## Requirement served

`approvedScope`: discharge a named hypothesis consumed by a named proof path
(`E3_closed_form_of_inputs`, the producer of the `r = 2` rung).

## Mathematical change

New declarations (namespace `ArkLib.ProximityGap.E3ClosedForm`), main ones:

- `halfEnc`, `halfEnc_bijective`, `halfEnc_flip` — coordinates `ZMod (m + m) ≃ Fin m × Bool`
  turning the antipodal shift `x ↦ x + n/2` into a sign flip.
- `card_antipodalBalanced` / `card_antipodalBalanced_eq` — split by sign pattern: only the
  `C(6,3) = 20` patterns with three positive positions contribute (`card_sign_three`), and they
  are all equivalent under a permutation of the positions (`signBalancedCount_comp_perm`,
  `exists_perm_of_card_true`).
- `triple_perm_of_count`, `card_perms3`, `card_sameCount` — over `m` classes there are
  `6m³ − 9m² + 4m` ordered pairs of triples with the same multiplicity vector, via the number
  `6 − 3[a=b] − 3[a=c] − 3[b=c] + 4[a=b=c]` of distinct rearrangements of a triple.
- `matchableCountClosedForm : MatchableCountClosedForm`.
- `E3_closed_form_of_lamLeung` — the bridge with only the Lam–Leung transport as hypothesis.

`20·(6m³ − 9m² + 4m) = 15n³ − 45n² + 40n` at `n = 2m`.

## Relation to existing results

The same cubic is already proved in tree for another encoding of the count: count-balanced
6-tuples over a negation-closed subset `G` of a field
(`E3StrataCharZero.negSymCount_six_closed`, PR #450 of the historical campaign, with `|G|` in
place of `n`). The named `ZMod` Prop was not linked to it and stayed open. This PR proves the
`ZMod` statement directly, without going through that file; the file docstring states the
overlap. A reviewer who prefers a transport from `negSymCount_six_closed` should say so.

## Verification

Base `1e7ebbfeb`, Lean `4.35.0`, Lake `5.0.0-src+eb6cafb`.

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean
'ArkLib.ProximityGap.E3ClosedForm.card_sameCount' depends on axioms: [propext, Classical.choice, Quot.sound]
'ArkLib.ProximityGap.E3ClosedForm.card_antipodalBalanced_eq' depends on axioms: [propext, Classical.choice, Quot.sound]
'ArkLib.ProximityGap.E3ClosedForm.matchableCountClosedForm' depends on axioms: [propext, Classical.choice, Quot.sound]
✅ OK (29s) — Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean
```

Import surfaces, forbidden-token precheck, sorry census, KB lint, KB generated files and docs
integrity: all pass on the branch.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `admit` / `native_decide`: none. The only `decide` added counts the
  64 sign patterns.
- New named residuals: none. One named input removed from the E₃ bridge.
- Imports added (Mathlib only): `Algebra.BigOperators.Fin`, `Data.Fin.VecNotation`,
  `Data.Fintype.BigOperators`, `Logic.Equiv.Fintype`.
- `docs/kb/deltastar-444-concrete-rungs-2026-06-16.md`: dated update line.

## What remains open

- `LamLeungAntipodalMatchable`, the transport from zero-sum 6-tuples of `2^μ`-th roots of unity
  to matchable exponent tuples, is still a hypothesis (`Z = matchableCount n`). It is false when
  `3 ∣ n`, as the file records.
- Nothing here concerns characteristic `p`; the char-`p` validity of the `r = 2` rung and the deep
  rungs are untouched.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
