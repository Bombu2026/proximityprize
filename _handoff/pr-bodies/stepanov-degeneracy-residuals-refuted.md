Branch: `feat/stepanov-degeneracy-residuals-refuted` (commit `e8d2da6c5`, base `1e7ebbfeb`)

Title: feat(ProximityPrize): refute the three Stepanov degeneracy residuals for every set and multiplicity

## Summary

`MajorArcDegenerate B M` (`_StepanovAtBstar.lean`), `PhaseBadSetDegenerate B M`
(`_wf5G2_stepanov_supnorm.lean`) and `DescentMultiplicityBeyondSeparable Sh M`
(`_WallStepanovSubgroupDescent.lean`) have the same body: a nonzero polynomial of degree
`< M·|B|` vanishing to order `M` on `B`. They were recorded as "pre-screened FALSE" from
full-rank measurements at `n ≤ 64`, `M ∈ {2, 3}`. Each host file already proves
`M·|B| ≤ deg F'` for such a polynomial, which is the negation of the residual for every finset
over every field and every `M`. This PR states that.

## Requirement served

`approvedScope`: settle named hypotheses; replace "pre-screened by measurement" with a theorem.

## Mathematical change

- `not_majorArcDegenerate (B) (M) : ¬ MajorArcDegenerate B M`, and `no_bstar_saving` for the
  equivalent form of `bstar_saving_iff_degenerate`.
- `not_phaseBadSetDegenerate (B) (M)`.
- `not_descentMultiplicityBeyondSeparable (Sh) (M)`.

Each is a three-line corollary of the in-file counting lemma (`stepanov_bstar_bound`,
`stepanov_bad_set_bound`, `Stepanov.card_le_natDegree_of_vanishing`). The content is the
reading: the rank measurements were instances of a theorem, not evidence about a major arc.

## Verification

```
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_StepanovAtBstar.lean
✅ OK (3s) — Research/ProximityPrize/Frontier/_StepanovAtBstar.lean
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_wf5G2_stepanov_supnorm.lean
✅ OK (3s) — Research/ProximityPrize/Frontier/_wf5G2_stepanov_supnorm.lean
$ ./scripts/pg-iterate.sh -q Research/ProximityPrize/Frontier/_WallStepanovSubgroupDescent.lean
✅ OK (4s) — Research/ProximityPrize/Frontier/_WallStepanovSubgroupDescent.lean
```

The four new theorems report `[propext, Classical.choice, Quot.sound]`.
`CampaignProvenIndex.lean`, the only importer of `_StepanovAtBstar`, defines neither new name.

TODO before opening: paste the real `./scripts/validate.sh` result.

## Assumption audit

- New axioms: none. `sorry` / `native_decide`: none. No new named residual.
- No import change. `DISPROOF_LOG.md`: new entry `[164-stepanov-degeneracy-residuals-false]`.
- The refutations hold for all parameters; they do not pick a bad value of a free variable.

## What remains open

- No bound on a bad set is obtained. A past-Johnson Stepanov saving cannot be phrased as one of
  these three Props; it would need an auxiliary reduced modulo `X^n − 1` or vanishing imposed on a
  larger set. That statement is not formalized here.

## Disclosure

<paste the footer produced by `run-receipt.mjs disclose --provider anthropic --model <exact id> --client claude-code`>
