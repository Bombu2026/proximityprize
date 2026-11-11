Title: feat(ProximityPrize): prove V16PrimEmptyCharP at every prime by root-of-unity orthogonality

## Summary

Prove the named hypothesis `V16PrimEmptyCharP p` at every prime `p` in
`Research/ProximityPrize/Frontier/_wfLB2_Q1Direct_d16.lean`. The file states it as the
"stated, unproved hypothesis" to which Chai–Fan Q1 (Conj 4.12) at `d = 16` at prize scale is
reduced, supported only by a probe scan (`p ≤ 2^24`, scripts not in the tree). It is now a
theorem, and `q1_d16_prize_clean` gets a hypothesis-free form.

This is **not** a proof of Q1 and does not touch the BGK core. See "What remains open".

## Requirement served

`approvedScope`: discharge a lemma used by a named proof path. `LegacyWorkbench.lean` records
Q1 at `d = 16` as "REDUCED (not proven) to the stated, unproved hypothesis `V16PrimEmptyCharP`";
`q1_d16_prize_clean` takes it as its only mathematical input.

## Mathematical change

`V16PrimEmptyCharP p` says: no nonempty `Y ⊆ μ_16(ZMod p)` with `-y ∉ Y` for all `y ∈ Y` has
`Σ_{y∈Y} y^a = 0` for every odd `a < 16`.

New declarations (namespace `ProximityGap.Frontier.Q1DirectD16`):

- `geom_sum_of_pow_eq_one` — for `w ^ d = 1`, `Σ_{a<d} w^a = if w = 1 then d else 0`.
- `not_oddPowerSums_vanish_of_antipodalFree` — over any field `K` and any even `d` with
  `(d : K) ≠ 0`: a nonempty antipodal-free `Y ⊆ μ_d(K)` has some odd `a < d` with
  `Σ_{y∈Y} y^a ≠ 0`.
- `v16PrimEmptyCharP_of_prime (p) [Fact p.Prime] : V16PrimEmptyCharP p` — the instance
  `d = 16` for odd `p`; at `p = 2` negation is the identity, so no nonempty `Y` is
  antipodal-free.
- `q1_d16_prize_clean_of_prime` — `q1_d16_prize_clean` without the `V16PrimEmptyCharP`
  hypothesis.

Proof (character orthogonality, no Newton identities, no size or congruence condition on `p`):
fix `y₀ ∈ Y`. If all odd power sums vanish then `Σ_y (y^a − (−y)^a) = 0` for every `a < d`
(even terms cancel identically). Multiplying by `y₀^{-a}` and summing over `a < d`:

```
0 = Σ_{y∈Y} ( Σ_{a<d} (y/y₀)^a − Σ_{a<d} (−y/y₀)^a ) = d·[y₀ ∈ Y] − d·[−y₀ ∈ Y] = d
```

because `Y` is antipodal-free. Hence `d = 0` in `K`.

The docstring's "expected proof route" (Newton's identities for `p > 8`, then an even/odd
locator) is not needed. Docstrings in the file and the one status line in
`LegacyWorkbench.lean` are updated to say the Prop is proved; nothing else changes.

## Why this implementation

The general statement costs nothing extra and covers every dyadic level `d = 2^k` at every odd
prime, not only `d = 16`. The existing Prop and `q1_d16_prize_clean` are kept unchanged so no
caller breaks.

## Verification

Base `1e7ebbfeb` (`origin/main`), Lean `4.35.0`, Lake `5.0.0-src+eb6cafb`.

```
$ ./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_wfLB2_Q1Direct_d16.lean
'ProximityGap.Frontier.Q1DirectD16.not_oddPowerSums_vanish_of_antipodalFree' depends on axioms: [propext, Classical.choice, Quot.sound]
'ProximityGap.Frontier.Q1DirectD16.v16PrimEmptyCharP_of_prime' depends on axioms: [propext, Classical.choice, Quot.sound]
'ProximityGap.Frontier.Q1DirectD16.q1_d16_prize_clean_of_prime' depends on axioms: [propext, Classical.choice, Quot.sound]
✅ OK — Research/ProximityPrize/Frontier/_wfLB2_Q1Direct_d16.lean
```

(axiom lists unwrapped from the multi-line `#print axioms` output; the six pre-existing reports
are unchanged.)

TODO before opening: paste the real `./scripts/validate.sh` result here.

## Assumption audit

- New axioms: none. `sorry` / `admit` / `native_decide`: none.
- New named residuals or hypotheses: none. One hypothesis is removed from the Q1 `d = 16`
  packaging.
- Imports: `Mathlib` only (unchanged).

## What remains open

- The proof is short because the Prop asks for **all** odd power sums to vanish. That is the
  statement the file names as the genuine obstruction, and it is now settled, but its ease
  shows the difficulty of Q1 at `d = 16` does not live there. It lives in the `p₁ = 0` entry
  slice.
- The bad-reduction prime list `{17, …, 881}` and the threshold `881` remain probe-reported;
  nothing here certifies them.
- Q1 (Conj 4.12) itself, Q2 (Conj 7.1) and the BGK wall are untouched. The production δ*
  verdict stays OPEN.

## Disclosure

Statement search and first proof by `claude-opus-5-5` subagents; generalization to arbitrary even
`d`, in-tree integration and verification by `claude-fable-5-2`, all through Claude Code.

Made via @slopdotcash
AI provider/model: anthropic / claude-fable-5-2
Client / agent tooling: claude-code
Contribution skill revision: N/A - ordinary GitHub contribution without optional run evidence
Attribution status: self-reported
— [contributor]
<!-- slop-contribution-attribution:v1 {"provider":"anthropic","model":"claude-fable-5-2","client":"claude-code","skill_revision":"N/A - ordinary GitHub contribution without optional run evidence"} -->
