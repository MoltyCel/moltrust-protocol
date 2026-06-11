# arXiv v2 — Structure Skeleton (These-b spine)

**Status:** SKELETON for Lars review. Titles + purpose (2–3 sentences) + material source per section. **No full text.**
**Format:** LaTeX/pdfTeX (v1.9 toolchain). **Replacement** under arXiv:2605.06738, categories `cs.CR` (primary) + `cs.AI` + `cs.MA`.
**Restructure principle:** *re-weight* v1.9, do not rewrite from zero. These (b) governance-transition becomes the spine; These (a) runtime-enforcement + deployment empiricism become supporting evidence. Keep v1.9 strengths (Related Work western anchors, Sybil, empiricism) — re-weighted, not deleted.

**Material-source legend:** `[v1.9 §X]` = from the canonical published PDF · `[§17]` = TECH_SPEC v0.9 §17 (anchored Base L2 block 46,986,137 — **citable primary source**; summarize + reference, do **not** re-derive the design) · `[ADR #143]` = ADR-CEP-governance ACCEPTED · `[#145]` = CEP-3 threshold spec · `[NEW]` = newly written.

---

## Title — SUPERSEDED by the optional-convention reframe (2026-06-11); Lars to choose

> The 2026-06-10 title "Enforcement Without an Operator — A Governance Transition…" is **withdrawn**:
> the reframe makes CEP an **optional, advisory trust convention**, so a title promising *enforcement*
> over-claims. Three governance-/convention-centred options (Lars chooses); working compile title = #1:
> 1. **"An Optional Trust Convention for Autonomous Agents — Recomputable Maturity Without a Central Authority"**
> 2. **"Convention over Coercion — A Voluntary, Operator-Independent Trust Layer for Autonomous-Agent Authorization"**
> 3. **"Advisory Trust Governance for Autonomous Agents — When Is a Network-Wide Convention Ready?"**
> Subtitle line (kept): *Empirical Evidence from a W3C VC + DID Trust Infrastructure.*

*(Withdrawn 2026-06-10 final: "Enforcement Without an Operator — A Governance Transition for Autonomous-Agent Trust.")*

> Title describes the **contribution** (the designed CEP model), not today's status. The text holds
> "designed, not activated / advisory" throughout — title and status-wording must not diverge.
> Abstract + §1 clarify early that "without an operator" is the model's *property-goal*; live status = advisory.

*(Candidates considered: "Who Authorizes Enforcement?…", "From Advisory to Enforced Without an Anchor…",
"Decentralizing Enforcement Authority…" — final is a combination of main line + subtitle.)*

## Locked decisions (Lars, 2026-06-10)
1. Title = above.
2. §7.4 Cross-protocol interoperability → **folded into §8 Discussion** (no standalone section).
3. Full-text order = **spine first** (§4 → §5 → §6), then §1–§3, then §7–§9. **STOP after the spine for review.**

---

## Abstract `[v1.9 abstract reframed + NEW]`
Open with the same scale hook (69k bots / 165M tx / $50M — already in v1.9 abstract). Then pivot the thesis: an enforcement layer that *blocks* agent actions holds real power, and the unanswered question is **who is authorized to activate it** without binding that authority to a person, a chain, or an instance. State the contribution: CEP, a conditions-based, publicly-recomputable governance transition; the substrate is deployed and runs in **advisory** mode today. Honest framing words throughout: designed / advisory / demonstrable.

## 1 — Introduction `[v1.9 §1 reframed]`
Reframe the v1.9 intro around the governance question, not the deployment story. Establish the gap: trust infrastructures remove single points of failure for *verification*, but the *enforce-authority* recreates one. State the open problem precisely and list the contributions (CEP design; oracle-problem resolution; deployed advisory substrate as evidence). Material: v1.9 §1 + the problem statement from `[§17 §17.2.1]`.

## 2 — Related Work and Positioning `[v1.9 §2 kept + EXTENDED]`
Keep v1.9's western institutional + academic anchors (NIST AI RMF / CAISI, EU AI Act, Singapore IMDA; Mao SoK **with** the Ferrag western parallel already present). **Add** the v1-weakness fills required by the roadmap: DAO / on-chain governance (concentration caps, timelock, Nakamoto coefficient), the **optimistic-rollup security model** (verification-not-production lineage for §5.2), and Sybil-resistance literature (SybilGuard/SybilLimit/BrightID, Gitcoin) as the lineage for §5.5. Citation rule: western anchors mandatory, never an exclusively non-western source base.

## 3 — Background: An Advisory Trust-and-Enforcement Substrate `[v1.9 §3.1–3.4 CONDENSED]`
Condense v1.9's architecture into just enough to ground the spine: the four primitives, the AAE (mandate/constraints/validity), the five-party chain, and the three-layer enforcement architecture **running in advisory mode** (verified + recorded, not blocking). This section is supporting These (a) — short, factual, sets up "the substrate exists; the open question is who turns it from advisory to enforced." Material: v1.9 §3.1, §3.3, §3.4 (condensed) + `[§17 §17.1]` for the advisory-status framing.

## 4 — The Governance-Transition Problem `[NEW framing + v1.9 §3.5 promoted]`
Promote what was v1.9's sub-subsection §3.5 ("Governance Boundaries and Decentralization Roadmap") to a first-class problem statement. Why operator / single-chain / single-instance anchors all fail over a 10-year horizon. **State the oracle problem here explicitly** (who measures whether the activation conditions are met, without becoming a new trusted party) — this is the hard problem the spine resolves, named up front, not skirted. Material: `[§17 §17.2.1]` + `[ADR #143]` (problem framing) + v1.9 §3.5.

## 5 — The Combined Enforcement Protocol (CEP) `[§17 §17.2 PRIMARY + #143 + #145]` — CORE CONTRIBUTION
The spine. Summarize the **anchored, citable** design from §17.2; reference block 46,986,137 as the source of record; do not re-derive.
- **5.1 Five-condition ramp (AND).** Activation only when five conditions hold simultaneously (time, N Sybil-qualified RPs, K independent clusters, X per-actor cap, Y per-cluster cap). A conjunction is not gameable the way a single threshold is. `[§17 §17.2.x, #145]`
- **5.2 Honest-verifier data availability — resolving the oracle problem (Verification > Production).** The condition data is published to permanent storage and anchored as `(merkle_root, data_uri)` across chains; the trigger is a deterministic function **anyone can recompute**. No privileged measurer. This is the direct answer to §4's oracle problem. Lineage: optimistic-rollup security model (cited in §2). `[§17 §17.2.x]`
- **5.3 Keyed commitment + cryptographic erasure.** RP identifiers are never anchored in clear; deletion destroys the key, leaving a non-attributable commitment — permanent integrity proofs reconciled with the right to erasure. `[§17 §17.2.x, #145]`
- **5.4 Staged verification (permissioned → ZK).** A permissioned, DPA-bound ramp-up precedes a ZK target phase that proves recomputation without disclosing the data. Note: ZK here is for the *verification* layer, not governance authority. `[§17 §17.2.x]`
- **5.5 Cluster diversity from structure, not declared categories.** Diversity = K independent clusters via reciprocal-Jaccard analysis of the endorsement graph (the same machinery as Sybil detection, §7.3), not self-declared verticals. Proven from structure. `[§17 + #145 + v1.9 §6.2 Jaccard]`
- **5.6 Parameters.** Table — **Mainnet N=101 / K=4 / Y=33% / X=10% / T=31d; Testnet N=11 / K=3 / Y≥34% / X=10% / T=31d.** Note Y≥1/K invariant (testnet K=3→Y≥34%). Stricter than typical DAO governance (tie back to §2 anchors). `[#145, §17 §17.2.3]`

## 6 — Scope and Honest Limits `[v1.9 §7.1–7.2 reframed + §17 scope + ADR Konflikt-2]`
The honesty section the roadmap mandates.
- **6.1 Protocol layer, not deployer.** TLS/PKI analogy: a CA issues + lets parties verify; it does not supervise each use. Human-oversight duty (incl. EU AI Act Art. 14) sits with the **relying party**; the protocol is oversight-*enabling* (verifiable verdicts, default-DENY, audit trail, public veto), not oversight-replacing. `[§17 §17.2 scope, ADR #143 Konflikt-2]`
- **6.2 Designed, not activated — and what "demonstrable" means.** De-escalate v1.9's "Claim A" / any "provably" language: enforcement is **advisory** today; CEP is **designed** and **gated**, not live; the mechanism is **demonstrable on testnet**. No "we enforce" / "decentralized governance is active" / "provably secure". `[v1.9 §7.1, §7.2 reframed]`
- **6.3 Open problems (named, not hidden).** Treasury governance (the funding/management anchor), the ZK phase, weak subjectivity for late-joining verifiers. `[§17 + ADR #143 CEP-5]`

## 7 — Deployment Evidence (supporting These a) `[v1.9 §4 + §6 re-weighted]`
The deployment empiricism, now positioned as **evidence the substrate is real**, not the main argument.
- **7.1 Live deployment + advisory enforcement running.** `[v1.9 §4.1]`
- **7.2 Empirical scale + conformance.** Scale numbers; AIP/IBCT conformance stated **honestly as "4/5 + 1 open item"** (expressive chained policy = open item; URI-pattern lower bound implemented, multi-condition/Datalog-class not) — **NOT 5/5**. `[v1.9 §4.2 CORRECTED, conformance doc]`
- **7.3 Sybil resistance & behavioral consistency.** Keep the v1.9 strength; explicitly connect it to §5.5 (the same Jaccard/cluster machinery underpins the CEP diversity condition). `[v1.9 §6.1–6.6]`
- **7.4 Cross-protocol interoperability** (brief, from v1.9 §5) — optional, condense or fold into 7.1.

## 8 — Discussion `[v1.9 §7.3–7.4 + §17 open items]`
Positioning against adjacent work (DAO governance, agent-identity efforts, AIP/IBCT); what CEP adds that they lack (operator-independent activation authority). Future work = the §6.3 open problems on a roadmap. Keep honest, non-defensive.

## 9 — Conclusion `[v1.9 §8 reframed]`
Restate the contribution as a *solved design problem* + a deployed advisory substrate + an invitation (mirror the RFC-CEP-001 ask: critique + testnet relying parties). Not a claim of live governance.

---

## Pflicht-element coverage (roadmap §3) — checklist for the skeleton
- [x] Oracle problem addressed directly → §4 (stated) + **§5.2** (resolved, prominent in spine)
- [x] Scope-position (protocol-not-deployer, TLS/PKI) → §6.1
- [x] "Claim A" / "provably" de-escalation → §6.2
- [x] CEP from §17 (5-AND, keyed commitment + crypto erasure, staged verification, cluster-diversity) → §5
- [x] AIP conformance "4/5 + 1 open item" (not 5/5) → §7.2
- [x] Testnet/Mainnet parameters correct (101/4/33/10/31 vs 11/3/≥34/10/31) → §5.6
- [x] Related Work extended (DAO, optimistic-rollup, Sybil-lit, western anchors) → §2
- [x] New governance-centered title → 3 options above

## What changes vs v1.9 (one-line summary)
v1.9 spine = "we deployed it" (These a). v2 spine = "here is how enforcement authority decentralizes without an anchor" (These b); §3.5 grows into §4+§5; §3+§4+§6 become supporting evidence; §2 extended; honesty (§6) and the corrected conformance (§7.2) folded in.

## Cross-cutting / Review-Gauntlet note (roadmap §4)
Reviews assess the **paper** (description accuracy vs anchored §17, argument, citations, honest scope). They do **not** re-open the CEP *design* — that is ACCEPTED (#143), settled. Design re-litigation in a review → out of scope, reject.
