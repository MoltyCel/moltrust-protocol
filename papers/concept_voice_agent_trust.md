# Verifiable Agent Identity for Enterprise Voice Agent Platforms
## A Technical Concept Paper

**Date:** April 2026 | **Status:** Educational Overview

> PDF version: https://moltrust.ch/papers/concept_voice_agent_trust.pdf

## Executive Summary

Enterprise voice agent platforms face a trust gap that existing security infrastructure does not address. SSO, RBAC, and platform-level certifications solve the human-to-platform trust problem. They do not solve the agent-to-agent trust problem.

When a voice agent deployed by Enterprise A interacts with an external system or agent operated by Enterprise B, Enterprise B has no cryptographically verifiable way to answer three questions:

- **Who is this agent?** (Identity, not just authentication)
- **What is it authorized to do?** (Scope, not just access token)
- **Has it behaved reliably in the past?** (Reputation, not just compliance certification)

## The Trust Gap: Five Unanswered Questions

| Question | Available Today | Gap |
|---|---|---|
| Is this a real agent? | API key / OAuth token | Tied to platform account, not the individual agent |
| Which agent is this? | Conversation ID (internal) | Not portable across systems |
| What can it do? | Scope in access token | Issued by the platform, not independently verifiable |
| Has it behaved well? | Platform track record | Not queryable by external systems |
| Can I audit this later? | Platform logs | Requires trusting the platform |

## The Architecture: W3C DID-Based Agent Identity

### Decentralized Identifiers for Agents

A W3C DID gives each agent a cryptographically verifiable identity that exists independently of any platform. Unlike an API key or OAuth token, a DID is:

- **Portable** — resolves without calling the issuing platform's API
- **Self-certifying** — verification requires only the public key, not a live service
- **Revocable** — the controller can invalidate it without touching the external system

### Verifiable Credentials for Authorization

A VC issued to the agent attests to its authorization scope. Key properties:

- **Offline verifiable:** External systems verify the Ed25519 signature without calling the deploying platform
- **Scope-bounded:** The agent cannot claim more authority than the VC grants
- **Time-limited:** Credentials expire; reissuance creates a natural audit checkpoint
- **Monotonically narrowing:** Delegation chains can only restrict scope, never expand it

### On-Chain Anchoring for Non-Repudiation

Each significant agent action produces an Interaction Proof Record (IPR) anchored on Base L2 via Merkle batch — tamper-evident, globally verifiable, independently auditable.

### Trust Scoring

A continuous reputation signal (not a binary gate) aggregates endorsements, behavioral compliance, payment history, and cross-platform interaction outcomes. External systems set their own risk thresholds.

## Verification Flow

```
Enterprise B receives call from Agent A:

1. Agent A presents: DID + VC + AAE envelope
2. Enterprise B resolves DID → public key (no API call to Enterprise A)
3. Enterprise B verifies VC signature (Ed25519, offline, ~2ms)
4. Enterprise B evaluates AAE CONSTRAINTS:
   - Is this agent authorized for this action?
   - Is the spend within limits?
   - Is the credential still valid (TTL)?
5. Enterprise B queries trust score (optional, ~50ms):
   GET /skill/trust-score/{did}
6. Decision: proceed, escalate, or reject
```

## Integration Patterns

### Pattern 1: Pre-Call Verification

Before a voice agent initiates an outbound call, the receiving system verifies the agent's identity and authorization. The call only connects if verification passes.

### Pattern 2: In-Call Credential Exchange

During an active call between two voice agents, credentials are exchanged via a sideband channel. The call continues only if mutual verification succeeds.

### Pattern 3: Post-Call Audit

After a call completes, both parties anchor an IPR with the call outcome. The IPR is independently verifiable and contributes to the agent's trust score.

## What This Does Not Replace

- **Platform security:** SSO, RBAC, encryption — all still necessary
- **Compliance certifications:** SOC 2, HIPAA, ISO 27001 — still required
- **Human oversight:** Approval workflows, escalation paths — still needed

This adds a layer that platform security cannot provide: cryptographically verifiable, cross-platform, agent-level identity and authorization.

The external system **never needs to contact the deploying platform**. Verification is fully offline for steps 1-3.

## What Is Additive, What Does Not Change

**Requires change:** Agent registration (DID generation — one-time, automated), request headers (DID + VC on outbound requests), IPR logging, optional trust score query.

**Does not change:** Existing SSO/RBAC, platform certification, guardrails, monitoring. The identity layer is **additive, not disruptive**.

## Enterprise Value Proposition

| Stakeholder | Benefit |
|---|---|
| Platform | Portable agent identity as differentiator. EU AI Act Art. 26 compliance. AI insurance enablement. |
| Enterprise Customer | Inter-enterprise agent commerce. On-chain audit trail. Risk-tiered deployment by trust score. |
| End User | Transparent declared scope. Accountability. Trust portability. |

## Open Questions for Platform Teams

1. **DID method selection:** did:web vs. blockchain-anchored
2. **Credential granularity:** Per-agent-instance vs. per-agent-type
3. **Trust score visibility:** Should customers see scores of their own agents?
4. **Revocation latency:** 5-min cache TTL vs. live checks for high-assurance contexts
5. **Cross-platform trust import:** Discount weight for imported scores

## Standards Alignment

- W3C DID Core 1.1 (Candidate Recommendation, March 2026)
- W3C Verifiable Credentials 2.0 (Recommendation, May 2025)
- Ed25519 / EdDSA (RFC 8037)
- JSON Canonicalization Scheme (RFC 8785)
- Base L2 (EVM-compatible public anchoring)

## References

- MolTrust Protocol Whitepaper v0.6.1: https://moltrust.ch/MolTrust_Protocol_Whitepaper_v0.6.pdf
- MolTrust TechSpec v0.7: https://moltrust.ch/MolTrust_Protocol_TechSpec_v0.7.pdf
- W3C DID Core v1.0: https://www.w3.org/TR/did-core/
- W3C VC Data Model 2.0: https://www.w3.org/TR/vc-data-model-2.0/

## Contact

- Website: https://moltrust.ch
- API Docs: https://api.moltrust.ch
- GitHub: https://github.com/MoltyCel/moltrust-api
- Email: info@moltrust.ch

---

*Educational overview. All standards reflect publicly available specifications as of April 2026. MolTrust / CryptoKRI GmbH, Zurich.*
