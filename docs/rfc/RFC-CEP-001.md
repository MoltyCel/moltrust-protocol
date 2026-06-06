# RFC-CEP-001 — Combined Enforcement Protocol: Governance Transition for Agent Trust Infrastructure

**Status:** Request for Comments · Draft
**Author:** MolTrust / CryptoKRI GmbH
**Date:** June 2026
**Reference:** MolTrust Protocol TechSpec v0.9, §17 (anchored Base L2, Block 46,986,137)
**Discussion:** [open an issue / reply on this thread]

---

## Summary

MolTrust's AAE enforcement layer is implemented and running in **advisory** mode: it verifies Agent Authorization Envelopes, evaluates proposed actions against them, and produces signed, auditable verdicts. It does not yet **block** actions.

Turning on active blocking (the *enforce* mode) raises one question: **who is authorized to flip that switch?** Tying it to a person, a single chain, or a single instance reintroduces exactly the single point of failure that a trust infrastructure is supposed to remove — over a 10-year horizon, none of those survive.

The Combined Enforcement Protocol (CEP) is our **designed** answer: the authority to activate enforcement is bound to **objective, publicly recomputable conditions**, not to any operator. This RFC presents the design and asks for two things: critique, and early relying parties willing to participate in a testnet demonstration.

CEP is **designed, not activated**. This document does not claim live decentralized governance. It presents a solved design problem and invites participation.

---

## The problem

A trust infrastructure that *blocks* agent actions holds real power. Whoever controls the enforce switch controls the network. The honest options for "who controls it" are all bad:

- **A founder / operator** — does not survive a 10-year horizon; a single key is a single point of failure and capture.
- **A single chain** — can disappear, censor, or fork.
- **A single instance** — can be shut down or compromised.

CEP removes the operator from the loop and replaces it with conditions that **anyone can verify**.

---

## The design (overview)

The full normative description is in TechSpec v0.9 §17.2. In brief:

**1. A five-condition ramp (AND).** Enforcement activates only when five conditions hold *simultaneously*: a minimum elapsed time; a minimum number of Sybil-qualified relying parties; distribution over a minimum number of independent clusters; no single actor above a voting-weight cap; and no single cluster above a share cap. A single threshold is gameable — the conjunction is not.

**2. Verification > production (honest-verifier data availability).** The condition data is published to permanent, decentralized storage and anchored as a `(merkle_root, data_uri)` tuple across multiple chains. The activation trigger is a deterministic function **anyone can recompute** from the published data. There is no privileged measuring party — it does not matter whether the data producer is honest, as long as the data is public and at least one honest verifier can recompute and object.

**3. Keyed commitment + cryptographic erasure (data protection).** Relying-party identifiers are never anchored in clear — only keyed commitments. Deletion destroys the key; the anchored commitment then becomes non-attributable. This reconciles permanent integrity proofs with the right to erasure.

**4. Staged verification.** A permissioned ramp-up phase (verifiers bound by data-processing agreements) precedes a target phase of zero-knowledge verification that proves the recomputation **without disclosing** the underlying data.

**5. Cluster diversity, not vertical labels.** "Diversity" is measured as independent clusters in the endorsement graph (reciprocal Jaccard analysis), not by self-declared categories. Diversity is *proven from structure*, not declared.

**6. Scope position.** MolTrust is a verification/enforcement **protocol layer**, not the deployer of a high-risk AI system (cf. TLS/PKI: a certificate authority issues and lets parties verify; it does not supervise each use). The duty of human oversight over a high-risk deployment rests with the **relying party** that uses the protocol to gate its agents. The protocol is oversight-**enabling** (verifiable verdicts, default-DENY, audit trail, public veto), not oversight-replacing.

---

## Parameters

Thresholds differ by network. Testnet values demonstrate the mechanism; mainnet values are the production target. They are not interchangeable.

| Parameter | Testnet (demonstration) | Mainnet (target) |
|---|---|---|
| N — Sybil-qualified relying parties | 11 | 101 |
| K — independent clusters | 3 | 4 |
| Y — max share per cluster | ≥ 34 % | 33 % |
| X — max voting weight per actor | 10 % | 10 % |
| T — timelock / public-veto window | 31 days | 31 days |

For comparison, these caps are stricter and more decentralized than typical DAO governance (concentration caps, timelock duration, Nakamoto coefficient).

---

## What we are asking for

**1. Critique.** Where does the design break? We are specifically interested in: data-availability liveness, the economics of verification (verifier's dilemma), cluster-diversity gaming, and the permissioned→ZK transition.

**2. Early relying parties for a testnet demonstration.** We want a small number of **independent** parties — independent in the graph sense, i.e. not mutually endorsing — to participate as relying parties in a testnet run. Diverse origin is the point: parties from different platforms and different application areas naturally fall into different clusters.

If you operate agents and would consume trust verdicts to gate them, or you run a platform that would benefit from verifiable agent authorization, you are a candidate relying party.

---

## What this is not

- It is **not** a claim that MolTrust enforces today (the layer is advisory).
- It is **not** a claim that decentralized governance is active (CEP is designed, gated).
- It is **not** a governance token or a fundraising instrument.

It is a design, anchored and specified, put forward for comment and early participation.

---

## References

- MolTrust Protocol TechSpec v0.9, §17 — Enforcement Layer & Governance Transition. Anchored Base L2, Block 46,986,137. https://moltrust.ch/MolTrust_Protocol_TechSpec_v0.9.pdf
- Integrity / verification: https://moltrust.ch/publications/integrity.html#techspec-v0-9

---

**To respond:** open an issue or reply on the discussion thread. To express interest as a testnet relying party, include the kind of agents/platform you operate.
