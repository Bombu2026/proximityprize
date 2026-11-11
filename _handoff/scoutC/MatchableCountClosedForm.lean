import Mathlib

/-!
# Scout C: `MatchableCountClosedForm` holds for every even `n`

Target: `ArkLib.ProximityGap.E3ClosedForm.MatchableCountClosedForm`
(`Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean`, line ~161).
The repo definitions are copied verbatim at the end of this file.

Proof route: `ZMod (2m) ≃ Fin m × Bool` (class, half) turns the antipodal shift into a bit flip;
a matchable 6-tuple becomes a pair (sign pattern `s` with three `true`, class tuple `u`) whose
`true`-classes and `false`-classes have the same multiset. There are `C(6,3) = 20` patterns,
and for each the count is `M = #{(x,y) : (Fin 3 → α)² | same fibre counts} = 6a³ − 9a² + 4a`
(orbit–stabiliser under `S₃`). So the count is `20 · (6m³ − 9m² + 4m) = 15n³ − 45n² + 40n`.
-/

open Finset

set_option linter.unusedSectionVars false
set_option linter.unusedSimpArgs false
set_option linter.deprecated false

namespace ScoutC.Matchable

section Generic
variable {α : Type*} [DecidableEq α]

def cnt {ι : Type*} [Fintype ι] (x : ι → α) (a : α) : ℕ :=
  (univ.filter (fun i => x i = a)).card

lemma cnt_comp_equiv {ι κ : Type*} [Fintype ι] [Fintype κ] (x : ι → α) (e : κ ≃ ι) (a : α) :
    cnt (x ∘ e) a = cnt x a := by
  unfold cnt
  rw [← Fintype.card_subtype, ← Fintype.card_subtype]
  exact Fintype.card_congr (e.subtypeEquiv (fun _ => Iff.rfl))

lemma exists_perm_of_cnt {ι : Type*} [Fintype ι] [DecidableEq ι] (x y : ι → α)
    (h : ∀ a, cnt y a = cnt x a) : ∃ σ : Equiv.Perm ι, x ∘ σ = y := by
  have e : ∀ c, {i // y i = c} ≃ {i // x i = c} := fun c =>
    Fintype.equivOfCardEq (by rw [Fintype.card_subtype, Fintype.card_subtype]; exact h c)
  exact ⟨Equiv.ofFiberEquiv e, funext fun i => Equiv.ofFiberEquiv_map e i⟩

lemma orbit_card_mul [Fintype α] {ι : Type*} [Fintype ι] [DecidableEq ι] (x : ι → α) :
    (univ.filter (fun y : ι → α => ∀ a, cnt y a = cnt x a)).card *
      (univ.filter (fun σ : Equiv.Perm ι => x ∘ σ = x)).card = Fintype.card (Equiv.Perm ι) := by
  have hmaps : ∀ σ ∈ (univ : Finset (Equiv.Perm ι)),
      x ∘ σ ∈ univ.filter (fun y : ι → α => ∀ a, cnt y a = cnt x a) := by
    intro σ _
    simp only [mem_filter, mem_univ, true_and]
    intro a; exact cnt_comp_equiv x σ a
  rw [← Finset.card_univ, Finset.card_eq_sum_card_fiberwise hmaps]
  rw [Finset.sum_const_nat]
  intro y hy
  simp only [mem_filter, mem_univ, true_and] at hy
  obtain ⟨σ0, hσ0⟩ := exists_perm_of_cnt x y hy
  subst hσ0
  apply Finset.card_nbij' (fun σ => σ * σ0⁻¹) (fun τ => τ * σ0)
  · intro σ hσ
    simp only [mem_filter, mem_univ, true_and, Finset.mem_coe] at hσ ⊢
    funext i
    have := congrFun hσ (σ0⁻¹ i)
    simpa [Equiv.Perm.mul_apply] using this
  · intro τ hτ
    simp only [mem_filter, mem_univ, true_and, Finset.mem_coe] at hτ ⊢
    funext i
    have := congrFun hτ (σ0 i)
    simpa [Equiv.Perm.mul_apply] using this
  · intro σ _; simp
  · intro τ _; simp

end Generic

section Three
variable {α : Type*} [DecidableEq α] [Fintype α]

def E3 (b01 b02 b12 : Bool) (i j : Fin 3) : Bool :=
  if i = j then true
  else if (i = 0 ∧ j = 1) ∨ (i = 1 ∧ j = 0) then b01
  else if (i = 0 ∧ j = 2) ∨ (i = 2 ∧ j = 0) then b02
  else b12

lemma eq_iff_E3 (x : Fin 3 → α) (i j : Fin 3) :
    x i = x j ↔ E3 (decide (x 0 = x 1)) (decide (x 0 = x 2)) (decide (x 1 = x 2)) i j = true := by
  fin_cases i <;> fin_cases j <;> simp [E3] <;> exact eq_comm

def stabCount (b01 b02 b12 : Bool) : ℕ :=
  (univ.filter (fun σ : Equiv.Perm (Fin 3) => ∀ j, E3 b01 b02 b12 (σ j) j = true)).card

lemma stabCount_fff : stabCount false false false = 1 := by decide
lemma stabCount_tff : stabCount true false false = 2 := by decide
lemma stabCount_ftf : stabCount false true false = 2 := by decide
lemma stabCount_fft : stabCount false false true = 2 := by decide
lemma stabCount_ttt : stabCount true true true = 6 := by decide

lemma stab_eq (x : Fin 3 → α) :
    (univ.filter (fun σ : Equiv.Perm (Fin 3) => x ∘ σ = x)).card =
      stabCount (decide (x 0 = x 1)) (decide (x 0 = x 2)) (decide (x 1 = x 2)) := by
  unfold stabCount
  congr 1
  ext σ
  simp only [mem_filter, mem_univ, true_and, funext_iff, Function.comp_apply]
  exact forall_congr' fun j => eq_iff_E3 x (σ j) j

def poly3 (x : Fin 3 → α) : ℤ :=
  6 - 3 * ((if x 0 = x 1 then 1 else 0) + (if x 0 = x 2 then 1 else 0) + (if x 1 = x 2 then 1 else 0))
    + 4 * (if x 0 = x 1 ∧ x 1 = x 2 then 1 else 0)

lemma orbit_eq_poly (x : Fin 3 → α) :
    ((univ.filter (fun y : Fin 3 → α => ∀ a, cnt y a = cnt x a)).card : ℤ) = poly3 x := by
  have h := orbit_card_mul x
  rw [stab_eq, Fintype.card_perm, Fintype.card_fin] at h
  unfold poly3
  by_cases h01 : x 0 = x 1 <;> by_cases h02 : x 0 = x 2 <;> by_cases h12 : x 1 = x 2
  · simp only [iff_true_intro h01, iff_true_intro h02, iff_true_intro h12, decide_true,
      stabCount_ttt, and_self, if_true] at h ⊢
    norm_num at h ⊢
    exact h
  · exact absurd (h01.symm.trans h02) h12
  · exact absurd (h01.trans h12) h02
  · simp only [iff_true_intro h01, iff_false_intro h02, iff_false_intro h12, decide_true,
      decide_false, stabCount_tff, if_true, if_false, and_false, and_true] at h ⊢
    norm_num at h ⊢; omega
  · exact absurd (h02.trans h12.symm) h01
  · simp only [iff_false_intro h01, iff_true_intro h02, iff_false_intro h12, decide_true,
      decide_false, stabCount_ftf, if_true, if_false, false_and, and_false] at h ⊢
    norm_num at h ⊢; omega
  · simp only [iff_false_intro h01, iff_false_intro h02, iff_true_intro h12, decide_true,
      decide_false, stabCount_fft, if_true, if_false, false_and] at h ⊢
    norm_num at h ⊢; omega
  · simp only [iff_false_intro h01, iff_false_intro h02, iff_false_intro h12, decide_false,
      stabCount_fff, if_false, false_and] at h ⊢
    norm_num at h ⊢; omega

def M (α : Type*) [DecidableEq α] [Fintype α] : ℕ :=
  (univ.filter (fun p : (Fin 3 → α) × (Fin 3 → α) => ∀ a, cnt p.2 a = cnt p.1 a)).card

def e3 : α × α × α ≃ (Fin 3 → α) where
  toFun p := ![p.1, p.2.1, p.2.2]
  invFun x := (x 0, x 1, x 2)
  left_inv p := rfl
  right_inv x := by ext i; fin_cases i <;> rfl

lemma sum_fin3 (F : α → α → α → ℤ) :
    ∑ x : Fin 3 → α, F (x 0) (x 1) (x 2) = ∑ a, ∑ b, ∑ c, F a b c := by
  rw [← (Fintype.sum_equiv (e3 (α := α)) (fun p => F p.1 p.2.1 p.2.2)
    (fun x => F (x 0) (x 1) (x 2)) (fun _ => rfl))]
  rw [Fintype.sum_prod_type]
  simp only [Fintype.sum_prod_type]

lemma M_eq : (M α : ℤ) = 6 * (Fintype.card α : ℤ) ^ 3 - 9 * (Fintype.card α : ℤ) ^ 2
    + 4 * (Fintype.card α : ℤ) := by
  have hM : M α = ∑ x : Fin 3 → α,
      (univ.filter (fun y : Fin 3 → α => ∀ a, cnt y a = cnt x a)).card := by
    unfold M
    rw [Finset.card_filter, Fintype.sum_prod_type]
    simp only [Finset.card_filter]
  rw [hM]
  push_cast
  rw [Finset.sum_congr rfl fun x _ => orbit_eq_poly x]
  unfold poly3
  rw [sum_fin3 (fun a b c => 6 - 3 * ((if a = b then 1 else 0) + (if a = c then 1 else 0)
    + (if b = c then 1 else 0)) + 4 * (if a = b ∧ b = c then 1 else 0))]
  simp only [ite_and, Finset.sum_add_distrib, Finset.sum_sub_distrib, ← Finset.mul_sum]
  simp [Finset.sum_ite_eq, Finset.sum_ite_eq', Finset.sum_const, Finset.card_univ]
  ring

end Three

section Count
variable {α : Type*} [DecidableEq α] [Fintype α]

def balU (s : Fin 6 → Bool) (u : Fin 6 → α) : Prop :=
  ∀ a, (univ.filter (fun i => s i = true ∧ u i = a)).card =
    (univ.filter (fun i => s i = false ∧ u i = a)).card

instance (s : Fin 6 → Bool) : DecidablePred (balU (α := α) s) := fun u => by
  unfold balU; infer_instance

def Count (α : Type*) [DecidableEq α] [Fintype α] : ℕ :=
  (univ.filter (fun t : Fin 6 → α × Bool => ∀ a : α, cnt t (a, true) = cnt t (a, false))).card

lemma sum_fiber (s : Fin 6 → Bool) (u : Fin 6 → α) (b : Bool) :
    ∑ a, (univ.filter (fun i => s i = b ∧ u i = a)).card =
      (univ.filter (fun i => s i = b)).card := by
  rw [Finset.card_eq_sum_card_fiberwise (f := u) (t := univ) (fun _ _ => mem_univ _)]
  refine Finset.sum_congr rfl fun a _ => ?_
  rw [Finset.filter_filter]

lemma card_true_of_balU (s : Fin 6 → Bool) (u : Fin 6 → α) (h : balU s u) :
    (univ.filter (fun i => s i = true)).card = 3 := by
  have h1 := sum_fiber s u true
  have h2 := sum_fiber s u false
  have h3 : ∑ a, (univ.filter (fun i => s i = true ∧ u i = a)).card =
      ∑ a, (univ.filter (fun i => s i = false ∧ u i = a)).card :=
    Finset.sum_congr rfl fun a _ => h a
  have h4 := Finset.card_filter_add_card_filter_not (s := (univ : Finset (Fin 6)))
    (fun i => s i = true)
  simp only [Bool.not_eq_true, Finset.card_univ, Fintype.card_fin] at h4
  omega

lemma cnt_subtype {ι : Type*} [Fintype ι] (p : ι → Prop) [DecidablePred p] (f : ι → α) (a : α) :
    cnt (fun j : {i // p i} => f j) a = (univ.filter (fun i => p i ∧ f i = a)).card := by
  unfold cnt
  rw [← Fintype.card_subtype, ← Fintype.card_subtype]
  exact Fintype.card_congr (Equiv.subtypeSubtypeEquivSubtypeInter p (fun i => f i = a))

lemma K_eq (s : Fin 6 → Bool) (hs : (univ.filter (fun i => s i = true)).card = 3) :
    (univ.filter (fun u : Fin 6 → α => balU s u)).card = M α := by
  have hP : Fintype.card {i // s i = true} = 3 := by rw [Fintype.card_subtype]; exact hs
  have hQ : Fintype.card {i // ¬ s i = true} = 3 := by
    rw [Fintype.card_subtype_compl, hP]; simp
  let e1 : Fin 3 ≃ {i // s i = true} := (Fintype.equivFinOfCardEq hP).symm
  let e2 : Fin 3 ≃ {i // ¬ s i = true} := (Fintype.equivFinOfCardEq hQ).symm
  let Φ : (Fin 6 → α) ≃ (Fin 3 → α) × (Fin 3 → α) :=
    (Equiv.piEquivPiSubtypeProd (fun i => s i = true) (fun _ => α)).trans
      (Equiv.prodCongr (e1.symm.arrowCongr (Equiv.refl α)) (e2.symm.arrowCongr (Equiv.refl α)))
  have h1 : ∀ u a, cnt (Φ u).1 a = (univ.filter (fun i => s i = true ∧ u i = a)).card := by
    intro u a
    have : (Φ u).1 = (fun j : {i // s i = true} => u j) ∘ e1 := rfl
    rw [this, cnt_comp_equiv, cnt_subtype]
  have h2 : ∀ u a, cnt (Φ u).2 a = (univ.filter (fun i => s i = false ∧ u i = a)).card := by
    intro u a
    have : (Φ u).2 = (fun j : {i // ¬ s i = true} => u j) ∘ e2 := rfl
    rw [this, cnt_comp_equiv, cnt_subtype]
    simp only [Bool.not_eq_true]
  unfold M
  rw [← Fintype.card_subtype, ← Fintype.card_subtype]
  refine Fintype.card_congr (Φ.subtypeEquiv fun u => ?_)
  unfold balU
  simp only [h1, h2]
  exact forall_congr' fun a => eq_comm

def boolFinsetEquiv : (Fin 6 → Bool) ≃ Finset (Fin 6) where
  toFun s := univ.filter (fun i => s i = true)
  invFun S i := decide (i ∈ S)
  left_inv s := by funext i; simp
  right_inv S := by ext i; simp

lemma card_s_three :
    (univ.filter (fun s : Fin 6 → Bool => (univ.filter (fun i => s i = true)).card = 3)).card
      = 20 := by
  rw [← Fintype.card_subtype]
  rw [Fintype.card_congr (boolFinsetEquiv.subtypeEquiv (p := fun s : Fin 6 → Bool =>
    (univ.filter (fun i => s i = true)).card = 3) (q := fun S : Finset (Fin 6) => S.card = 3)
    (fun _ => Iff.rfl))]
  rw [Fintype.card_finset_len, Fintype.card_fin]
  rfl

lemma Count_eq : Count α = 20 * M α := by
  have hsplit : Count α = ∑ s : Fin 6 → Bool,
      (univ.filter (fun u : Fin 6 → α => balU s u)).card := by
    have hc : Count α =
        (univ.filter (fun q : (Fin 6 → α) × (Fin 6 → Bool) => balU q.2 q.1)).card := by
      unfold Count
      rw [← Fintype.card_subtype, ← Fintype.card_subtype]
      refine Fintype.card_congr ((Equiv.arrowProdEquivProdArrow _ _ _).subtypeEquiv fun t => ?_)
      unfold balU cnt
      refine forall_congr' fun a => ?_
      have hT : ∀ b : Bool, (univ.filter (fun i => t i = (a, b))) =
          univ.filter (fun i => (t i).2 = b ∧ (t i).1 = a) := by
        intro b
        refine Finset.filter_congr fun i _ => ?_
        rw [Prod.ext_iff]; exact and_comm
      rw [hT true, hT false]
      rfl
    rw [hc, Finset.card_filter, Fintype.sum_prod_type, Finset.sum_comm]
    simp only [Finset.card_filter]
  rw [hsplit]
  have hterm : ∀ s : Fin 6 → Bool, (univ.filter (fun u : Fin 6 → α => balU s u)).card =
      if (univ.filter (fun i => s i = true)).card = 3 then M α else 0 := by
    intro s
    split_ifs with hs
    · exact K_eq s hs
    · rw [Finset.card_eq_zero, Finset.filter_eq_empty_iff]
      intro u _ hu
      exact hs (card_true_of_balU s u hu)
  rw [Finset.sum_congr rfl fun s _ => hterm s, Finset.sum_ite, Finset.sum_const_zero, add_zero,
    Finset.sum_const, card_s_three, smul_eq_mul]

end Count

end ScoutC.Matchable

/-! ## Verbatim copy of the repo definitions
Copied verbatim from `Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean`
(`matchable`, its `Decidable` instance, `matchableCount`, `e3Cubic`, `MatchableCountClosedForm`). -/

namespace ArkLib.ProximityGap.E3ClosedForm

def matchable (n : ℕ) [NeZero n] (t : Fin 6 → ZMod n) : Prop :=
  ∀ x : ZMod n, (Finset.univ.filter (fun i => t i = x)).card
              = (Finset.univ.filter (fun i => t i = x + (n / 2 : ℕ))).card

instance (n : ℕ) [NeZero n] (t : Fin 6 → ZMod n) : Decidable (matchable n t) := by
  unfold matchable; infer_instance

def matchableCount (n : ℕ) [NeZero n] : ℕ :=
  (Finset.univ.filter (fun t : Fin 6 → ZMod n => matchable n t)).card

def e3Cubic (n : ℕ) : ℤ := 15 * (n : ℤ) ^ 3 - 45 * (n : ℤ) ^ 2 + 40 * (n : ℤ)

def MatchableCountClosedForm : Prop :=
  ∀ (n : ℕ) [NeZero n], Even n → (matchableCount n : ℤ) = e3Cubic n

open ScoutC.Matchable

lemma mod_two_halves (v m : ℕ) (hv : v < m + m) : v % m = if v < m then v else v - m := by
  split_ifs with h
  · exact Nat.mod_eq_of_lt h
  · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]

theorem matchableCount_eq_Count (m : ℕ) [NeZero (m + m)] (hm : 0 < m) :
    matchableCount (m + m) = Count (Fin m) := by
  let f : ZMod (m + m) → Fin m × Bool := fun x =>
    (⟨x.val % m, Nat.mod_lt _ hm⟩, decide (m ≤ x.val))
  have hinj : Function.Injective f := by
    intro x y hxy
    simp only [f, Prod.mk.injEq, Fin.mk.injEq, decide_eq_decide] at hxy
    obtain ⟨h1, h2⟩ := hxy
    apply ZMod.val_injective
    have hx := ZMod.val_lt x
    have hy := ZMod.val_lt y
    rw [mod_two_halves _ _ hx, mod_two_halves _ _ hy] at h1
    split_ifs at h1 <;> omega
  have hbij : Function.Bijective f := by
    rw [Fintype.bijective_iff_injective_and_card]
    refine ⟨hinj, ?_⟩
    simp only [ZMod.card, Fintype.card_prod, Fintype.card_fin, Fintype.card_bool]
    ring
  let E : ZMod (m + m) ≃ Fin m × Bool := Equiv.ofBijective f hbij
  have hshift : ∀ x : ZMod (m + m),
      f (x + (((m + m) / 2 : ℕ) : ZMod (m + m))) = ((f x).1, !(f x).2) := by
    intro x
    have hdiv : (m + m) / 2 = m := by omega
    rw [hdiv]
    have hx := ZMod.val_lt x
    have hval : (x + (m : ZMod (m + m))).val = if x.val < m then x.val + m else x.val - m := by
      rw [ZMod.val_add, ZMod.val_natCast, Nat.mod_eq_of_lt (show m < m + m by omega)]
      split_ifs with h
      · exact Nat.mod_eq_of_lt (by omega)
      · rw [Nat.mod_eq_sub_mod (by omega), Nat.mod_eq_of_lt (by omega)]; omega
    simp only [f, Prod.mk.injEq, Fin.mk.injEq]
    rw [hval]
    constructor
    · split_ifs with h
      · rw [Nat.add_mod_right]
      · rw [mod_two_halves _ _ hx, if_neg h, Nat.mod_eq_of_lt (by omega)]
    · split_ifs with h
      · rw [decide_eq_true (by omega : m ≤ x.val + m), decide_eq_false (by omega : ¬ m ≤ x.val)]
        rfl
      · rw [decide_eq_false (by omega : ¬ m ≤ x.val - m), decide_eq_true (by omega : m ≤ x.val)]
        rfl
  have hcnt : ∀ (t : Fin 6 → ZMod (m + m)) (x : ZMod (m + m)),
      (univ.filter (fun i => t i = x)).card = cnt (f ∘ t) (f x) := by
    intro t x
    unfold cnt
    congr 1
    exact Finset.filter_congr fun i _ =>
      ⟨fun h => by rw [Function.comp_apply, h], fun h => hinj h⟩
  have hmatch : ∀ t : Fin 6 → ZMod (m + m),
      matchable (m + m) t ↔ ∀ a : Fin m, cnt (f ∘ t) (a, true) = cnt (f ∘ t) (a, false) := by
    intro t
    unfold matchable
    simp only [hcnt, hshift]
    constructor
    · intro h a
      obtain ⟨x, hx⟩ := hbij.2 (a, true)
      simpa [hx] using h x
    · intro h x
      rcases hfx : f x with ⟨a, b⟩
      cases b
      · simpa using (h a).symm
      · simpa using h a
  unfold matchableCount Count
  rw [← Fintype.card_subtype, ← Fintype.card_subtype]
  exact Fintype.card_congr ((Equiv.arrowCongr (Equiv.refl _) E).subtypeEquiv fun t => hmatch t)

/-- **`MatchableCountClosedForm` holds** (for every even `n`, not only 2-powers). -/
theorem matchableCountClosedForm_holds : MatchableCountClosedForm := by
  intro n _ hn
  obtain ⟨m, rfl⟩ := hn
  have hm : 0 < m := by
    rcases Nat.eq_zero_or_pos m with h | h
    · subst h; exact absurd rfl (NeZero.ne (0 + 0))
    · exact h
  rw [matchableCount_eq_Count m hm, Count_eq, Nat.cast_mul, M_eq]
  simp only [Fintype.card_fin, e3Cubic]
  push_cast
  ring

/-- The bridge consumer now fires with only the Lam–Leung transport hypothesis. -/
theorem E3_closed_form_of_lamLeung (n : ℕ) [NeZero n] (hn : Even n)
    (Z : ℕ) (hLL : Z = matchableCount n) : (Z : ℤ) = e3Cubic n := by
  rw [hLL]; exact matchableCountClosedForm_holds n hn

end ArkLib.ProximityGap.E3ClosedForm

#print axioms ArkLib.ProximityGap.E3ClosedForm.matchableCountClosedForm_holds
#print axioms ArkLib.ProximityGap.E3ClosedForm.E3_closed_form_of_lamLeung
