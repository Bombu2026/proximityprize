# Draft PR bodies for branches 2–5

Not opened. Before opening each one: re-run `./scripts/pg-iterate.sh` on every touched file and
paste the real output, run `./scripts/validate.sh` (or rely on CI from a draft PR and say so),
re-check that `origin/main` has not moved under the branch, and append the Slop footer generated
by `run-receipt.mjs disclose`. The `pg-iterate` results quoted below were reported by the
integration subagents on base `1e7ebbfeb`; they have not been re-run by the orchestrating session.

---

## PR 2 — branch `feat/width-four-char-zero`

Title: `feat(ProximityGap): prove WidthFourDyadicClassified for dyadic roots of unity in characteristic zero`

### Summary

`ArkLib/Data/CodingTheory/ProximityGap/E2VanishWidthFourFullCount.lean` defines the named
classification hypothesis `WidthFourDyadicClassified` (every four-subset of the domain with
`e₂ = 0` contains an antipodal pair) and proves it false on `μ₃₂ ⊂ 𝔽₉₇`
(`not_widthFourDyadicClassified_zmod97`). Its docstring states that neither the
characteristic-zero statement nor a guarded transfer is proved. This PR proves the
characteristic-zero statement for every `μ_{2^k}`, unconditionally.

### Mathematical change

- `antipodal_pair_of_balanced_products` — for nonzero `a, b, c, d` in a characteristic-zero
  field with `b ≠ c`: if the multiset of the six pairwise products is antipodally balanced, two
  of the four elements are antipodal.
- `widthFourDyadicClassified_charZero (k : ℕ) :
  WidthFourDyadicClassified (Polynomial.nthRootsFinset (2 ^ k) (1 : L))` for any field `L` of
  characteristic zero.

Proof: `e₂ = 0` and `2 ≠ 0` make the six pairwise products, all `2^k`-th roots of unity, sum to
zero. The in-tree Lam–Leung theorem
`LamLeungMultisetAntipodal.count_antipodal_of_sum_eq_zero` makes that multiset antipodally
balanced. So `−ab` and `−ac` are both among the products; every case that shares an index
cancels to an antipodal pair, and the remaining case `−ab = cd`, `−ac = bd` gives
`d (c − b)(c + b) = 0`, hence `b = −c`.

### Requirement served

Discharges a named hypothesis of the width-four `e₂ = 0` bad-scalar locus in characteristic
zero, and shows the `𝔽₉₇` failure is a finite-field artifact rather than a defect of the
statement.

### Verification (to re-run)

`./scripts/pg-iterate.sh ArkLib/Data/CodingTheory/ProximityGap/E2VanishWidthFourFullCount.lean`
→ OK; both new theorems report `[propext, Classical.choice, Quot.sound]`.

### Assumption audit

No new axiom, `sorry`, or named residual. One new import
(`LamLeungMultisetAntipodal`, same downstream library; the file is not in the upstream ArkLib
inventory and nothing imports it).

### What remains open

No cardinality statement is proved: the count `n(n−3)/4` and the two stratum sizes are still
unformalized. Nothing is claimed over `𝔽_q`; a guarded transfer is not proved.

---

## PR 3 — branch `feat/supnorm-directional-net`

Title: `fix(ProximityPrize): show SubGaussianMGF forces zero sum and excludes uncentred Gauss periods`

### Summary

`Research/ProximityPrize/Frontier/SalemZygmundChaining.lean` reduces `prize_floor_of_inputs` to
two named inputs, `SubGaussianMGF η σ²` and `SupNormFromDirectionalNet η σ² C`. This PR shows
that the second follows from the first with `C = 1`, and that the first, as stated, cannot hold
for the uncentred Gauss periods it is meant for.

### Mathematical change

- `supNormFromDirectionalNet_of_subGaussianMGF` — `SubGaussianMGF η σ²` implies
  `SupNormFromDirectionalNet η σ² 1` (take the direction `η_c / ‖η_c‖`; no θ-net and no
  `1 / cos θ` loss).
- `prize_floor_of_subGaussianMGF` — `‖η_c‖ ≤ √(2 σ² log m)` from `SubGaussianMGF` alone.
- `sum_eq_zero_of_mgf_le` and `sum_eq_zero_of_subGaussianMGF` — `SubGaussianMGF η σ²` forces
  `Σ_c η_c = 0`, with no hypothesis on `σ²` (the gap has a local minimum at `λ = 0`, so its
  derivative vanishes there).
- `sum_eta_ne_zero_eq_neg_card` — for the in-tree `SubgroupGaussSumSecondMoment.eta` with a
  primitive character and `0 ∉ G`, the periods over nonzero frequencies sum to `−|G|`.
- `not_subGaussianMGF_eta` — hence those periods satisfy `SubGaussianMGF` for **no** `σ²`.

### Requirement served

Removes one named obligation from the Salem–Zygmund route and refutes the applicability of the
other to the intended object. Both are machine-checked statements about named inputs of
`prize_floor_of_inputs`.

### Verification (to re-run)

`./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/SalemZygmundChaining.lean` → OK; all
reports `[propext, Classical.choice, Quot.sound]`. Three pre-existing warnings in `chernoff_*`
are untouched.

### What remains open

The Salem–Zygmund floor is now conditional on a hypothesis that is false for the raw periods.
A corrected hypothesis (centred periods, or an MGF bound with a mean term) is not supplied
here. The coset-indexed family with sum `−1` is not defined in the tree and is not treated.
No bound on actual Gauss periods is proved.

---

## PR 4 — branch `feat/char0-step-law-all-depth`

Title: `feat(ProximityPrize): transport the char-0 step law to the Bessel coefficient and the real energy at every depth`

### Summary

The AvNT engine already proves the log-derivative step `(r+1) c_{r+1} ≤ m c_r` on its own
convolution power (`besselPow_logDerivIndex`), and its docstring says the link to the energy is
not proved there. `_wf8B2_char0_logconcave` states that char-0 W3-anti is not closed. This PR
proves that the three in-tree Bessel encodings coincide and transports the step to the
multinomial coefficient and to the genuine characteristic-zero energy of `μ_n`. The step
itself is **not** re-proved.

### Mathematical change (new file `Research/ProximityPrize/Frontier/_CharZeroStepLawAllDepth.lean`)

- `avW0_cpow_eq_avNT_cpow`, `besselCoeff_eq_avW0_cpow` — the bridges between
  `PrizeWorkbench.besselCoeff`, `AvW0.cpow` and `AvNT.cpow`.
- `besselCoeff_logDerivIndex`, `rstep_le_one` — the conclusion of
  `char0_W3anti_of_sharpNewton` without the `SharpNewtonBessel` hypothesis.
- `mNorm_succ_le`, `edef_eq_wick_mul_mNorm`, `charZero_backbone` — discharge of the `hdanti`
  hypothesis of `_CharZeroBackboneAntitone`.
- `edef_succ_le`, `energy_eq_besselCoeff_halfBasis`, `energy_succ_le_halfBasis` — the step
  `E_{r+1} ≤ (2r+1) n E_r` on the real energy of `μ_{2^{μ'+1}}` via
  `bessel_identity_halfBasis`.
- `char0WickStep_halfBasis` — discharge of `NT5WrapCrossSplit.Char0WickStep`.
- `crossMass_le_of_charZero_faithful` — the cross-step rung at every depth, for any set whose
  energies are char-0 faithful at depths `r` and `r+1`.

Docstrings made stale by these results are corrected in `_wf8B2_char0_logconcave`,
`_CharZeroBackboneAntitone`, `_BackboneRungTwoExact`, `_AvGER_CharZeroEnergyRecursion` and
`CharZeroStepLawSlack`; `All.lean` is regenerated by `scripts/update-research-lib.py`.

### Verification (to re-run)

`./scripts/pg-iterate.sh` on the six touched `.lean` files → OK; the twelve `#print axioms`
report `[propext, Classical.choice, Quot.sound]`.

### What remains open

Everything here is characteristic zero. Antitonicity `R(r+1) ≤ R(r)` (SharpNewton), char-`p`
faithfulness in the production regime, and `M3CrossStepBound` stay open. No characteristic-`p`
bound is obtained.

---

## PR 5 — branch `feat/e6-doubling-guarded`

Title: `feat(ProximityPrize): prove DoublingBijectionGuarded and refute the unguarded fold hypotheses`

### Summary

In the E6 "doubling" family (`_BridgeB07`, `_Close07a_DoublingFoldMap`,
`_Close07b_DoublingInduction`), `DoublingBijectionGuarded` is marked OPEN and the closure is
recorded as REDUCED to `FoldImageHyp`. This PR proves the guarded statement, refutes the two
unguarded hypotheses it was reduced to, and supplies three theorems the docstrings already
cited but which did not exist.

### Mathematical change (new file `Research/ProximityPrize/Frontier/_Close07d_DoublingGuardedClosure.lean`)

- `cf_double` — for every even `n > 0`, even `k` and `m' ≥ 1`: `cf (2n) k (2m') = cf n (k/2) m'`.
  Grade one forces antipodal closure, the set is then `foldSubset n (A ∩ [0, n))`, and the
  conclusion follows from the existing fold lemmas.
- `doublingBijectionGuarded_holds`, `oddGradeVanishesGuarded_holds`.
- `not_foldImageHyp`, `not_foldingBijection`, `not_doublingBijection`, `not_oddGradeVanishes` —
  refuted at `n = 2`, `k = 1`, `m' = 1` (`cf 4 1 2 = 0`, `cf 2 0 1 ≠ 0`). The instance satisfies
  every hypothesis; the only defect of the refuted Props is the missing parity guard on `k`.

Docstrings of the three existing files are corrected (status, references to non-existent
theorems, "non-power-of-two" → "odd n"), one entry is appended to `DISPROOF_LOG.md`, and
`All.lean` is regenerated.

### Verification (to re-run)

`./scripts/pg-iterate.sh` on `_BridgeB07.lean`, `_Close07a_DoublingFoldMap.lean`,
`_Close07b_DoublingInduction.lean`, `_Close07d_DoublingGuardedClosure.lean` → OK; all reports
within `[propext, Classical.choice, Quot.sound]`.

### Scope, stated plainly

The repository's own KB says `cf` is not the count that governs `m*` and that E6 does not touch
the prize directly. This PR closes a named open item and removes two false reductions from the
bridge programme; it claims nothing about δ*. If the maintainers consider the bridge lane out
of scope, that is the reason.

### What remains open

KB §F (`deltastar-444-empirical-formulas-and-bridges`) still says "REDUCED to FoldImageHyp";
the `_Close07c` docstring cites `oddGradeVanishes_false_at_one`, which does not exist.
