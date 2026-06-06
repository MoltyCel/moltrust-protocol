<!--
DRAFT — TechSpec v0.9 additive chapter "Enforcement Layer & Governance Transition"
Stage 1 (roadmap-level, NOT an implementation reference).

STATUS: SOURCE DRAFT FOR LARS REVIEW. NOT yet spliced into TECH_SPEC.md. NO rebuild, NO anchor,
NO deploy. The anchor step is irreversible — it happens only after Lars signs off, as a separate step.

== PLACEMENT NOTE (decision needed from Lars) ==
The original instruction was "dock after §6 On-Chain Anchoring". SCHRITT-0 recon found that
enforcement + governance material ALREADY EXISTS in the spec:
  - §9 "Infrastructure-Layer Enforcement" (Falco/eBPF kernel layer, SAS, MoltGraph — RUNTIME level)
  - §10 "Governance Layer" (4-layer classification, VerifiedGovernanceCredential "Planned Q3 2026", aps.txt)
This new chapter is the AAE MANDATE-enforcement pipeline (D-1 acceptance-gate / evaluator / store) +
the CEP governance-transition model — COMPLEMENTARY to §9/§10, not a replacement.

Inserting after §6 (as a new §7) would force a full renumber of §7–§16 + TOC + cross-refs, and would
split "enforcement" across §7 and §9. RECOMMENDATION: append as the LAST numbered chapter
(new §17, before References) = purely additive, zero renumber, no cross-ref breakage. The chapter
cross-references §6 (anchoring), §9 (runtime enforcement) and §10 (governance layer) so there is no
duplication/contradiction. Chapter number below is written as "17" per this recommendation — change
on splice if Lars prefers a different slot.

== VERSION / BUILD NOTE (for the SEPARATE build step, after review) ==
  - Bump header: TECH_SPEC.md line 2  "## Version 0.8.1 — Draft for Review" → "## Version 0.9 — Draft for Review"
  - Add the "v0.9 additions" note near line 10 (analogous to the existing v0.8.1 line).
  - Add a TOC entry (manual TOC, ~line 80): "17. Enforcement Layer & Governance Transition" + sub-bullets.
  - Build: TECH_SPEC_VERSION=0.9 LC_ALL=en_US.UTF-8 ./scripts/build_pdfs.sh tech_spec
    (LC_ALL is MANDATORY — build_pdfs.sh line 24 uses `date +'%B %Y'`; without en_US it leaks a German
     month name e.g. "Juni" into the PDF date metadata.)
  - THEN anchor (irreversible) + deploy to /var/www/html — only after Lars sign-off.

== WORDING DISCIPLINE (enforced in this draft) ==
  NOT used: "MolTrust enforces", "decentralized governance is active", "live enforcement".
  Used: "enforcement layer implemented (advisory)", "CEP governance is designed; activation is a
  roadmap step", "the mechanism is demonstrable on testnet". This chapter presents a SOLVED DESIGN,
  it does not claim a live enforcement feature.
=================================================================================================
-->

## 17. Enforcement Layer & Governance Transition

This chapter describes (Part A) the AAE constraint-enforcement layer as **currently implemented in advisory mode**, and (Part B) the **designed** governance model that would authorize a transition to active enforcement. It is a roadmap-level overview: it states *what* the layer does and *what status* it has, not implementation internals.

Relationship to earlier chapters: this layer consumes the on-chain anchors of Section 6, sits alongside the runtime/kernel enforcement of Section 9 (Infrastructure-Layer Enforcement), and operates within the Governance Layer of Section 10. Section 9 enforces at the syscall/runtime boundary (Falco/eBPF, SAS); this chapter enforces at the **credential/MANDATE boundary** (does a verified Agent Authorization Envelope permit a proposed action). The two are complementary.

---

### 17.1 Part A — Enforcement Layer (implemented, advisory)

The AAE enforcement layer is **implemented and running in advisory mode**: it verifies authorization envelopes, evaluates proposed actions against them, and produces signed, auditable verdicts. In advisory mode a DENY verdict is **verified and recorded but not enforced** — the action is not blocked. Active blocking (the *enforce* mode) is a roadmap step gated on the governance transition of Part B (see §17.2.4).

The layer has three components.

#### 17.1.1 Acceptance Gate (AAE verification at submit time)

Before an envelope is stored or evaluated, it is verified as a compact JWS (per the AAE schema, Section 2.8) — **fail-closed**:

- **Signature & signing-authority:** the envelope's signature is verified against the issuer's key, with an explicit `EdDSA`-only algorithm allow-list (no algorithm downgrade), and the signing DID MUST equal the credential issuer.
- **Schema:** the payload MUST carry a well-formed MANDATE / CONSTRAINTS / VALIDITY structure.
- **DID methods:** `did:moltrust` resolves against the reference registry (Section 5); `did:web` resolution is supported through an egress-controlled resolver.
- **Canonicalization:** verification binds to the exact signed bytes; the parsed structure is used only for schema checks.

An envelope that fails any check is rejected (not stored). A **default-DENY** rule governs evaluation: a required constraint that cannot be evaluated yields DENY, never a silent pass.

#### 17.1.2 Evaluator (action evaluation, advisory)

The evaluator decides whether a proposed action is permitted by a verified envelope, evaluating the three AAE blocks:

- **MANDATE** — is the action within the granted scope;
- **CONSTRAINTS** — per-type checks (e.g. maximum transaction value, allowed domains, rate limits, single-use, validity window);
- **VALIDITY** — temporal validity (not-before / not-after, with clock-skew tolerance).

Each decision is recorded as a **signed verdict** (Ed25519, domain-separated, externally verifiable against the registry key) and, on DENY, an associated immutable violation record. Value-bearing constraints distinguish a **rail-verified** value from a merely client-asserted one; a client-asserted value on a required constraint yields DENY.

**Mode:** the evaluator runs in **ADVISORY** mode. Violations are verified and logged (signed verdict + violation record, anchorable per Section 6); they are **not blocked**. The mandatory-chokepoint *enforce* mode — where a DENY prevents the action — is **Component 3 on the roadmap** and is gated per §17.2.4.

#### 17.1.3 Envelope Store

Accepted envelopes are persisted in an append-only store with:

- a **content-hash primary key** (the key is the hash of the canonical signed bytes — content and identifier cannot diverge);
- a **single-use / replay guard** (a single-use envelope cannot be consumed twice for the same scope);
- **immutability** (no update or delete of a stored envelope; corrections are new envelopes).

This makes the evidence trail tamper-evident and consistent with the on-chain anchoring of Section 6.

---

### 17.2 Part B — Governance Transition (CEP, designed; not activated)

Part A runs in advisory mode today. Turning on active enforcement requires deciding **who is authorized** to flip the *enforce* switch. The Combined Enforcement Protocol (CEP) is the **designed** model for that authority. **CEP is not activated.** This section is a roadmap-level summary; the full design lives in the MolTrust ADR *CEP Governance* and the *CEP-3 Threshold Specification* (internal, accepted as design).

#### 17.2.1 Problem

The authority to activate enforcement must not depend on a **person** (a founder does not survive a 10-year horizon), a **single chain** (it can disappear, censor, or fork), or a **single instance** (it can be shut down or compromised). CEP replaces such anchors with **objective, publicly recomputable conditions**.

#### 17.2.2 Core concepts (overview)

- **5-condition ramp (AND).** The transition occurs only when five conditions hold *simultaneously*: a minimum elapsed time; a minimum number of Sybil-qualified relying parties; distribution over a minimum number of independent clusters; no single actor above a voting-weight cap; and no single cluster above a share cap. A single threshold is manipulable — the AND-conjunction is not.
- **Honest-verifier data availability ("verification > production").** The condition data is published to decentralized, permanent storage and anchored as a `(merkle_root, data_uri)` tuple across multiple chains. The transition trigger is a **deterministic function anyone can recompute** from the published data — there is no privileged measuring party.
- **Keyed commitment + cryptographic erasure (data protection).** Relying-party identifiers are never anchored in clear; only keyed commitments are. Deletion destroys the key (cryptographic erasure), after which the anchored commitment is non-attributable — reconciling permanent integrity proofs with the right to erasure.
- **Staged verification.** A permissioned ramp-up phase (verifiers bound by data-processing agreements) precedes a target phase of zero-knowledge verification that proves the recomputation **without disclosing** the underlying data.
- **Scope position.** MolTrust is a **verification / enforcement protocol layer, not the deployer** of a high-risk AI system (cf. TLS/PKI: a certificate authority issues and lets parties verify; it does not supervise each use). The duty of human oversight over a high-risk *deployment* rests with the **relying party** that uses the protocol to gate its agents. The protocol is oversight-**enabling** (verifiable verdicts, default-DENY, audit trail, public veto), not oversight-replacing.

#### 17.2.3 Testnet vs. Mainnet parameters (explicit)

The transition thresholds differ by network. Testnet values exist to **demonstrate the mechanism**; mainnet values are the **production target**. They are not interchangeable.

| Parameter | Testnet (demonstration) | Mainnet (target) |
|---|---|---|
| N — Sybil-qualified relying parties | 11 | 101 |
| K — independent clusters | 3 | 4 |
| Y — max share per cluster | ≥ 34 % | 33 % |
| X — max voting weight per actor | 10 % | 10 % |
| T — timelock / public-veto window | 31 days | 31 days |

Rationale for the K difference: with the byzantine-tolerance relation N ≥ 3f + 1, **K = 4 (mainnet)** tolerates one captured/faulty cluster (f = 1) — true fault-tolerance hardening. **K = 3 (testnet)** corresponds to f = 0: it demonstrates the cluster-diversity mechanism end-to-end without claiming production-grade tolerance. The invariant **Y ≥ 1/K** is preserved in both rows (testnet K = 3 → Y ≥ 34 % > 33.3 %; mainnet K = 4 → Y = 33 % ≥ 25 %), so neither configuration is structurally unsatisfiable.

The mechanism is therefore **demonstrable on testnet** while the mainnet configuration remains the (not-yet-activated) target.

#### 17.2.4 Activation gates

Active *enforce* mode (Part A becoming blocking) is gated on two independent conditions, both of which must be met before any enforcement code is activated:

- **Gate-1 — thresholds fixed and anchored.** The parameters above are written down and chain-agnostically anchored before the ramp-up starts. *Status: the values are **fixed** (CEP-3 threshold specification); chain-agnostic anchoring is pending the multi-chain prerequisite below.*
- **Gate-2 — prerequisites built.** A relying-party registry with cryptographic (DID-bound) identity and cluster attribution; an explicit *enforce* state in the authorization model; and multi-chain anchoring. *Status: open.*

Until both gates are met, the evaluator remains in **advisory** mode (Part A): verified, recorded, **not blocked**. Activation is a deliberate, separate step, not a side effect of publishing this specification.

---

### 17.3 Summary of status

| Element | Status |
|---|---|
| AAE acceptance gate (verify at submit) | Implemented |
| Evaluator (MANDATE/CONSTRAINTS/VALIDITY, signed verdicts) | Implemented — **advisory** |
| Envelope store (content-hash PK, replay guard, immutable) | Implemented |
| Active *enforce* mode (blocking) | Roadmap (gated, §17.2.4) |
| CEP governance transition | **Designed**, not activated |
| Mechanism on testnet | Demonstrable |

This chapter adds no normative conformance requirement to Section 16; it documents an implemented advisory layer and a designed governance transition. Conformance for active enforcement will be specified when the activation gates (§17.2.4) are met.
