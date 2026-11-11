# Passation — contributions Bombu2026 à SlopDotCash/proximityprize

Branche de travail interne (`wip/handoff` sur le fork `Bombu2026/proximityprize`). **Ne jamais ouvrir
de PR depuis cette branche.** Elle sert à reprendre le travail dans une autre session (cloud).

État au 2026-11-11 (mis à jour après la session cloud du même jour), base `origin/main` =
`1e7ebbfeb`.

## Objectif

Faire accepter un maximum de PR ciblées sur `SlopDotCash/proximityprize` (projet Slop « delta-star »)
pour gagner des Points de contributeur. Compte GitHub : `Bombu2026`. Commits signés
`Bombu2026 <261056383+Bombu2026@users.noreply.github.com>`.

## Règles à ne pas enfreindre

- PR uniquement vers `SlopDotCash/proximityprize` (`gh pr create --repo SlopDotCash/proximityprize`),
  jamais vers `Verified-zkEVM/ArkLib`. Une PR par résultat, branche dédiée poussée sur le fork.
- Aucun nouveau `sorry`, `axiom`, `native_decide`. Axiomes permis : `propext`, `Classical.choice`,
  `Quot.sound`. Pas de wrapper vacuous, pas de doublon, pas de réfutation qui exploite une variable
  libre. Ne jamais présenter un résultat conditionnel ou de petite caractéristique comme une clôture.
- Jamais de `lake build` nu : `./scripts/lake-locked.sh build <module>`, `./scripts/pg-iterate.sh
  <fichier>` pour l'itération, `./scripts/validate.sh` pour la validation finale.
- Ne jamais ouvrir d'issue. Ne jamais approuver ni merger. Divulguer fournisseur, modèle et client
  exacts dans chaque PR.
- Titre de PR au format `type(scope): subject`. Corps : résumé, exigence servie, changement
  mathématique, vérification (commandes et sorties réelles), audit d'hypothèses, ce qui reste
  ouvert, puis le pied de page Slop.

## Branches

| Branche | Contenu | État |
|---|---|---|
| `feat/q1-d16-v16prim-empty` | `V16PrimEmptyCharP` prouvée pour tout premier (`_wfLB2_Q1Direct_d16.lean`), lemme général `not_oddPowerSums_vanish_of_antipodalFree`, `q1_d16_prize_clean_of_prime` | Committé, `pg-iterate` OK, axiomes propres. `validate.sh` complet interrompu à ~97 % du build sans erreur : à relancer. PR non ouverte. Corps de PR : `PR1-body.md`. |
| `feat/width-four-char-zero` | `widthFourDyadicClassified_charZero` + `antipodal_pair_of_balanced_products` (`E2VanishWidthFourFullCount.lean`) | Committé, `pg-iterate` OK, axiomes propres. `validate.sh` non lancé. PR non ouverte. |
| `feat/e6-doubling-guarded` | Nouveau `_Close07d_DoublingGuardedClosure.lean` : `doublingBijectionGuarded_holds` (via `cf_double`, vrai pour tout n pair > 0), `oddGradeVanishesGuarded_holds` ; réfutations `not_foldImageHyp`, `not_foldingBijection`, `not_doublingBijection`, `not_oddGradeVanishes` (instance n=2, k=1, m'=1) ; docstrings de `_BridgeB07` / `_Close07a` / `_Close07b` corrigés, entrée DISPROOF_LOG, `All.lean` régénéré | Committé (`3703800fa`), `pg-iterate` OK sur les 4 fichiers, axiomes propres. `validate.sh` non lancé. PR non ouverte. Le KB dit que `cf` n'est pas le comptage qui gouverne `m*` : le dire dans la PR. Reste : KB §F encore « REDUCED to FoldImageHyp ». |
| `feat/char0-step-law-all-depth` | Nouveau `_CharZeroStepLawAllDepth.lean` : ponts entre les trois encodages de Bessel (`besselCoeff`, `AvW0.cpow`, `AvNT.cpow`), `rstep_le_one` sans `SharpNewtonBessel`, décharge de `hdanti` (`charZero_backbone`), `energy_succ_le_halfBasis` sur l'énergie réelle de μ_n, décharge de `Char0WickStep`, cross-step à toute profondeur sous fidélité char-0 | Committé (`4f612faf4`), `pg-iterate` OK sur les 6 fichiers, axiomes propres. Le pas lui-même vient du moteur AvNT existant (pas reprouvé) : la nouveauté est le transport vers l'énergie réelle. `validate.sh` non lancé. PR non ouverte. Tout est en caractéristique 0. |
| `feat/supnorm-directional-net` | `SalemZygmundChaining.lean` : `supNormFromDirectionalNet_of_subGaussianMGF` (C = 1), `prize_floor_of_subGaussianMGF`, `sum_eq_zero_of_subGaussianMGF` (l'hypothèse force Σ η_c = 0), `sum_eta_ne_zero_eq_neg_card`, `not_subGaussianMGF_eta` (les périodes non centrées ne satisfont `SubGaussianMGF` pour aucun σ²) | Committé (`dcc4f7527`), `pg-iterate` OK, axiomes propres. `validate.sh` non lancé. PR non ouverte. Mettre la réfutation en avant dans le titre de la PR. |

### Branches ajoutées par la session cloud du 2026-11-11

Toutes basées sur `1e7ebbfeb`, poussées sur le fork, aucune PR ouverte (un commit de résultat,
parfois suivi d'un commit `docs`/`style` ; `./scripts/lint-style.py <fichiers modifiés>` ne
signale plus rien sur les huit branches `feat/`).
Brouillons de corps de PR : `_handoff/pr-bodies/<nom>.md` (sorties `pg-iterate` réelles ; le
résultat de `validate.sh` et le pied de page Slop restent à coller).

| Branche | Contenu | État |
|---|---|---|
| `feat/b18-divided-difference-complete-homog` | `DividedDifferenceEqCompleteHomog F` prouvée sur tout corps (`_BridgeB18.lean`) : récurrence à un nœud `ddiff_pow_succ`, `ddiff_pow_eq_hsym_list`, `dividedDifferenceEqCompleteHomog` | `pg-iterate` OK, axiomes propres. Contrôles hors build de `validate.sh` OK (712 tests Python, imports, tokens, sorry, KB, docs). |
| `feat/e3-matchable-count-closed-form` | `MatchableCountClosedForm` prouvée pour tout n pair (`_E3ClosedForm2Power.lean`), `E3_closed_form_of_lamLeung` (pont E₃ avec le seul transport Lam–Leung) | `pg-iterate` OK, axiomes propres, contrôles hors build OK. C'était la première « piste non traitée ». |
| `feat/gf65537-genuine-char-sum-bridge` | `GFCharSumBridge` prouvée pour la vraie somme de caractères sur μ₃₂ ⊂ F₆₅₅₃₇ (`eta1_eq_etaGF`, `eta1_re_ceiling`) | `pg-iterate` OK, axiomes propres, contrôles hors build OK. Instance hors fenêtre (β ≈ 3,2) : le dire dans la PR. |
| `feat/r209-raw-quarter-mgf-residual-refuted` | `not_nonzeroQuarterMGFResidual` : le résidu R209 est faux dès que 128 ≤ \|G\| et 2\|G\| ≤ \|F\| | `pg-iterate` OK ; `_R210…` (seul importeur) recompilé OK. Instanciation d'une brique existante : faible nouveauté, à présenter comme telle. |
| `feat/heightgate-char0-vanish-antipodal-two-power` | `Char0VanishImpliesAntipodal (2^a)` prouvée par câblage de `LamLeungTwoPow.vanishing_iff_antipodal_coeffs` ; contre-exemple à n = 6 | `pg-iterate` OK, axiomes propres. Câblage d'un théorème existant. |
| `feat/jac-complete-sum-lift-roots-of-unity` | `CompleteSumLift χ s μ_n` prouvée dans JAC0 et JAC4 ; forme corps fini du lemme de fibres dans `PowMapFiberCard.lean` | Build des trois modules OK, `pg-iterate` OK ×3, axiomes propres. |
| `feat/stepanov-degeneracy-residuals-refuted` | `MajorArcDegenerate`, `PhaseBadSetDegenerate`, `DescentMultiplicityBeyondSeparable` fausses pour tout B et tout M | `pg-iterate` OK ×3. Corollaires de trois lignes de lemmes déjà dans les fichiers : la valeur est de remplacer « pré-criblé » par un théorème. |
| `feat/r389-uniform-wick-budget-refuted` | Nouveau `_R389UniformWickBudgetRefuted.lean` : `not_uniformSubgroupWickBudget (C : ℝ)`, vérification par le noyau de l'obstruction « sous-corps » notée « not kernel-checked » ; `All.lean` régénéré | `pg-iterate` OK, `check-imports` OK, axiomes propres. Témoin GF(p)ˣ ⊂ GF(p²) : ne dit rien des corps premiers, le dire dans la PR. |
| `feat/tao-sparse-zero-bound-finite-field-counterexample` | `not_taoSparseZeroBound_dom23` : `TaoSparseZeroBound` échoue sur μ₁₁ ⊂ F₂₃, k = 1 (`X³ + 2X − 3` a trois racines sur le domaine) ; docstring « or any field » corrigée | `pg-iterate` OK, axiomes propres, `lint-style.py` propre. Contre-exemple de petite caractéristique : à présenter comme tel, rien aux premiers de production. Pas de brouillon de corps de PR. |
| `wip/p1-collinear-triple-free-refuted-unverified` | `not_collinearTripleFree` dans `_P1RateQuarterSharedFreshTripleRefuted.lean` (les témoins du certificat sont tous le mot nul, donc colinéaires) | **NON vérifiée de bout en bout. Ne pas ouvrir de PR avant vérification.** Le fichier hôte (inchangé sur `main`) dépasse 12 Go de RAM à l'élaboration et se fait tuer dans le conteneur cloud. Le terme de preuve n'a été typé que dans une relecture abstraite (les neuf lemmes utilisés pris en hypothèses, énoncés recopiés). À faire sur le Mac : `./scripts/pg-iterate.sh Research/ProximityPrize/Frontier/_P1RateQuarterSharedFreshTripleRefuted.lean`, puis renommer en `feat/…` et retirer l'avertissement du message de commit. |

Recouvrements avec la vague 2 locale (`_handoff/scoutC/NOTES.md`), à arbitrer avant de publier :

- `MatchableCountClosedForm` a été prouvée deux fois, par la même route : fichier d'essai
  `_handoff/scoutC/MatchableCountClosedForm.lean` (définitions recopiées) et branche
  `feat/e3-matchable-count-closed-form` (intégrée au vrai fichier, `pg-iterate` OK, poussée).
  Publier une seule des deux. La branche cite le recouvrement avec
  `E3StrataCharZero.negSymCount_six_closed` signalé par Scout C.
- `Char0VanishImpliesAntipodal` : Scout C la classe « doublon, valeur faible »
  (`VanishingTwoPowSumIsAntipodalPairing` existe déjà, la Prop n'a pas de consommateur). La
  branche `feat/heightgate-…` n'est qu'un câblage : ne la publier que si une PR de câblage est
  jugée utile.
- `DividedDifferenceEqCompleteHomog` : notée « P, ~150 l. » par Scout C et non faite là-bas ;
  faite ici (`feat/b18-…`).
- Non recouvertes par Scout C : `GFCharSumBridge`, `CompleteSumLift`, `UniformSubgroupWickBudget`,
  les trois résidus Stepanov, `NonzeroQuarterMGFResidual`, `CollinearTripleFree`.
- En cours côté Scout C et non touchées ici : `E3CharZero.lean`, `MobiusCharTwo.lean`.

`validate.sh` complet n'a tourné sur aucune branche dans le cloud : son étape de build échoue
sur le fichier P1 ci-dessus, faute de mémoire. Il reste à le lancer sur le Mac, branche par
branche, avant chaque PR.

## Pistes non encore traitées

- `MatchableCountClosedForm` : faite (`feat/e3-matchable-count-closed-form`).
- Candidates repérées le 2026-11-11 par un tri des ~920 Props nommées de `Frontier/` sans preuve
  ni réfutation, vérifiées à la lecture mais pas encore formalisées :
  - `QuadraticFiberLaw` (`_R18QuadraticCurveBridge.lean:43`) : instance χ = `quadraticChar` par
    `quadraticChar_card_sqrts`, puis décharge de `hχR`/`hfiber` dans
    `_R18OrderTwoCharacterBridge.lean`. Petit ; la route R20 contourne déjà ce pont.
  - `TaoSparseZeroBound` : faite (`feat/tao-sparse-zero-bound-finite-field-counterexample`).
  - `SyzdimDictionary` (`_SYZ41SyzdimBridge.lean:249`) : fausse avec A = B = C = ⊥, W = ⊤,
    (X², 1, X, 0, 0). Défaut d'énoncé (les sous-espaces ne sont pas liés aux polynômes).
  - `DomainUniformFiveCliqueFourCollinear` (`_P1RateQuarterFiveFourCliqueBridge.lean:167`) :
    contre-exemple RS[10,1] sur F₁₁ (points de parabole et leurs 10 sécantes), 180–250 lignes.
    Scout C la classe « déjà prouvé/réfuté dans l'arbre » : vérifier avant d'y passer du temps.
  - Généraliser `matchableCountClosedForm` à toute profondeur r (le comptage des 2r-uplets
    appariables vaut (2r)!·[x^r](Σ x^k/k!²)^m) déchargerait `BesselIdentity` pour un `E` concret
    et rendrait `CharZeroWickBoundAllR` inconditionnelle pour ce comptage. Non commencé.
- Écartées au tri (variable libre, défaut d'énoncé dégénéré ou doublon) : `SteinWickResidual`,
  `CrossBandResidual`, `SparseRaggedExcessBound`, `SetBoundClosesDeltaStar`,
  `NaturalQuotientTailLaw`, `ResultantHeightPolyBound`, `EffectiveLinnikGoodPrime` (même forme
  que `CanonicalWidthFourGoodPrimeSupply`), `TrivialEnergyLowerBound`, `StepanovReachesJohnson`,
  `EnergyRatioMonotone`.
- Balayage des Props marquées « stated, unproved », « probe-reported », « OPEN » sous
  `Research/ProximityPrize/Frontier/` : c'est ainsi qu'ont été trouvées les cibles ci-dessus.
- Écartées après examen : les 5 « solicited proofs » de `scripts/axiom_baseline.json` (BKR06 et
  random-linear sont déjà prouvées dans les PR amont ArkLib #1470 et #1471 ; KKH26 est bloqué par
  Thorner–Zaman ; AGL24 est lourd), la route strip SYZ (hypothèse maîtresse réfutée), le
  durcissement de probes Python (voie saturée), `CharZeroWickBoundAllR`, `OffDiagonalKernelBound`,
  `CanonicalWidthFourGoodPrimeSupply`, `SharpHeightLaw`, `GeneralizedVandermondeNonzeroAtFive`,
  `IsolatedCountResidual`.

## Revues de PR ouvertes (rien publié)

Les PR #421 à #427 ont été reproduites localement sur leur head : aucune ne présente de défaut
réel. Brouillons de commentaires dans `REVIEWS.md`. Publier au plus deux revues (elles se
ressemblent), après accord de Sébastien.

## Pour publier une PR

1. `./scripts/pg-iterate.sh <fichier>` puis `./scripts/validate.sh` sur la branche ; coller les
   sorties réelles dans le corps.
2. `git push fork <branche>` puis
   `gh pr create --repo SlopDotCash/proximityprize --base main --head Bombu2026:<branche>`.
3. Pied de page : `node ~/.claude/skills/contribute-to-delta-star/scripts/run-receipt.mjs disclose
   --provider anthropic --model <id exact> --client claude-code`, collé tel quel hors bloc de code.
4. Enregistrement `run-receipt.mjs opened ...` : il ouvre une connexion OAuth Slop dans le
   navigateur, que Sébastien doit valider lui-même. Un échec ne bloque pas la PR.

## Pièges rencontrés

- Le `python3` système du Mac est en 3.9 (pas de `tomllib`) : `export PATH=/opt/homebrew/bin:$PATH`
  avant `pg-iterate.sh` et `validate.sh`.
- Un build complet à froid prend plus d'une heure et environ 12 Go de `.lake`.
- La PR #420 (draft du mainteneur) déplace `Research/` et `ProximityPrize/Extensions` sous
  `ArkLib/` : rebaser dès qu'elle est mergée.
- Les dossiers temporaires de session sont purgés au redémarrage : committer tôt.

### Session cloud (Claude Code web)

- `release.lean-lang.org` est bloqué par la politique réseau : `elan` s'installe depuis
  `raw.githubusercontent.com/leanprover/elan`, et la chaîne `v4.35.0` se pose à la main depuis
  l'archive GitHub `leanprover/lean4` dans `~/.elan/toolchains/leanprover--lean4---v4.35.0`
  (`apt-get install zstd` d'abord). `cache.mathlib.org` est joignable : `cache get` fonctionne.
- 4 cœurs, 15 Go de RAM partagés par toute la session. Un `lake build` complet du cône prend
  des heures et `_P1RateQuarterSharedFreshTripleRefuted.lean` (12 Go à lui seul) le fait
  échouer. Construire seulement les modules utiles
  (`LEAN_NUM_THREADS=2 ./scripts/lake-locked.sh build <modules>`) et ne pas lancer d'autre
  `lean` en parallèle d'un fichier P1.
- Une branche par worktree (`git worktree add ../pp-wt/<nom> -b feat/<nom> origin/main`, puis
  `ln -s <checkout>/.lake <worktree>/.lake`) : `pg-iterate` y fonctionne tel quel.
- Auteur des commits : `git -c user.name=Bombu2026 -c user.email=261056383+Bombu2026@users.noreply.github.com commit`.
