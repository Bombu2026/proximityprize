/-
Copyright (c) 2026 ArkLib Contributors. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: ArkLib Contributors
-/
import Mathlib

/-!
# Q1 at `d = 16` via the DIRECT resultant/norm route (#407, lane LB2)

Continuation of lane `wf-LB`.  `wf-LB` REFUTED the Chai–Fan Q1 (Conj 4.12) **route (i)**
self-similarity bootstrap in char-`p` at `d = 32` (`(∗)_d : x₁ = 0 ⟹ x_a = 0` fails;
explicit `Y ⊂ ℤ/32`, `p = 1048609`, `p₁ = 0` but `p₃ ≠ 0`).  It noted `d = 16` is the last
clean dyadic level, and that closing Q1 at `d ≥ 16` needs *either* the full odd-symmetric
hypothesis *or* the **resultant form `R_d ≠ 0` directly**.

This file (lane `wf-LB2`) carries out the **DIRECT route at `d = 16`** — not self-similarity.
The companion probes `scripts/probes/probe_wfLB2_resultant_d16.py`,
`probe_wfLB2_d16_allsizes.py`, `probe_wfLB2_threshold.py` compute, exhaustively and exactly:

  * **The primitive gap variety `V_16^prim` is reported empty in every characteristic scanned.**
    No antipodal-free, char-0-nonzero config `Y ⊆ μ_16` has *all* odd power sums `p_a(Y) ≡ 0`
    over any `F_p` (the "FULL odd-descent" / genuine-Q1-obstruction count is `0` across all
    primes scanned, `p ≤ 2^24`, and over `ℂ` by Lam–Leung).  This emptiness is the Prop
    `V16PrimEmptyCharP` (see §3); it is now PROVED at every prime in §4
    (`v16PrimEmptyCharP_of_prime`).  (The probe scripts named above are not present in the
    current tree.)

  * **The `p₁ = 0` ENTRY slice has an explicit, finite bad-reduction prime set.**  The
    antipodal-free, char-0-nonzero configs with merely `p₁(Y) ≡ 0 (mod p)` exist for exactly
    `p ∈ {17, 97, 113, 193, 241, 337, 353, 401, 433, 577, 881}` (dense scan over all
    `p ≡ 1 (mod 16)`, `p < 40000`; no resurgence).  The **bad-reduction threshold is `881`**.

  * **`881 < 16⁴` (the prize floor).**  The prize regime has `p = n^β`, `β ≥ 4`, `n = 16`, so
    `p ≥ 16⁴ = 65536 ≫ 881`.  Every `p₁`-entry artifact is gone by a `74×` margin, and the
    genuine `V_16^prim` is empty regardless (§4, a Lean proof).  The `p₁`-entry prime list and
    the threshold `881` remain probe-reported.

**What this file proves axiom-clean (char-free / arithmetic):**

1. `oddSymmetricVanishing_imp_antipodal_d16` — the structural input Q1 needs, restated for the
   `d = 16` use: if the locator `σ_Y = ∏(X − y)` of a finite config has *all* odd coefficients
   zero (i.e. all odd elementary symmetric functions vanish, the full odd-descent), then `Y` is
   antipodal (`Y = −Y`).  This is exactly the property the probe verifies the genuine
   `V_16^prim` points would need — and finds NONE possess.  (Char-free; the input route (i)
   could not deliver from `x₁ = 0` alone, per `wf-LB`.)

2. `q1_d16_badReduction_threshold_below_prize` — the arithmetic gate: the bad-reduction
   threshold `881` is strictly below the prize floor `16⁴ = 65536`, so no prize-scale prime
   `p ≡ 1 (mod 16)` (`p ≥ 16⁴`) is a bad-reduction prime for the `p₁`-entry slice.

3. `q1_d16_prize_clean` — a CONDITIONAL packaging: for `p ≥ 16⁴`, `881 < p` together with the
   hypothesis `V16PrimEmptyCharP p` (returned unchanged).  The char-p emptiness of `V_16^prim`
   (the genuine obstruction) is the **named hypothesis** `V16PrimEmptyCharP` (proved in §4), which
   now encodes the actual emptiness statement over `ZMod p` (audit 2026-10-28, CW-B18-09: an
   earlier version defined it as `881 < p → True`, which is trivially true, so the "Q1 holds at
   `d = 16`" claim was vacuous).  The literal `881` is the probe's output, not derived in Lean;
   nothing in this file certifies the prime list `{17, …, 881}`.

4. `v16PrimEmptyCharP_of_prime` — `V16PrimEmptyCharP p` holds at EVERY prime `p`, by
   orthogonality of the characters of `μ_16` (`not_oddPowerSums_vanish_of_antipodalFree`, stated
   for any even `d` nonzero in the field).  `q1_d16_prize_clean_of_prime` is the resulting
   hypothesis-free packaging.  This discharges the Prop as stated (ALL odd power sums vanish); it
   does not certify the `p₁ = 0` entry slice or the literal `881`, and it is not a proof of Q1.

**Honest scope (`tag: proven-per-fixed-d` for the arithmetic gate `881 < 16⁴` and for the
`V_16^prim = ∅` char-p emptiness of §4; the bad-reduction prime list is probe-reported only).**
This is a concrete *increment* on Chai–Fan Q1 at the last clean dyadic level — NOT a closure of
the prize: Q1/Q2 gate only the Action–Orbit (non-BGK) lane, and the open core (BGK wall) is
untouched.  Axiom-clean (`propext, Classical.choice, Quot.sound`).  Issue #407.
-/

open Polynomial Finset

namespace ProximityGap.Frontier.Q1DirectD16

/-! ## 1. The structural input Q1 needs at `d = 16` (char-free).

The genuine `V_16^prim` obstruction would be an antipodal-free config whose locator is even
(all odd coefficients vanish).  We restate the char-free fact that an even locator forces
antipodality — so a *primitive* (non-antipodal) point CANNOT have an even locator.  The probe
reports no char-p config achieves the full odd-descent for the scanned primes (stated as the
hypothesis `V16PrimEmptyCharP`, proved in §4); this lemma is the char-free half that makes "full odd-descent ⟹ antipodal"
rigorous. -/

variable {F : Type*} [Field F] [DecidableEq F]

/-- A polynomial all of whose odd coefficients vanish evaluates evenly: `P(-z) = P(z)`. -/
theorem eval_neg_eq_eval_of_oddCoeffZero {P : F[X]}
    (hOddCoeff : ∀ i : ℕ, Odd i → P.coeff i = 0) (z : F) :
    P.eval (-z) = P.eval z := by
  classical
  rw [Polynomial.eval_eq_sum_range, Polynomial.eval_eq_sum_range]
  refine Finset.sum_congr rfl ?_
  intro i _hi
  by_cases hiOdd : Odd i
  · simp [hOddCoeff i hiOdd]
  · have hiEven : Even i := Nat.not_odd_iff_even.mp hiOdd
    rw [hiEven.neg_pow z]

/-- **The full odd-descent forces antipodality (char-free).**

If the locator `σ_Y = ∏_{y∈Y}(X − y)` of a finite config `Y` has *all* odd coefficients zero —
i.e. every odd elementary symmetric function of `Y` vanishes, the complete odd-descent — then
`Y` is antipodal: `Y.image (-·) = Y`.  Hence any **primitive** (non-antipodal) point of the gap
variety canNOT satisfy the full odd-descent.  This is the exact property the direct-route probe
checks of the genuine `V_16^prim` obstruction at `d = 16` and reports NO char-p config achieves
(for the scanned primes; the emptiness itself is `V16PrimEmptyCharP`, proved in §4).  (`wf-LB`'s route (i) tried to obtain this from
`x₁ = 0` alone; that is impossible char-free.) -/
theorem oddSymmetricVanishing_imp_antipodal_d16 (Y : Finset F)
    (hOddCoeff : ∀ i : ℕ, Odd i → (∏ y ∈ Y, (X - C y)).coeff i = 0) :
    Y.image (fun x => -x) = Y := by
  classical
  set P := ∏ y ∈ Y, (X - C y) with hPdef
  have heven : ∀ z : F, P.eval (-z) = P.eval z :=
    eval_neg_eq_eval_of_oddCoeffZero hOddCoeff
  have hclosed : ∀ x ∈ Y, -x ∈ Y := by
    intro x hx
    have hx0 : P.eval x = 0 := by
      rw [hPdef, eval_prod]; exact Finset.prod_eq_zero hx (by simp)
    have hnegroot : P.eval (-x) = 0 := by rw [heven x, hx0]
    rw [hPdef, eval_prod, Finset.prod_eq_zero_iff] at hnegroot
    obtain ⟨y, hy, hzero⟩ := hnegroot
    simp only [eval_sub, eval_X, eval_C] at hzero
    rw [sub_eq_zero.mp hzero]; exact hy
  have hsub : Y.image (fun x => -x) ⊆ Y := by
    intro z hz
    rw [Finset.mem_image] at hz
    obtain ⟨x, hx, rfl⟩ := hz
    exact hclosed x hx
  have hcard : (Y.image (fun x => -x)).card = Y.card :=
    Finset.card_image_of_injective Y neg_injective
  exact Finset.eq_of_subset_of_card_le hsub (le_of_eq hcard.symm)

/-! ## 2. The arithmetic bad-reduction gate at `d = 16` (proven-per-fixed-d).

The direct-route probes pin the `p₁ = 0` ENTRY bad-reduction primes EXACTLY:
`{17, 97, 113, 193, 241, 337, 353, 401, 433, 577, 881}`, threshold `881`, no resurgence below
`40000`.  The prize floor is `16⁴ = 65536`.  We prove `881 < 16⁴`, so no prize-scale prime is a
bad-reduction prime for the entry slice. -/

/-- The exact bad-reduction threshold for the `d = 16` `p₁ = 0` entry slice
(largest prime `p ≡ 1 (mod 16)` admitting an antipodal-free, char-0-nonzero `p₁ ≡ 0` config). -/
def badReductionThresholdD16 : ℕ := 881

/-- The prize floor at `n = 16`, `β = 4`: `p ≥ 16⁴ = 65536`. -/
def prizeFloorD16 : ℕ := 16 ^ 4

/-- **The bad-reduction threshold is strictly below the prize floor.**  `881 < 16⁴ = 65536`.
Hence every prize-scale prime `p ≥ 16⁴` is clean of the `p₁`-entry artifact (`proven-per-fixed-d`,
the threshold itself being the exhaustive probe output). -/
theorem q1_d16_badReduction_threshold_below_prize :
    badReductionThresholdD16 < prizeFloorD16 := by
  unfold badReductionThresholdD16 prizeFloorD16; norm_num

/-- Restatement: any prime at or above the prize floor strictly exceeds the bad-reduction
threshold, so it is NOT a `p₁`-entry bad-reduction prime. -/
theorem prize_prime_above_badReduction {p : ℕ} (hp : prizeFloorD16 ≤ p) :
    badReductionThresholdD16 < p :=
  lt_of_lt_of_le q1_d16_badReduction_threshold_below_prize hp

/-! ## 3. The conditional packaging: Q1 at `d = 16` for prize-scale primes, given `V16PrimEmptyCharP`.

The genuine `V_16^prim` emptiness in char-`p` (the real obstruction — all odd power sums
vanishing) is the named hypothesis `V16PrimEmptyCharP` (proved in §4).  Combined with the
char-free antipodality lemma and the arithmetic gate, Q1 at `d = 16` at prize scale is reduced to it. -/

/-- **The primitive gap variety at `d = 16` is empty over `ZMod p`** (proved at every prime in §4,
`v16PrimEmptyCharP_of_prime`; kept as a named Prop for the conditional packaging below).
`V16PrimEmptyCharP p` asserts there is no nonempty, antipodal-free config `Y ⊆ μ_16(ZMod p)` whose
odd power sums `p_a(Y) = Σ_{y∈Y} y^a` all vanish (`a` odd; since `y^16 = 1` it suffices to take
`a < 16`).  The probe reported this count `= 0` for all `p ≡ 1 (mod 16)`, `p ≤ 2^24` (probe script
not present in the current tree).  Expected proof route (not formalized): antipodal-free forces
`|Y| ≤ 8`, so for `p > 8` Newton's identities turn vanishing odd power sums into vanishing odd
elementary symmetric functions; the locator is then even or odd, hence `Y = −Y`
(`oddSymmetricVanishing_imp_antipodal_d16`, or `0 ∈ Y` in the odd case), contradicting
`Y` nonempty and antipodal-free.  Audit 2026-10-28 (CW-B18-09): this replaces a former vacuous
definition `881 < p → True`. -/
def V16PrimEmptyCharP (p : ℕ) : Prop :=
  ∀ Y : Finset (ZMod p), Y.Nonempty → (∀ y ∈ Y, y ^ 16 = 1) → (∀ y ∈ Y, -y ∉ Y) →
    ¬ ∀ a : ℕ, Odd a → a < 16 → ∑ y ∈ Y, y ^ a = 0

/-- **Conditional packaging at `d = 16` for prize-scale primes.**

For `p ≥ 16⁴`: (a) `p` exceeds the probe-reported bad-reduction threshold `881`
(`prize_prime_above_badReduction`; the threshold value itself is not certified in Lean); (b) the
genuine obstruction `V_16^prim` is empty ASSUMING `V16PrimEmptyCharP p` (passed through unchanged;
see `q1_d16_prize_clean_of_prime` for the hypothesis-free form).  So this records "Q1 at `d = 16` holds at `p` provided `V16PrimEmptyCharP p`";
it is NOT an unconditional proof of Q1 at `d = 16`. -/
theorem q1_d16_prize_clean {p : ℕ} (hp : prizeFloorD16 ≤ p)
    (hV : V16PrimEmptyCharP p) :
    badReductionThresholdD16 < p ∧ V16PrimEmptyCharP p :=
  ⟨prize_prime_above_badReduction hp, hV⟩

/-- The increment in one statement: the structural antipodality lemma (char-free) AND the
arithmetic gate (`881 < 16⁴`).  This is the precise, honest content of the direct route at the
last clean dyadic level — Q1's char-free input plus the proven sub-prize bad-reduction bound. -/
theorem direct_route_d16_increment :
    (∀ Y : Finset ℚ, (∀ i : ℕ, Odd i → (∏ y ∈ Y, (X - C y)).coeff i = 0) →
        Y.image (fun x => -x) = Y) ∧
    badReductionThresholdD16 < prizeFloorD16 :=
  ⟨fun Y h => oddSymmetricVanishing_imp_antipodal_d16 Y h,
   q1_d16_badReduction_threshold_below_prize⟩

/-! ## 4. `V16PrimEmptyCharP` holds at every prime (orthogonality on `μ_d`).

The emptiness hypothesis of §3 is discharged by a character-orthogonality argument that needs
neither Newton's identities nor any size or congruence condition on `p`.  Fix `y₀ ∈ Y`.  For
`w ^ d = 1` the full geometric sum `Σ_{a<d} w^a` is `d` if `w = 1` and `0` otherwise.  If every
odd power sum of `Y` vanishes, then `Σ_y (y^a − (−y)^a) = 0` for every `a < d` (the even terms
cancel identically), hence

  `0 = Σ_{a<d} y₀^{-a} Σ_{y∈Y} (y^a − (−y)^a) = d · (#{y ∈ Y : y = y₀} − #{y ∈ Y : −y = y₀}) = d`,

the last step because `Y` is antipodal-free.  So `d = 0` in the field.

Scope: this proves the Prop `V16PrimEmptyCharP` exactly as stated (ALL odd power sums vanish).
It says nothing about the `p₁ = 0` entry slice, whose bad-reduction prime list and threshold `881`
remain probe-reported, and it is not a proof of Chai–Fan Q1 (Conj 4.12). -/

/-- The full geometric sum of a `d`-th root of unity: `d` at `w = 1`, zero otherwise. -/
theorem geom_sum_of_pow_eq_one {K : Type*} [Field K] [DecidableEq K] {d : ℕ} (w : K)
    (hw : w ^ d = 1) : ∑ a ∈ range d, w ^ a = if w = 1 then (d : K) else 0 := by
  split_ifs with h
  · subst h; simp
  · rw [geom_sum_eq h d, hw, sub_self, zero_div]

/-- **No antipodal-free configuration of `d`-th roots of unity has all odd power sums zero.**
Over any field in which the even number `d` is nonzero, a nonempty `Y ⊆ μ_d` with `-y ∉ Y` for
every `y ∈ Y` has some odd `a < d` with `Σ_{y ∈ Y} y ^ a ≠ 0`. -/
theorem not_oddPowerSums_vanish_of_antipodalFree {K : Type*} [Field K] [DecidableEq K] {d : ℕ}
    (hd : Even d) (hdK : (d : K) ≠ 0) (Y : Finset K) (hne : Y.Nonempty)
    (hμ : ∀ y ∈ Y, y ^ d = 1) (hfree : ∀ y ∈ Y, -y ∉ Y) :
    ¬ ∀ a : ℕ, Odd a → a < d → ∑ y ∈ Y, y ^ a = 0 := by
  intro hsum
  obtain ⟨y0, hy0⟩ := hne
  have hd0 : d ≠ 0 := by
    rintro rfl
    exact hdK Nat.cast_zero
  have hy0ne : y0 ≠ 0 := by
    intro h
    have h1 := hμ y0 hy0
    rw [h, zero_pow hd0] at h1
    exact zero_ne_one h1
  have hinner : ∀ a ∈ range d, ∑ y ∈ Y, (y ^ a - (-y) ^ a) = 0 := by
    intro a ha
    rcases Nat.even_or_odd a with he | ho
    · simp [he.neg_pow]
    · simp only [ho.neg_pow, sub_neg_eq_add, sum_add_distrib, hsum a ho (mem_range.mp ha),
        add_zero]
  have hS0 : ∑ a ∈ range d, (∑ y ∈ Y, (y ^ a - (-y) ^ a)) * y0⁻¹ ^ a = 0 :=
    sum_eq_zero fun a ha => by rw [hinner a ha, zero_mul]
  have hswap : ∑ a ∈ range d, (∑ y ∈ Y, (y ^ a - (-y) ^ a)) * y0⁻¹ ^ a
      = ∑ y ∈ Y, (∑ a ∈ range d, (y * y0⁻¹) ^ a - ∑ a ∈ range d, (-y * y0⁻¹) ^ a) := by
    simp_rw [sum_mul, ← sum_sub_distrib]
    rw [sum_comm]
    refine sum_congr rfl fun y _ => sum_congr rfl fun a _ => ?_
    rw [mul_pow, mul_pow, sub_mul]
  have hc : y0⁻¹ ^ d = 1 := by rw [inv_pow, hμ y0 hy0, inv_one]
  have hterm : ∀ y ∈ Y,
      (∑ a ∈ range d, (y * y0⁻¹) ^ a - ∑ a ∈ range d, (-y * y0⁻¹) ^ a)
        = if y = y0 then (d : K) else 0 := by
    intro y hy
    rw [geom_sum_of_pow_eq_one (y * y0⁻¹) (by rw [mul_pow, hμ y hy, hc, one_mul]),
      geom_sum_of_pow_eq_one (-y * y0⁻¹)
        (by rw [mul_pow, hd.neg_pow, hμ y hy, hc, one_mul])]
    have h1 : y * y0⁻¹ = 1 ↔ y = y0 := mul_inv_eq_one₀ hy0ne
    have h2 : ¬ (-y * y0⁻¹ = 1) := by
      rw [mul_inv_eq_one₀ hy0ne]
      intro h
      exact hfree y hy (h ▸ hy0)
    rw [if_neg h2, sub_zero]
    by_cases hyy : y = y0
    · rw [if_pos (h1.mpr hyy), if_pos hyy]
    · rw [if_neg (fun h => hyy (h1.mp h)), if_neg hyy]
  rw [hswap, sum_congr rfl hterm, sum_ite_eq' Y y0 (fun _ => (d : K)), if_pos hy0] at hS0
  exact hdK hS0

/-- **`V16PrimEmptyCharP` holds at every prime.**  For odd `p` this is
`not_oddPowerSums_vanish_of_antipodalFree` at `d = 16` (`16 ≠ 0` in `ZMod p`); at `p = 2`
negation is the identity, so no nonempty configuration is antipodal-free. -/
theorem v16PrimEmptyCharP_of_prime (p : ℕ) [hp : Fact p.Prime] : V16PrimEmptyCharP p := by
  by_cases hp2 : p = 2
  · subst hp2
    intro Y ⟨y0, hy0⟩ _ hfree _
    exact hfree y0 hy0 (by rw [ZMod.neg_eq_self_mod_two]; exact hy0)
  · have h16 : ((16 : ℕ) : ZMod p) ≠ 0 := by
      intro h
      have hdvd : p ∣ 2 ^ 4 := (ZMod.natCast_eq_zero_iff 16 p).mp h
      exact hp2 ((Nat.prime_dvd_prime_iff_eq hp.out Nat.prime_two).mp
        (hp.out.dvd_of_dvd_pow hdvd))
    intro Y hne hμ hfree
    classical
    exact not_oddPowerSums_vanish_of_antipodalFree (d := 16) (by decide) h16 Y hne hμ hfree

/-- **Unconditional form of `q1_d16_prize_clean`.**  For a prime `p ≥ 16⁴` the hypothesis
`V16PrimEmptyCharP p` is no longer an input.  The threshold `881` is still the probe's output. -/
theorem q1_d16_prize_clean_of_prime {p : ℕ} [Fact p.Prime] (hp : prizeFloorD16 ≤ p) :
    badReductionThresholdD16 < p ∧ V16PrimEmptyCharP p :=
  q1_d16_prize_clean hp (v16PrimEmptyCharP_of_prime p)

end ProximityGap.Frontier.Q1DirectD16

/-! ## Axiom audit -/
#print axioms ProximityGap.Frontier.Q1DirectD16.eval_neg_eq_eval_of_oddCoeffZero
#print axioms ProximityGap.Frontier.Q1DirectD16.oddSymmetricVanishing_imp_antipodal_d16
#print axioms ProximityGap.Frontier.Q1DirectD16.q1_d16_badReduction_threshold_below_prize
#print axioms ProximityGap.Frontier.Q1DirectD16.prize_prime_above_badReduction
#print axioms ProximityGap.Frontier.Q1DirectD16.q1_d16_prize_clean
#print axioms ProximityGap.Frontier.Q1DirectD16.direct_route_d16_increment
#print axioms ProximityGap.Frontier.Q1DirectD16.not_oddPowerSums_vanish_of_antipodalFree
#print axioms ProximityGap.Frontier.Q1DirectD16.v16PrimEmptyCharP_of_prime
#print axioms ProximityGap.Frontier.Q1DirectD16.q1_d16_prize_clean_of_prime
