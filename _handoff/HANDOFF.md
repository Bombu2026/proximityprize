# Passation — contributions Bombu2026 à SlopDotCash/proximityprize

Branche de travail interne (`wip/handoff` sur le fork `Bombu2026/proximityprize`). **Ne jamais ouvrir
de PR depuis cette branche.** Elle sert à reprendre le travail dans une autre session (cloud).

État au 2026-11-11, base `origin/main` = `1e7ebbfeb`.

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
| `feat/e6-doubling-guarded` | `DoublingBijectionGuarded` prouvée ; `FoldImageHyp` et `FoldingBijection` réfutées (n=2, k=1, m'=1) ; famille `_BridgeB07` / `_Close07a` / `_Close07b` | En restauration (travail perdu à la purge du scratchpad). Le KB du repo dit que E6 ne touche pas directement le prix : le dire dans la PR. |
| `feat/char0-step-law-all-depth` | Loi de pas gaussienne char-0 à toute profondeur (`besselCoeff_step`, `Rstep ≤ 1`, décharge de `hdanti`, `Edef_step`, cross-step) | En restauration. Risque de doublon moyen avec le moteur AvNT (`besselPow_logDerivIndex`) : vérifier ce qui est réellement nouveau avant d'ouvrir la PR. |
| `feat/supnorm-directional-net` | `SupNormFromDirectionalNet η σ² 1` depuis `SubGaussianMGF` ; `prize_floor_of_subGaussianMGF` ; en cours : `SubGaussianMGF` force `Σ η_c = 0` (donc inapplicable aux périodes de Gauss non centrées, de somme −1) | En restauration. Résultat mince sans le théorème de somme nulle. |

## Pistes non encore traitées

- `MatchableCountClosedForm` (`Research/ProximityPrize/Frontier/_E3ClosedForm2Power.lean`, vers la
  ligne 161) : vraie pour tout n pair (vérifiée exactement pour n = 2…14), 15n³ − 45n² + 40n via les
  classes antipodales ; l'arbre ne l'a qu'aux puissances de deux. Preuve Lean à écrire.
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
