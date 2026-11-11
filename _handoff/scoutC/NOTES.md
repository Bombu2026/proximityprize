# Scout C (vague 2) — notes de travail

Fichiers d'essai dans ce dossier ; compilation via `./scripts/pg-iterate.sh <chemin absolu>` depuis le checkout.

## Cible principale
- `MatchableCountClosedForm` (Frontier/_E3ClosedForm2Power.lean:161) — PROUVÉ pour tout n pair :
  `MatchableCountClosedForm.lean` compile (pg-iterate ✅, axiomes propext/choice/Quot.sound), défs copiées
  verbatim (vérifié par diff). Seul consommateur : `E3_closed_form_of_inputs` (même fichier).
  Recouvrement : l'identité combinatoire existe déjà sous un autre encodage (`E3StrataCharZero.negSymCount_six_closed`,
  G ⊆ F fini clos par négation) mais n'était pas reliée à la Prop ZMod.
- `MobiusCrossRatioIdentity` en car. 2 — PROUVÉ : `MobiusCharTwo.lean` compile ✅ (axiomes OK). Avec
  `mobiusCrossRatioIdentity_holds` (car ≠ 2) l'identité devient inconditionnelle ; les assemblages aval
  supposent toutefois déjà `ringChar F ≠ 2`.
- E₃ char 0 inconditionnel (`E3CharZero.lean`, en cours) : zeroSumCount(μ_{2^m},6) = 15n³−45n²+40n dans tout
  corps de car. 0, via `halfBasisIndepZ_of_primitiveRoot` (Lam–Leung 2-puissance déjà dans ArkLib) ;
  ferme le « separate step » laissé ouvert par REnergyThreeCharZero.lean et rend `hLL` prouvable en car. 0.

## Candidats examinés (balayage, ~75 par un sous-agent Explore + lectures directes)
Verdict en une ligne : P = prouvable élémentaire, F = faux, D = dur/écarté, S = schématique (prédicat libre),
AP = déjà prouvé/réfuté dans l'arbre, PH = placeholder `True`.

- Char0VanishImpliesAntipodal (Frontier/HeightGateNormBound.lean:300) — F tel qu'énoncé (n = 6, S = {0,2,4}) mais docstring vise n = 2^a ; non consommé ; pour 2^a découle de `LamLeung.VanishingTwoPowSumIsAntipodalPairing` (doublon). Valeur faible.
- TrivialEnergyLowerBound (Frontier/_wf407_lower.lean:194) — doublon de `additiveEnergy_ge_swap_floor` (AdditiveEnergySwapFloors:47) à un pont/cast près ; non consommé. Écarté.
- CrossBandResidual (Frontier/Sweep_A02_AutocorrelationRecursion.lean:355) — F trivialement (Er : ℝ libre quantifié ∀, r = 1, Er = n+1) : encodage défectueux (Er devrait être l'énergie E_r), non consommé ; motif « variable libre », ne compte pas comme réfutation mathématique.
- LinnikLeastPrimeBelowPrize — D. DifferenceSignatureInjectiveModInversion — S.
- DividedDifferenceEqCompleteHomog (Frontier/_BridgeB18.lean:273) — P (identité classique, récurrence de Newton), non consommé, preuve moyenne (~150 l.).
- AlternantFactorsConstant (Frontier/_ChebotarevAlternantFour.lean:396) — vrai numériquement, D (cas Lucas n ≤ p ≤ d).
- MobiusCrossRatioIdentity, car. 2 (Frontier/_R20QuadFaceBridge.lean:172) — P : prouvé dans l'arbre seulement sous `ringChar F ≠ 2` ; en car. 2 les deux membres valent q−4. Consommé par `intQuartic_distinct_bound`.
- LandauNormCeiling (Frontier/WF407_T01NormLandauCeiling:97) — S (prédicat `isResultant` libre).
- OrthonormalKernel (Frontier/_ShawCancellationLaw:167) — S ; instance = orthogonalité des caractères.
- QuadraticFiberLaw (Frontier/_R18QuadraticCurveBridge:43) — S ; pour χ = quadraticChar c'est `quadraticChar_card_sqrts` (wrapper) ; faux pour le caractère trivial.
- DivisorBound (Frontier/_G80OProductDivisorInterval:72) — S (trivial à D = M).
- SubOneValuationFinite — AP (`subOneValuationFinite_holds`).
- LowerTaylorValuationDominant — D.
- DependentRandomChoiceCore — D (BSG/DRC).
- AP : CatalanMomentMatchesEnergyTwo, ProperIncidenceLeLength, OddGradeVanishesStrong, NaiveDiffReps, CongruenceMethodPhaseBlindOnF2, FlatDudleyBelowTrivial, FiberCountResidual, StandardVandermondeNonzeroComplex, ThirdBasisConcentration, SharpBaseLaw, ContainerReducesToListSize, U2FieldSizeFeasible, GenericOddCubicTransfer, DeterminantDodgesHeight, DomainUniformFiveCliqueFourCollinear, AbstractNoEightSignatureCap, MomentsDetermineWindow, LadderRecursion.
- PH : WrPositiveAtSaddle, BadPrimeSetFinite, KelleyGeneralPositionConjecture, GenericFoldRegroupProp, GenericBlockDegreeProp, GenericDescentInductionProp ; AnomalyExponentZeroAt (linarith).
- D/S : DefectCountLinear, CrossParityLeakBound, ZeroWeightCompositionSum, DiagonalOrbitCountConstantOne, PairMultiplicity*/PrimitiveFourBound*, NoThreePairSupports, OrbitCountW4Surjective, OrbitClassifyFromAntipodal, MomentRatioPeakAtTwo, PairSumConcentration5, HDPairCollapse, HDCosetTripleCollapse, MinorImageLeBudget, EvenDirectionIncidenceCollapse, CountingDictionary, TwoTermNotBetterThanMonomial, AntipodalOnlyRelations, FullDFTFlat, FourthMomentBound, TripleLinearHasse, FiniteFreeEdgeBound, SpreadExcessLaw, A33ConstantRatioLaw, Depth3NormCertified, BalancedCount8, PoleOrderOne/LeTwo/PoleStructureGrowthLaw, UnionCountBadStacks, WeakestSuffCount, BCHKSCount, MaximalTailCountBound, OrbitCountWall, RealizedRelationCountBound, SpurWitnessCountBounded, WorstOverdetEdgeIncidenceClosedForm, ParsevalCensusResultantBound (plausiblement faux mais lourd).
- Faux dégénérés (ne comptent pas) : JohnsonFloorTwoPower (champ libre minSupport), BruteForce Hyp1–10 (liste libre).

## PR ouvertes (gh, lecture seule)
#420–#427 : refactor/probes/build ; aucune ne prouve ces Props.
