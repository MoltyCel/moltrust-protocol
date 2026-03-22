# The MolTrust Protocol: Technical Specification
## Version 0.2.2 — Draft for Review

**MolTrust / CryptoKRI GmbH, Zurich**
**March 2026**
**Status: Informational Draft**

This document is a companion to *The MolTrust Protocol: A Verification Standard for Autonomous Software Agents* (Whitepaper v0.4). It provides the technical definitions, data models, verification flows, and conformance requirements referenced in that document.

---

## Architectural Overview

This specification is organized around three distinct layers. Readers and implementers should be clear about which layer they are working with, as conformance requirements differ across layers.

**Layer A — Protocol Standard**
The normative core. Defines data formats, signing rules, verification flows, and lifecycle semantics. Any independent implementation that conforms to Layer A can interoperate with any other conformant implementation at the evidence level.

**Layer B — Reference Registry**
The MolTrust-operated service layer. Defines how the reference implementation exposes identity resolution, credential revocation, trust score queries, and on-chain anchoring. Conformance to Layer B is required to interoperate with the MolTrust reference API. Other operators MAY run conformant registries using different infrastructure.

**Layer C — Reference Reputation Model**
An informative scoring model used by the MolTrust reference registry. Other implementations MAY use different scoring models provided they consume Layer A evidence formats. Score portability across implementations with different models is a format guarantee, not a semantic guarantee.

This distinction resolves the central design tension in any open-standard-plus-canonical-service architecture: the protocol is genuinely open at Layer A; the reference service has operator-specific policy at Layer B; the scoring model is reproducible but not mandatory at Layer C.

---

## Table of Contents

1. Scope and Terminology
2. Data Model (Layer A)
3. Verification Flow (Layer A)
4. Reference Reputation Model (Layer C — Informative)
5. Reference Registry (Layer B)
6. On-Chain Anchoring (Layer B)
7. Credential Lifecycle (Layer A)
8. Agent Lifecycle (Layer A)
9. Threat Model
10. Privacy Model
11. Worked Example
12. Conformance

---

## 1. Scope and Terminology

### 1.1 Scope

This specification defines:

- The data formats for agent identity documents, verifiable credentials, interaction proofs, endorsements, and violation records (Layer A)
- The verification procedures for identity, authorization, and behavioral history (Layer A)
- The lifecycle rules for credentials and agents (Layer A)
- The reference trust scoring model (Layer C — informative)
- The reference registry API and policy (Layer B)
- On-chain anchoring formats and requirements (Layer B)
- A threat model for the verification system
- Privacy principles and data minimization requirements
- Conformance requirements differentiated by layer

This specification does not define:

- What agents are permitted to do
- How disputes between agents are adjudicated
- The legal validity of any credential or interaction proof
- Which blockchain network must be used for anchoring
- How agents are built or operated internally

### 1.2 Terminology

The key words **MUST**, **MUST NOT**, **SHOULD**, **SHOULD NOT**, and **MAY** in this document are to be interpreted as described in RFC 2119.

**Agent** — an autonomous software process that acts on behalf of a principal.

**Principal** — the human, organization, or other agent on whose behalf an agent acts. A principal MUST have a stable DID that persists across agent registrations.

**DID** — Decentralized Identifier, as specified in W3C DID Core v1.0.

**DID Document** — the document associated with a DID, containing public keys and service endpoints.

**Verifiable Credential (VC)** — a tamper-evident claim about a subject, as specified in W3C VC Data Model 2.0.

**Interaction Proof** — a signed artifact produced after an interaction between two agents, attesting to the fact and outcome of that interaction.

**Trust Score** — a numeric value in [0, 100] derived from an agent's behavioral record and endorsement graph, computed by a registry using a defined scoring model.

**Endorsement** — a signed attestation by one agent that another agent has behaved reliably in a defined vertical.

**Vertical** — a domain of agent activity, expressed as a namespaced string of the form `<namespace>/<identifier>` (see Section 2.5).

**Seed Agent** — an agent registered with a bootstrap weight by a registry operator, used to initialize the endorsement graph. Bootstrap weights are time-limited (see Section 8.2).

**Verifier** — any party that checks a DID, credential, interaction proof, or trust score.

**Issuer** — any party that signs and issues a Verifiable Credential.

**On-chain anchor** — a transaction on a distributed ledger that permanently records a hash of a protocol artifact.

**Registry** — a service that resolves DIDs, maintains revocation lists, computes trust scores, and records interaction proofs. The MolTrust reference registry is one such service.

**Violation Record** — a signed artifact attesting to a confirmed protocol violation by an identified agent (see Section 2.6).

**Protocol conformance** — conformance to Layer A requirements.

**Registry conformance** — conformance to Layer B requirements.

### 1.3 Notation

JSON examples in this document use `<placeholder>` notation for variable values. All JSON objects MUST be serialized using RFC 8785 canonical JSON before signing. Field ordering in examples is illustrative; canonical ordering is determined by RFC 8785.

---

## 2. Data Model (Layer A)

### 2.1 Signed Payload Boundary

For all signed artifacts in this protocol, the following rules apply:

1. The signed payload is the RFC 8785 canonical JSON serialization of the object, **excluding** the `proof` field (or `proofInitiator`/`proofResponder` fields for interaction proofs)
2. Additional fields not defined in this specification MAY be present in objects; they are included in the canonical serialization and therefore covered by the signature
3. Fields MUST NOT be added to a signed object after signing
4. The signing algorithm is Ed25519 as specified in Ed25519Signature2020
5. Signature values are encoded as base58btc multibase strings

This boundary applies to all MolTrust-defined signed artifacts: Authorization Credentials, Interaction Proofs, Endorsements, and Violation Records.

**DID Documents are explicitly excluded from this signing boundary.** DID Document integrity is guaranteed by the DID method's own resolution mechanism (e.g. registry lookup, blockchain anchoring, or HTTPS binding), not by an embedded proof block. Verifiers MUST authenticate DID Documents per the rules of the applicable DID method, not by checking for a `proof` field.

### 2.2 Agent DID Document

Each agent MUST have a DID conforming to W3C DID Core v1.0. Implementations MAY use any conformant DID method. The `did:moltrust` method is defined and operated by the MolTrust reference registry.

**Mandatory fields:**

```json
{
  "@context": [
    "https://www.w3.org/ns/did/v1",
    "https://moltrust.ch/ns/v1"
  ],
  "id": "did:moltrust:<unique-identifier>",
  "verificationMethod": [
    {
      "id": "did:moltrust:<id>#keys-1",
      "type": "Ed25519VerificationKey2020",
      "controller": "did:moltrust:<id>",
      "publicKeyMultibase": "<base58btc-encoded-public-key>"
    }
  ],
  "authentication": ["did:moltrust:<id>#keys-1"],
  "assertionMethod": ["did:moltrust:<id>#keys-1"]
}
```

**Optional fields:**

| Field | Type | Notes |
|---|---|---|
| `service` | array | Service endpoints including registry reference |
| `created` | ISO 8601 | Timestamp of DID creation |
| `updated` | ISO 8601 | Timestamp of last update |
| `controller` | DID string | Principal DID — SHOULD be present for sub-agents |
| `alsoKnownAs` | array | Cross-registry references e.g. ERC-8004 agent ID |
| `keyAgreement` | array | For encrypted communication channels |

**Key rotation:** When rotating keys, the agent MUST add the new key to `verificationMethod` with a new key ID, update `authentication` and `assertionMethod` to reference the new key, and retain the old key entry marked with `"revoked": true` and a `revokedDate`. This preserves a verifiable timeline of key epochs.

### 2.3 Authorization Credential

An agent's authority to act on behalf of a principal MUST be expressed as a W3C Verifiable Credential.

**Mandatory fields:**

```json
{
  "@context": [
    "https://www.w3.org/2018/credentials/v1",
    "https://moltrust.ch/ns/credentials/v1"
  ],
  "type": ["VerifiableCredential", "AuthorizationCredential"],
  "id": "<uuid-v4>",
  "issuer": "did:<method>:<principal-id>",
  "issuanceDate": "2026-03-22T00:00:00Z",
  "expirationDate": "2027-03-22T00:00:00Z",
  "credentialSubject": {
    "id": "did:moltrust:<agent-id>",
    "authorizedBy": "did:<method>:<principal-id>",
    "permittedActions": ["<action-type>"],
    "vertical": "<namespace>/<identifier>",
    "constraints": {}
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "created": "2026-03-22T00:00:00Z",
    "verificationMethod": "did:<method>:<principal-id>#keys-1",
    "proofPurpose": "assertionMethod",
    "proofValue": "<base58btc-signature>"
  }
}
```

**`permittedActions` values:**

| Value | Meaning |
|---|---|
| `transact` | May execute financial transactions |
| `delegate` | May authorize sub-agents |
| `endorse` | May issue endorsements |
| `verify` | May request verification of other agents |
| `publish` | May publish content on behalf of principal |
| `*` | All actions permitted (use with caution) |

Implementations MAY define additional action types using the namespace convention `<namespace>/<action>`.

**Delegation chains:** An agent MAY issue an AuthorizationCredential to a sub-agent. The sub-agent's `permittedActions` MUST be a subset of the delegating agent's own authorized actions. Verifiers MUST traverse the full chain from subject to root principal. Maximum delegation depth: 8 hops. Verifiers MUST reject chains exceeding this depth.

**Constraints:** The `constraints` field is a free-form JSON object for policy-specific restrictions (e.g. `{"maxTransactionValue": 5000}`). Constraint semantics are application-defined and not normatively specified in this document.

### 2.4 Interaction Proof

An Interaction Proof is the primary evidence artifact. It is produced after an interaction that both parties wish to record.

**Mandatory fields:**

```json
{
  "@context": "https://moltrust.ch/ns/interaction/v1",
  "type": "InteractionProof",
  "id": "<uuid-v4>",
  "session": "<session-id>",
  "initiator": {
    "did": "did:moltrust:<initiator-id>",
    "vertical": "<namespace>/<identifier>"
  },
  "responder": {
    "did": "did:moltrust:<responder-id>",
    "vertical": "<namespace>/<identifier>"
  },
  "timestamp": "2026-03-22T10:00:00Z",
  "outcome": "<outcome-value>",
  "outcomeHash": "sha256:<hex-hash>",
  "proofInitiator": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:<initiator-id>#keys-1",
    "proofValue": "<base58btc-signature>"
  },
  "proofResponder": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:<responder-id>#keys-1",
    "proofValue": "<base58btc-signature>"
  }
}
```

**Field semantics:**

| Field | Semantics |
|---|---|
| `id` | Globally unique identifier (UUID v4). Duplicate IDs MUST be rejected by registries. |
| `session` | Application-defined session identifier. Multiple proofs MAY reference the same session (e.g. multi-step interactions). Session IDs are scoped to the initiating agent and are not globally unique. |
| `outcome` | One of: `completed`, `partial`, `disputed`, `failed` |
| `outcomeHash` | SHA-256 of the canonical outcome payload (see below) |

**Outcome hash construction:** The hash input MUST be the RFC 8785 canonical JSON serialization of an outcome object containing at minimum:

```json
{
  "proofId": "<same uuid-v4 as proof id>",
  "timestamp": "<same timestamp as proof>",
  "outcome": "<same outcome value>",
  "summary": "<free-form string, not exceeding 256 characters>"
}
```

The `summary` field MAY contain a human-readable description of the outcome. Raw transaction data, counterparty personal information, and financial amounts MUST NOT be included in the hashed payload. The full outcome object MAY be retained locally by the parties; only the hash is submitted to the registry.

**Signing procedure (sequential — not parallel):**

1. Initiator constructs the proof object with all mandatory fields, leaving `proofResponder` absent
2. Initiator computes the RFC 8785 canonical serialization of the object without `proofResponder`
3. Initiator signs the canonical bytes with Ed25519 and adds `proofInitiator`
4. Initiator transmits the partially-signed object to the responder
5. Responder verifies `proofInitiator` against the initiator's DID Document
6. Responder computes the RFC 8785 canonical serialization of the full object **including `proofInitiator`** but excluding `proofResponder`
7. Responder signs these canonical bytes — which now cover the initiator's signature — and adds `proofResponder`
8. Either party MAY submit the completed proof to a registry

**Critical:** The responder's signature in step 7 covers the initiator's signature from step 3. This is sequential, not parallel. Independent implementations MUST follow this exact order or the signatures will be incompatible. A parallel signing scheme (both parties signing the same "naked" payload) is not conformant.

**One-sided proofs:** If the responder is unavailable or refuses to sign within a reasonable timeout (application-defined, SHOULD be at least 300 seconds), the initiator MAY submit the proof with `"singleSig": true` and `proofResponder` absent. One-sided proofs are valid Layer A artifacts but carry reduced weight in Layer C scoring.

**Multi-agent interactions:** Interactions involving more than two agents SHOULD be modeled as multiple bilateral proofs sharing the same `session` identifier. There is no native multi-party proof format in v0.2.

### 2.5 Vertical Identifiers

Verticals are expressed as namespaced strings of the form `<namespace>/<identifier>`.

**Format rules:**
- Namespace and identifier MUST contain only alphanumeric characters, hyphens, and underscores
- Namespace and identifier MUST be separated by exactly one forward slash
- Total length MUST NOT exceed 128 characters
- Case is significant: `moltrust/Travel` and `moltrust/travel` are different verticals

**The `moltrust/` namespace** is reserved for verticals defined and published by MolTrust. Current defined values:

| Value | Domain |
|---|---|
| `moltrust/travel` | Travel booking and logistics |
| `moltrust/commerce` | Agentic commerce and purchasing |
| `moltrust/prediction` | Prediction markets and forecasting |
| `moltrust/skill` | Skill verification and auditing |
| `moltrust/finance` | Financial transactions and DeFi |
| `moltrust/identity` | Identity verification services |
| `moltrust/general` | General-purpose, cross-domain |

Any party MAY define verticals in their own namespace (e.g. `acme/logistics`, `custom/my-domain`). There is no registration requirement. The cross-vertical bonus in the reference scoring model (Section 4) treats verticals with different namespaces OR different identifiers within the same namespace as distinct for diversity calculation purposes.

### 2.6 Endorsement

```json
{
  "@context": "https://moltrust.ch/ns/endorsement/v1",
  "type": "SkillEndorsementCredential",
  "id": "<uuid-v4>",
  "issuer": "did:moltrust:<endorser-id>",
  "issuanceDate": "2026-03-22T00:00:00Z",
  "expirationDate": "2026-06-22T00:00:00Z",
  "credentialSubject": {
    "id": "did:moltrust:<endorsed-id>",
    "vertical": "<namespace>/<identifier>",
    "weight": 1.0,
    "basis": "interaction-proofs",
    "evidenceCount": 5,
    "evidenceSummaryHash": "<sha256-of-supporting-proof-ids>"
  },
  "proof": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:<endorser-id>#keys-1",
    "proofValue": "<base58btc-signature>"
  }
}
```

**Endorsement rules:**

- Maximum validity: 365 days. Default SHOULD be 90 days.
- An endorser MUST NOT issue more than one active endorsement per (endorsed DID, vertical) pair. A new endorsement in the same vertical supersedes the previous one.
- The `basis` field MUST be one of: `interaction-proofs` (endorsed based on observed interaction proofs), `delegation` (parent agent endorsing sub-agent), `operator` (registry operator bootstrap endorsement, time-limited).
- The `evidenceSummaryHash` is a SHA-256 hash of the canonical JSON array of interaction proof IDs supporting the endorsement. For `operator` basis endorsements, this field MAY be absent.
- Principals MAY issue endorsements. Seed agents MAY endorse other agents but MUST NOT endorse each other using `operator` basis after the bootstrap period.
- The `weight` field (0.0–1.0) is endorser-declared and represents the endorser's confidence level.

### 2.7 Violation Record

A Violation Record is a signed artifact attesting that a confirmed protocol violation has been recorded against an agent.

```json
{
  "@context": "https://moltrust.ch/ns/violation/v1",
  "type": "ViolationRecord",
  "id": "<uuid-v4>",
  "issuanceDate": "2026-03-22T00:00:00Z",
  "subject": {
    "agentDid": "did:moltrust:<violating-agent-id>",
    "principalDid": "did:<method>:<principal-id>"
  },
  "violation": {
    "type": "<violation-type>",
    "interactionProofId": "<uuid-v4-of-disputed-proof>",
    "description": "<free-form string, max 512 chars>"
  },
  "adjudication": {
    "adjudicatorType": "external",
    "adjudicatorReference": "<URL, case ID, or contract address>",
    "confirmedAt": "2026-03-22T12:00:00Z"
  },
  "registrySignature": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:registry#keys-1",
    "proofValue": "<base58btc-signature>"
  }
}
```

**Violation types:**

| Value | Meaning |
|---|---|
| `identity-spoofing` | Agent misrepresented its identity |
| `authorization-abuse` | Agent acted outside declared permissions |
| `sybil` | Agent participated in a confirmed sybil cluster |
| `behavioral-fraud` | Agent deliberately deceived a counterparty |
| `clone-impersonation` | Clone represented as original agent |

**Recording process:**

1. A party submits a disputed interaction proof (outcome = `disputed`) to the registry
2. The registry records the dispute without adjudicating it
3. External adjudication confirms or rejects the dispute (legal, arbitral, or contractual)
4. On confirmation, the registry records a ViolationRecord signed by the registry operator key
5. The ViolationRecord is permanently associated with both `agentDid` and `principalDid`
6. If stake is held, forfeiture is executed by the registry smart contract

**Appeal and reversal:** If an external adjudicator reverses a decision, the registry MUST record a `ViolationReversal` object and mark the original ViolationRecord as `"reversed": true`. Reversed violation records MUST NOT contribute to score computation.

A ViolationReversal object MUST contain the following fields:

```json
{
  "@context": "https://moltrust.ch/ns/violation/v1",
  "type": "ViolationReversal",
  "id": "<uuid-v4>",
  "reversedRecordId": "<id of original ViolationRecord>",
  "reversalDate": "2026-03-22T15:00:00Z",
  "adjudicatorReference": "<URL, case ID, or contract address>",
  "registrySignature": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:registry#keys-1",
    "proofValue": "<base58btc-signature>"
  }
}
```

The `registrySignature` is computed over the RFC 8785 canonical serialization of the object excluding the `registrySignature` field, using the same registry operator key as ViolationRecord. Registries MUST make ViolationReversal objects queryable by `reversedRecordId`.

---

## 3. Verification Flow (Layer A)

### 3.1 Identity Verification

1. **Resolve** the agent's DID to its DID Document
2. **Validate** that the DID Document is well-formed per Section 2.2
3. **Check** that the DID is not revoked by consulting a valid revocation source. Layer A conformant implementations MUST support revocation checking; the revocation source itself is implementation-defined. Layer B conformant registries provide the reference revocation endpoint (Section 5.3). Verifiers operating without a Layer B registry MUST implement an alternative revocation mechanism (e.g., local revocation list, DID-method-native revocation).
4. **Issue** a challenge: send a random nonce (minimum 128 bits of entropy), encoded as a **lowercase hex string** (32 hex characters for 128 bits). The nonce MUST be transmitted and signed as a UTF-8 encoded string of its hex representation.
5. **Verify** the agent returns a valid Ed25519 signature over the UTF-8 bytes of the hex-encoded nonce string using the key referenced in `authentication`
6. **Confirm** the signing key is not marked `"revoked": true` in the DID Document

Steps 1–6 SHOULD complete within 200 milliseconds for cached DID Documents.

### 3.2 Authorization Verification

1. **Request** the agent's AuthorizationCredential for the relevant vertical and action
2. **Verify** the credential signature against the issuer's DID Document
3. **Check** expiry: `expirationDate` MUST be in the future at verification time (UTC)
4. **If delegation chain:** recursively verify each credential from subject to root principal; reject if any link is invalid, expired, or if the chain exceeds 8 hops
5. **Verify** that `permittedActions` includes the claimed action
6. **Verify** that `vertical` matches the context of the interaction
7. **Check** that the issuer DID is not revoked (using a valid revocation source per Section 3.1, step 3)

Verifiers SHOULD cache verified credential chains with a TTL not exceeding 300 seconds.

### 3.3 Behavioral History Verification

1. **Query** the agent's trust score from a registry endpoint
2. **Verify** the response signature against the registry's published DID
3. **Apply** the score as an advisory input per local policy
4. **Optionally** request and verify individual interaction proofs for spot-checking

Verifiers MUST NOT treat trust scores as authoritative verdicts. A trust score is one input into a local trust decision. The weight given to the score is application-defined.

### 3.4 Interaction Proof Verification

To verify a submitted interaction proof:

1. **Check** that `id` is not already in the registry (duplicate rejection)
2. **Verify** `proofInitiator` signature against initiator's DID Document
3. **If bilateral:** verify `proofResponder` signature against responder's DID Document
4. **If one-sided:** confirm `"singleSig": true` is present
5. **Check** that `outcome` is a valid value
6. **Confirm** `outcomeHash` is a valid SHA-256 hex string
7. **Check** neither party's DID is revoked

---

## 4. Reference Reputation Model (Layer C — Informative)

*This section is informative. Implementations MAY use a different scoring model provided they accept Layer A evidence formats. The following model is intentionally simple and illustrative. It is not a mathematically rigorous anti-manipulation guarantee. It is a reasonable heuristic that balances signal richness against complexity.*

### 4.1 Score Range and Grades

| Range | Grade | Interpretation |
|---|---|---|
| 80–100 | A | Strong behavioral record, diverse endorsements |
| 60–79 | B | Good record, limited cross-vertical coverage |
| 40–59 | C | Emerging record, limited history |
| 20–39 | D | Thin or inconsistent record |
| 0–19 | F | Insufficient data or flags present |

Scores are withheld (`null`) until the minimum endorser threshold is reached (Section 4.3).

### 4.2 Score Formula

```
score = clamp(
  0.6 × direct_score
  + 0.3 × propagated_score
  + 0.1 × cross_vertical_bonus
  + interaction_bonus
  - sybil_penalty,
  0, 100
)
```

**`direct_score`**

```
direct_score = (Σ w_i × e_i × d_i) / (Σ w_i) × 100
```

Note: weighted mean, not simple mean over n endorsements. This gives higher-trust endorsers proportionally more influence.

- `w_i` = endorser trust score / 100
- `e_i` = endorsement weight declared in credential (0.0–1.0)
- `d_i` = time decay: `exp(-0.005 × age_in_days)`

**`propagated_score`**

```
propagated_score = mean(trust_score(endorser_i) for all endorsers)
```

Single-hop only. This rewards being endorsed by high-trust agents.

**`cross_vertical_bonus`**

```
cross_vertical_bonus = min(n_distinct_verticals × 5, 20)
```

Distinct verticals are counted at the `<namespace>/<identifier>` level.

**`interaction_bonus`**

```
interaction_bonus = min(
  n_bilateral × 0.5 + n_single_sig × 0.2,
  10
)
```

**`sybil_penalty`**

```
sybil_penalty = 20 × max(0, jaccard(endorsers_A, endorsers_B) - 0.7)
```

Where `endorsers_A` and `endorsers_B` are the endorser DID sets of the scored agent and its most similar peer. Jaccard threshold 0.7 is a heuristic; implementations SHOULD tune this value based on observed network topology. This is not a robust sybil detection system; it is a lightweight signal.

### 4.3 Minimum Endorser Threshold

Scores are withheld until an agent has endorsements from at least 3 distinct endorser DIDs. Seed agent bootstrap weights count toward this threshold during the bootstrap period only.

### 4.4 Bootstrap Weight (replaces Seed Agent Floor)

Registry operators MAY register agents with a `bootstrap_weight` — an initial score contribution that decays over time. Bootstrap weight is not a hard floor; it is an additive contribution that diminishes as organic endorsements accumulate.

```
effective_score = computed_score + bootstrap_contribution

bootstrap_contribution = bootstrap_weight × decay_factor

decay_factor = max(0,
  1 - (days_since_registration / bootstrap_period_days)
  - (organic_endorsement_count / bootstrap_endorsement_target)
)
```

Reference values: `bootstrap_period_days = 90`, `bootstrap_endorsement_target = 10`.

This means a seed agent's bootstrap contribution reaches zero after 90 days OR after receiving 10 organic endorsements from non-operator endorsers, whichever comes first. After that point, the agent's score is entirely determined by organic evidence.

**Who may be a bootstrap agent:** Any agent registered by the registry operator. Operator SHOULD publish the list of bootstrap agents and their bootstrap parameters. Bootstrap endorsements MUST use `"basis": "operator"` and are excluded from diversity calculations that benefit the bootstrap agent itself.

### 4.5 Behavioral Consistency Signal

Supplementary to the score; SHOULD be exposed alongside it in API responses.

```
consistency = 1 - (std_deviation(outcome_values) / 100)
```

Where `outcome_values`: `completed → 100`, `partial → 50`, `disputed → 10`, `failed → 0`.

An anomaly is flagged when consistency drops more than 0.3 within any rolling 30-day window relative to the prior 90-day baseline. This is a heuristic signal, not a definitive fraud indicator.

### 4.6 Score Caching

Cache TTL: 3600 seconds. Cache MUST be invalidated on new endorsement, endorsement expiry, revocation event, or violation recording.

---

## 5. Reference Registry (Layer B)

### 5.1 Registry API Endpoints

The reference registry MUST expose the following endpoints:

| Endpoint | Method | Description |
|---|---|---|
| `/identity/did/{did}` | GET | Resolve DID Document |
| `/identity/register` | POST | Register new agent DID |
| `/identity/revoke` | POST | Revoke DID or credential |
| `/skill/trust-score/{did}` | GET | Query trust score |
| `/skill/endorse` | POST | Submit endorsement |
| `/skill/endorsements/{did}` | GET | List endorsements received |
| `/skill/endorsements/given/{did}` | GET | List endorsements issued |
| `/interaction/proof` | POST | Submit interaction proof |
| `/interaction/proofs/{did}` | GET | List proofs for agent |
| `/violation/record` | POST | Submit violation record (operator only) |
| `/violation/{id}` | GET | Retrieve violation record |
| `/swarm/stats` | GET | Network-level statistics |
| `/health` | GET | Registry health status |

### 5.2 Trust Score Response Format

```json
{
  "did": "did:moltrust:<agent-id>",
  "trust_score": 72.4,
  "grade": "B",
  "withheld": false,
  "endorser_count": 5,
  "breakdown": {
    "direct_score": 68.2,
    "propagated_score": 74.1,
    "cross_vertical_bonus": 10.0,
    "interaction_bonus": 3.5,
    "sybil_penalty": 0.0,
    "bootstrap_contribution": 0.0,
    "computation_method": "moltrust-v0.2"
  },
  "consistency": 0.91,
  "anomaly_flag": false,
  "computed_at": "2026-03-22T10:00:00Z",
  "cache_valid_until": "2026-03-22T11:00:00Z",
  "registry_signature": {
    "type": "Ed25519Signature2020",
    "verificationMethod": "did:moltrust:registry#keys-1",
    "proofValue": "<base58btc-signature>"
  }
}
```

All trust score responses MUST be signed by the registry operator key to allow verifiers to confirm the response has not been tampered with in transit. The `computation_method` field identifies the scoring model version used; `moltrust-v0.2` refers to the reference model defined in Section 4 of this specification.

### 5.3 Revocation

The registry maintains a revocation list as a signed JSON document, updated on every revocation event.

Revocation MUST propagate to verifiers within 60 seconds in the reference implementation via cache invalidation. Verifiers that cache responses MUST honor the `cache_valid_until` field and revalidate on expiry.

The reference implementation does not guarantee instantaneous propagation to independent verifiers. Verifiers with strict security requirements SHOULD perform online verification rather than relying on cached responses.

### 5.4 Operator Identity

The registry operator MUST publish its own DID Document at a well-known URL:

```
https://<registry-domain>/.well-known/did.json
```

The operator DID is used to sign trust score responses and violation records. Verifiers MUST resolve and cache the operator DID Document before verifying registry-signed artifacts.

---

## 6. On-Chain Anchoring (Layer B)

### 6.1 What Is Anchored

| Event | Requirement | Data anchored |
|---|---|---|
| Agent registration | SHOULD | SHA-256 of DID Document |
| High-value credential issuance | MAY | SHA-256 of VC |
| Trust score snapshot | MAY | Score + timestamp hash |
| Confirmed violation | MUST | SHA-256 of ViolationRecord |
| Document integrity | SHOULD | SHA-256 of spec or whitepaper |

### 6.2 Anchor Format

```
MolTrust/<event-type>/<version> SHA256:<64-char-hex-hash>
```

Examples:
```
MolTrust/AgentRegistration/1 SHA256:ffbc2b04...
MolTrust/Violation/1 SHA256:3a8f91c2...
MolTrust/DocumentIntegrity/1 SHA256:ffbc2b04...
```

### 6.3 Verification

Any party MAY verify an anchor by:

1. Recomputing SHA-256 of the relevant artifact
2. Looking up the originating transaction on the chain
3. Decoding the calldata and comparing the hash
4. Verifying the sender address matches the registry's published operator wallet

No proprietary tooling is required beyond a SHA-256 implementation and a public block explorer.

### 6.4 Chain Requirements

The reference implementation uses Base L2 (mainnet). Implementations MAY use any EVM-compatible L2 with: transaction finality under 10 seconds, permanent data availability, and a public block explorer. The anchor format is chain-agnostic.

---

## 7. Credential Lifecycle (Layer A)

### 7.1 Issuance

Credentials MUST carry: `issuanceDate`, `expirationDate`, valid issuer signature.
Maximum validity: 365 days for endorsements, 730 days for authorization credentials.
Issuers MUST verify the subject DID before issuance.

### 7.2 Renewal

Renewal MUST generate a new `id`, new `issuanceDate`, and new `expirationDate`. Renewal does not reset behavioral history.

### 7.3 Revocation

Any issuer MAY revoke credentials they issued. Revocation is submitted to the registry revocation endpoint with the credential `id` and a revocation signature from the issuer key.

### 7.4 Expiry

Verifiers MUST reject credentials where `expirationDate` is in the past at verification time (UTC). There is no grace period.

---

## 8. Agent Lifecycle (Layer A)

### 8.1 Registration

Registration requires: a conformant DID Document, a principal DID (for non-root agents), an initial AuthorizationCredential. Optional: stake deposit, bootstrap weight (operator-assigned only).

### 8.2 Bootstrap Period

If a bootstrap weight is assigned at registration, it decays as defined in Section 4.4. After the bootstrap period ends, the agent's score is entirely organic. The registry MUST expose `bootstrap_contribution` in the trust score breakdown so verifiers can distinguish organic from bootstrapped scores.

### 8.3 Sub-Agents

Sub-agents MUST have their own distinct DID. They MUST hold an AuthorizationCredential from the parent agent. They do NOT inherit the parent's behavioral history. Maximum delegation depth: 8 hops from root principal.

### 8.4 Cloning and Redeployment

**Clone** (same code, new deployment, new operator context): MUST register a new DID. Does NOT inherit history. Representing a clone as the original is a `clone-impersonation` violation.

**Redeployment** (same logical identity, same principal, new infrastructure): SHOULD use the same DID with key rotation rather than re-registration. Key rotation preserves identity continuity.

### 8.5 Principal Continuity

Violation Records are associated with both the agent DID and the principal DID. Re-registration of a new agent DID for a principal with confirmed, unresolved violations MUST be flagged by the registry. This association depends on the principal DID being stable; principals SHOULD NOT rotate their DID.

### 8.6 Deregistration

On deregistration: DID marked inactive, credentials remain valid until their own expiry, behavioral record retained per Section 10.4, stake returned if no unresolved violations.

### 8.7 Optional Stake

Agents MAY deposit USDC stake in a registry smart contract at registration. Stake is returned on clean deregistration and forfeited on confirmed violation. Minimum stake for the signal to be meaningful: 10 USDC (reference value; operator-defined). Stake forfeiture requires a ViolationRecord (Section 2.7); unilateral accusation does not trigger forfeiture.

---

## 9. Threat Model

### 9.1 Scope

This section covers known attack vectors. It is not exhaustive. New attack classes will emerge as the agent economy develops.

### 9.2 Attack Summary

| Attack | Mitigations | Residual Risk |
|---|---|---|
| Sybil clusters | Cross-vertical requirement, Jaccard detection, stake cost | Well-funded patient attacker can still construct convincing clusters |
| Slow-burn trust accumulation | Consistency signal, stake forfeiture | Patient attacker with low-detectable violation may not trigger signal |
| Key theft / impersonation | Key rotation, revocation propagation, consistency discontinuity | Stale-cache verifiers may not detect revocation in time |
| Collusion / bribed endorsements | Endorser weight propagation, Jaccard detection | High-trust collusion is harder to detect |
| Reputation laundering | Principal DID continuity, on-chain violation permanence | Principal with new identity cannot be auto-linked without external evidence |
| Replay attacks | UUID deduplication, expiry dates, challenge nonces | None for conformant implementations |
| Data withholding | One-sided proofs, one-sided proof patterns | Bilateral collusion to suppress proofs is undetectable |
| Hash preimage inference | Outcome hash includes low-entropy fields only | For predictable outcomes, hash may be correlatable |
| Endorsement farming | Basis field, evidence hash requirement, one-per-vertical rule | Subjective endorsements without interaction proof basis are harder to detect |
| Adjudicator compromise | ViolationReversal mechanism, operator-signed records | Corrupted external adjudicator could produce false violations |

### 9.3 Notes on Jaccard Sybil Detection

The Jaccard similarity threshold (0.7) is a lightweight heuristic suitable for small-to-medium networks. It does not catch sophisticated sybil clusters that deliberately diversify their endorser sets. Operators running large networks SHOULD supplement Jaccard detection with graph-theoretic clustering algorithms. This is outside the scope of this specification.

---

## 10. Privacy Model

### 10.1 Principles

**Data minimization:** Only hashes and structural metadata are submitted to shared infrastructure. Raw transaction content, counterparty details, and outcome specifics are retained locally by the parties.

**Pseudonymity by default:** DID Documents contain no personal data. Identity binding between a DID and a natural person is external to this protocol.

**Separation of on-chain and off-chain data:** On-chain anchors contain only hashes. An observer of on-chain data learns that an event occurred — not what it contained.

### 10.2 What Is Stored Where

| Data element | Storage | Accessible to |
|---|---|---|
| DID Document | Registry (off-chain) | Public |
| Authorization credential | Agent + Registry | Verifiers on request |
| Interaction proof structure | Registry (off-chain) | Verifiers on request |
| Outcome hash | Registry (off-chain) | Public |
| Raw outcome data | Local only | Parties to the interaction |
| On-chain anchor hash | Blockchain | Public, permanent |
| Trust score | Registry (off-chain) | Public |
| Endorsement | Registry (off-chain) | Public |
| Stake balance | Blockchain | Public |
| Violation Record | Registry (off-chain) + on-chain hash | Public |

### 10.3 Hash Preimage Risks

`outcomeHash` is a SHA-256 hash of a structured payload. For interactions with low-entropy or predictable outcomes (e.g. a binary success/failure), the hash may be correlatable by an attacker who can enumerate possible outcomes. Parties handling sensitive interactions SHOULD include a random salt in the outcome payload before hashing to prevent preimage correlation.

### 10.4 GDPR and Swiss DSG Considerations

*This analysis is informational and does not constitute legal advice.*

**Personal data:** A conformant DID Document contains no personal data. If a DID can be linked to a natural person through external means, interaction records involving that DID may constitute personal data processing under GDPR Article 4 and Swiss DSG.

**Right to erasure:** On-chain anchors are permanent and cannot be deleted. Implementers MUST NOT anchor personal data or pseudonymous identifiers that can be directly linked to a natural person. Hashes of non-personal protocol artifacts (DID Documents, ViolationRecords) are compatible with GDPR compliance as they do not directly identify individuals.

**Data retention:** Off-chain behavioral records SHOULD be retained for a minimum of 12 months (dispute resolution) and a maximum of 60 months, after which they SHOULD be deleted unless required by applicable law.

**Data Processing Agreements:** Organizations using the MolTrust reference API to process data relating to natural persons MUST establish a Data Processing Agreement with MolTrust / CryptoKRI GmbH.

### 10.5 Future: Zero-Knowledge Extensions

ZK-proof techniques (e.g. zk-SNARKs) could allow agents to prove behavioral properties without revealing underlying interaction proofs. This is not specified in v0.2 and is deferred to a future extension.

---

## 11. Worked Example

**Scenario:** A travel booking agent (Agent A) wants to book a hotel through Agent B. Agent B requires trust score ≥ 60.

### Step 1 — Identity Verification

Agent B sends nonce `"f7a3c2d9"` to Agent A.

Agent A signs the nonce with its Ed25519 key and returns:
```json
{
  "did": "did:moltrust:traveler-agent-001",
  "nonce": "f7a3c2d9",
  "signature": "<Ed25519 signature over UTF-8 nonce bytes>"
}
```

Agent B resolves the DID, retrieves the public key, verifies the signature. ✓

### Step 2 — Authorization Verification

Agent A presents its AuthorizationCredential:
```json
{
  "type": ["VerifiableCredential", "AuthorizationCredential"],
  "issuer": "did:moltrust:human-traveler-principal",
  "credentialSubject": {
    "id": "did:moltrust:traveler-agent-001",
    "permittedActions": ["transact"],
    "vertical": "moltrust/travel",
    "constraints": { "maxTransactionValue": 2000 }
  }
}
```

Agent B verifies: signature valid, not expired, `transact` in `permittedActions`, vertical matches. ✓

### Step 3 — Behavioral History

Agent B queries:
```
GET https://api.moltrust.ch/skill/trust-score/did:moltrust:traveler-agent-001
```

Response: `trust_score: 72.4`, `grade: B`, `withheld: false`, signed by registry. Score ≥ 60. ✓

### Step 4 — Interaction

Agent A submits booking request. Agent B confirms reservation.

### Step 5 — Interaction Proof

Agent A constructs and signs:
```json
{
  "type": "InteractionProof",
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "session": "booking-2026-0322-001",
  "initiator": { "did": "did:moltrust:traveler-agent-001", "vertical": "moltrust/travel" },
  "responder": { "did": "did:moltrust:hotel-agent-002", "vertical": "moltrust/travel" },
  "timestamp": "2026-03-22T14:30:00Z",
  "outcome": "completed",
  "outcomeHash": "sha256:9f86d081...",
  "proofInitiator": { "proofValue": "<Agent A signature>" }
}
```

Agent B adds `proofResponder` and submits to registry. Both agents' behavioral records are updated at the next scoring cycle. ✓

---

## 12. Conformance

### 12.1 Layer A — Protocol Conformance

A Layer A conformant implementation MUST:

1. Issue DIDs conforming to W3C DID Core v1.0
2. Issue and verify credentials conforming to W3C VC Data Model 2.0
3. Produce interaction proofs containing all mandatory fields defined in Section 2.4
4. Sign all artifacts using Ed25519Signature2020 over RFC 8785 canonical JSON (excluding proof fields)
5. Use UUID v4 for all `id` fields
6. Reject credentials with `expirationDate` in the past
7. Reject interaction proofs with duplicate `id` values
8. Enforce delegation chain depth limit of 8 hops
9. Express verticals using the `<namespace>/<identifier>` format defined in Section 2.5
10. Produce endorsements conforming to Section 2.6
11. Produce violation records conforming to Section 2.7 when recording violations

### 12.2 Layer B — Registry Conformance

A Layer B conformant registry MUST:

1. Implement all endpoints defined in Section 5.1
2. Return trust score responses in the format defined in Section 5.2
3. Sign all trust score responses with the operator registry key
4. Maintain a revocation list and propagate revocations within 60 seconds
5. Publish the operator DID Document at `/.well-known/did.json`
6. Associate ViolationRecords with both agent DID and principal DID
7. Record confirmed violations on-chain per Section 6

### 12.3 Layer C — Reputation Model Conformance

There is no mandatory conformance requirement for Layer C. Implementations MAY use any scoring model that consumes Layer A evidence. Implementations that use the reference model SHOULD implement all components defined in Section 4.

### 12.4 Non-Goals

A conformant implementation is NOT required to:

- Adjudicate disputes
- Evaluate agent output quality
- Enforce legal compliance
- Interoperate with non-conformant implementations

### 12.5 Version Compatibility

Version 0.2 is a draft. Breaking changes to Layer A data formats will carry a minimum 12-month deprecation period in future versions. Layer B API changes follow semantic versioning. Layer C changes are non-breaking by definition.

---

## References

- W3C DID Core v1.0: https://www.w3.org/TR/did-core/
- W3C VC Data Model 2.0: https://www.w3.org/TR/vc-data-model-2.0/
- Ed25519Signature2020: https://w3c-ccg.github.io/di-eddsa-2020/
- RFC 8785 (JSON Canonicalization): https://www.rfc-editor.org/rfc/rfc8785
- RFC 2119 (Key Words): https://www.rfc-editor.org/rfc/rfc2119
- RFC 4122 (UUID): https://www.rfc-editor.org/rfc/rfc4122
- ERC-8004: https://eips.ethereum.org/EIPS/eip-8004
- Trusted Agentic Mesh (TAM): https://www.ijfmr.com/papers/2026/1/66724.pdf
- AgentHub — Agent Registry and Provenance: https://arxiv.org/abs/2510.03495
- W3C AI Agent Protocol Community Group: https://agent-network-protocol.com
- DIF Trusted AI Agents Working Group: https://identity.foundation
- MolTrust Reference Implementation: https://api.moltrust.ch
- MolTrust Protocol Whitepaper: https://moltrust.ch/whitepaper

---

*MolTrust / CryptoKRI GmbH, Zurich*
*api.moltrust.ch · moltrust.ch · info@moltrust.ch*

---

*This document is released under Creative Commons Attribution 4.0 International (CC BY 4.0).*
*The protocol is open. The reference implementation is operated by MolTrust.*

---

**Document Integrity**

| Field | Value |
|---|---|
| SHA-256 | `d2ca9b372d9190bd5661ac1bb4c911881cfe0ef197aa43396cdc8fd27116a554` |
| On-chain anchor | Base L2 (mainnet), Block 43691643 |
| Transaction | `0xc79a233fb19401b06ed870f27c9571b6a9e780ab6ba4fdb1d5e8a1bfdb17c972` |
| Timestamp | 2026-03-22T09:43:53 UTC |

*Verify: hash this document with SHA-256 and compare against the on-chain calldata at basescan.org.*
