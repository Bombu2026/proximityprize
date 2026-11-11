import Mathlib

/-!
# Scout C: `MobiusCrossRatioIdentity` also holds in characteristic 2

The repo proves `MobiusCrossRatioIdentity F` only under `ringChar F ≠ 2`
(`_R20MobiusDischarge.mobiusCrossRatioIdentity_holds`). In characteristic 2 every element is a
square, so `quadraticChar F x = [x ≠ 0]`; both sides equal `q − 4`. Together with the in-tree
theorem this makes the identity unconditional over every finite field.

`MobiusCrossRatioIdentity` is copied verbatim from
`Research/ProximityPrize/Frontier/_R20QuadFaceBridge.lean:172` (olean not built in the checkout).
-/

open Finset

namespace ArkLib.ProximityGap.Frontier.R20QuadFaceBridge

variable {F : Type*} [Field F] [Fintype F] [DecidableEq F]

def MobiusCrossRatioIdentity (F : Type*) [Field F] [Fintype F] [DecidableEq F] : Prop :=
  ∀ a b c d : F, a ≠ b → a ≠ c → a ≠ d → b ≠ c → b ≠ d → c ≠ d →
    ∑ t : F, quadraticChar F ((t - a) * (t - b) * ((t - c) * (t - d)))
      = quadraticChar F ((a - d) * (b - c))
          * (∑ s : F, quadraticChar F
              (s * ((s - 1) * (s - (a - c) * (b - d) / ((a - d) * (b - c))))))
        - 1

lemma quadraticChar_charTwo (hF : ringChar F = 2) (x : F) :
    quadraticChar F x = if x = 0 then 0 else 1 := by
  split_ifs with hx
  · rw [hx, quadraticChar_zero]
  · exact quadraticChar_eq_one_of_char_two hF hx

lemma sum_quadraticChar_charTwo (hF : ringChar F = 2) (g : F → F) :
    ∑ t : F, quadraticChar F (g t)
      = (Fintype.card F : ℤ) - ((univ.filter (fun t => g t = 0)).card : ℤ) := by
  simp only [quadraticChar_charTwo hF]
  rw [Finset.sum_ite, Finset.sum_const_zero, zero_add, Finset.sum_const, nsmul_eq_mul, mul_one]
  have h := Finset.card_filter_add_card_filter_not (s := (univ : Finset F))
    (fun t => g t = 0)
  rw [Finset.card_univ] at h
  omega

theorem mobiusCrossRatioIdentity_charTwo (hF : ringChar F = 2) : MobiusCrossRatioIdentity F := by
  intro a b c d hab hac had hbc hbd hcd
  set lam : F := (a - c) * (b - d) / ((a - d) * (b - c)) with hlam
  have hnum : (a - c) * (b - d) ≠ 0 :=
    mul_ne_zero (sub_ne_zero.mpr hac) (sub_ne_zero.mpr hbd)
  have hden : (a - d) * (b - c) ≠ 0 :=
    mul_ne_zero (sub_ne_zero.mpr had) (sub_ne_zero.mpr hbc)
  have hlam0 : lam ≠ 0 := div_ne_zero hnum hden
  have hlam1 : lam ≠ 1 := by
    intro h1
    have heq : (a - c) * (b - d) = (a - d) * (b - c) := (div_eq_one_iff_eq hden).mp h1
    have hdiff : (a - b) * (c - d) = 0 := by
      calc (a - b) * (c - d)
          = (a - c) * (b - d) - (a - d) * (b - c) := by ring
        _ = 0 := by rw [heq]; ring
    rcases mul_eq_zero.mp hdiff with h | h
    · exact hab (sub_eq_zero.mp h)
    · exact hcd (sub_eq_zero.mp h)
  rw [sum_quadraticChar_charTwo hF, sum_quadraticChar_charTwo hF,
    quadraticChar_eq_one_of_char_two hF hden, one_mul]
  have hz4 : univ.filter (fun t : F => (t - a) * (t - b) * ((t - c) * (t - d)) = 0)
      = {a, b, c, d} := by
    ext t
    simp only [mem_filter, mem_univ, true_and, mul_eq_zero, sub_eq_zero, mem_insert,
      mem_singleton]
    tauto
  have hz3 : univ.filter (fun s : F => s * ((s - 1) * (s - lam)) = 0) = {0, 1, lam} := by
    ext s
    simp only [mem_filter, mem_univ, true_and, mul_eq_zero, sub_eq_zero, mem_insert,
      mem_singleton]
  have hc4 : ({a, b, c, d} : Finset F).card = 4 := by
    rw [card_insert_of_notMem (by simp [hab, hac, had]),
      card_insert_of_notMem (by simp [hbc, hbd]),
      card_insert_of_notMem (by simp [hcd]), card_singleton]
  have hc3 : ({0, 1, lam} : Finset F).card = 3 := by
    rw [card_insert_of_notMem (by simp [Ne.symm hlam0]),
      card_insert_of_notMem (by simp [Ne.symm hlam1]), card_singleton]
  rw [hz4, hz3, hc4, hc3]
  push_cast
  ring

end ArkLib.ProximityGap.Frontier.R20QuadFaceBridge

#print axioms ArkLib.ProximityGap.Frontier.R20QuadFaceBridge.mobiusCrossRatioIdentity_charTwo
