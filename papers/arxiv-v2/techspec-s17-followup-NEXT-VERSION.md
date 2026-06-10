# TECH_SPEC §17 — Additive Follow-up (NEXT VERSION) — STAGED, DO NOT ANCHOR NOW

> **STATUS: STAGED for the arXiv-v2 anchor cycle (Backlog #28). NOT to be anchored on its own.**
> TECH_SPEC **v0.9 §17 stays anchored exactly as it is** (Base L2 block 46,986,137,
> sha256 `462af65a…`, payload `MolTrust/TechSpec/0.9`). Nothing here changes that record.
> These are **additive** edits for the **next** TechSpec version, to be built + anchored
> **together with** the arXiv-v2 publication anchor — not before. None of this contradicts
> the anchored v0.9; each item only *names* something v0.9 left implicit or has since been
> corrected outside the spec.

**Bundle for the v2 anchor cycle (three additive items):**

| # | Item | Source / already-done | §17 touch-point |
|---|---|---|---|
| 1 | **(a)/(b) two enforcement scopes** | code-verified 2026-06-10 (`app/enforcement/*`, `/vc/aae/evaluate`); arXiv-v2 spine §6.1 (PR #7) | **new §17.1.x** (below) |
| 2 | **Conformance 5/5 → 4/5 + 1 open item** | already live: `moltrust-api` CONFORMANCE.md (PR #152) + `moltrust-web` aip-conformance.html (PR #64); arXiv-v2 §7.2 | align any §16/§17 conformance phrasing (no normative change) |
| 3 | **R0→R2 decentralization-maturity ladder** | analysis 2026-06-09 (this cycle); CEP-3 #145 + §17.2.3 | **additive note to §17.2.3** (below) |
| 4 | **Override-record format (operator-signed)** | ai_review consistency pass 2026-06-10 (technical + eu-compliance); resolves the one finding | **new §17.1.y** deliverable definition (below) |

---

## Item 1 — new §17.1.x: Two enforcement scopes (operator-local vs network-wide)

**Rationale.** v0.9 §17.1.2 frames the *enforce* mode monolithically as "Component 3 …
gated per §17.2.4" (i.e. CEP-gated). Code review (2026-06-10) confirms the deployed
architecture already supports **operator-local** fail-closed enforcement with **no** CEP
coupling: the evaluator is a verdict service producing signed, default-DENY verdicts scoped
to `(agent_did, aae_ref)` with `agent_did == authenticated principal` enforced; there is **no**
global enforce flag and **zero** CEP/cluster references in `app/enforcement/`. v0.9's wording
therefore *under-describes* what the layer can do. The fix is additive — name the two scopes;
do not change the advisory default for the network-wide scope.

**Proposed normative text (additive subsection in §17.1):**

> **§17.1.x — Two enforcement scopes.**
> A DENY verdict becomes a *block* only when some party refuses the described action. Two
> scopes differ in *who* that party is and under *whose* authority it acts.
>
> **(a) Operator-local enforcement.** A relying party MAY run a fail-closed chokepoint in its
> **own** gateway, refusing its own agent's action on a signed DENY against its own AAE
> mandate, under its own authority and override. This requires **no** CEP transition — the
> operator is the authorising party for its own agent, and carries the corresponding Art. 14
> oversight duty (cf. §17.2.2 scope position). *Status: the registry-side verdict service
> (§17.1.2) is implemented; the caller-side chokepoint is a thin integration in the operator's
> gateway (cf. §9.4 MoltGuard; the `trust_gate` SDK pattern) — PoC-buildable today.*
>
> **(b) Network-wide, operator-independent enforcement.** The **mandatory** chokepoint that
> gates a **third party's** agent without that operator's say-so — enforcement whose authority
> must not depend on any single operator — is CEP, gated per §17.2.4, ramping to the K=4
> mainnet target. *Status: designed; advisory until activation.*
>
> The verdict is identical in both scopes; they differ only in who acts on it and who
> authorises. (a) does not weaken (b): an operator self-gating its own agent makes no claim
> over the network and confers no authority over other agents. The advisory default of §17.1.2
> and the activation gate of §17.2.4 continue to govern scope (b) unchanged.

**Non-contradiction:** §17.2.4 (binary CEP gate at K=4) and the §17.1.2 advisory default both
remain in force for scope (b). The addition only *names* scope (a), which v0.9 left under "advisory".

---

## Item 3 — additive note to §17.2.3: R0→R2 decentralization-maturity ladder

**Rationale.** v0.9 §17.2.3 gives two parameter sets (Testnet K=3, Mainnet K=4) as a
binary target, framed as two *networks*, not a ramp. Lars' goal is a graduated decentralization
ladder. Finding (2026-06-09): the enforcement-activation flip **stays binary at K=4** (else the
"without an operator" property of scope (b) breaks); the ladder is a **maturity ladder under
continuous advisory** for scope (b), with operator-local scope (a) fail-closed throughout. The
hard invariant `Y < 50%` makes **K=2 structurally infeasible** (`Y ≥ 1/K = 50%` collides), so the
realizable ladder is **K=1 → K=3 → K=4** (K=2 omitted).

**Proposed additive note (after §17.2.3 table):**

> **§17.2.3a — Maturity ladder (non-normative).** Before activation the network matures through
> rungs, advisory throughout for scope (b); the binary advisory→enforce flip (§17.2.4) occurs
> only at the mainnet target:
>
> | Rung | K | N (AND) | Y | X | Scope-(b) mode |
> |---|---|---|---|---|---|
> | R0 | 1 | founder-curated (≤~11) | — (vacuous) | — (vacuous) | advisory; operator-local (a) may fail-close |
> | R1 | 3 | intermediate (TBD) | ≤ 34% | ≤ 10% | advisory; mechanism demonstrable |
> | R2 | 4 | 101 | 33% | 10% | **flip → enforce** (anchored target) |
>
> K=2 is omitted: the hard invariant `Y < 50%` and `Y ≥ 1/K` are jointly unsatisfiable at K=2.
> A K=2 rung would require amending the `Y < 50%` hard invariant — an ADR-level change, out of
> scope for this additive note. R0/K=1 is the **founder-curated first rung**, not "no CEP".

**Open value:** R1 `N` (Lars-parameter, like `T_min`/`T_endorse_min` in CEP-3 #145).

**Non-contradiction:** R2 == the anchored mainnet endpoint `101/4/33/10/31`. The ladder is
additive framing of the pre-activation phase v0.9 leaves unnamed.

---

## Item 4 — new §17.1.y: Override-record format (operator-signed) — DELIVERABLE DEFINITION

> **Type: format-spec / deliverable definition. DO NOT BUILD NOW** — buildable when the first
> operator integrates scope-(a) enforcement (Item 1). This entry *fixes the format* so the build,
> when it happens, is unambiguous; it does not schedule the build.

**Rationale.** The ai_review consistency pass (2026-06-10, technical + eu-compliance, both panels
independently) confirmed scope (a) is consistent with the protocol-layer position, with **one**
finding: an *MT-signed* override record would make MT process the operator's decision
(GDPR Art. 4(2) — processing arises at signature time, even without storage) → MT becomes a
processor → contradicts "MT holds no personal data" and "the operator decides". The fix is a format
choice that *strengthens* the position; it re-opens nothing. It lands here, not in §6.1: §6.1 stays
**unchanged** — it asserts nothing about override-record signing (only "signed DENY … with its own
override"), so it is already consistent.

**Proposed normative deliverable definition (additive subsection in §17.1):**

> **§17.1.y — Override-record format.** When an operator runs scope-(a) enforcement (§17.1.x(a))
> and exercises an override, the override is recorded as follows.
>
> - **Signing authority.** The override record is **operator-signed** (operator DID / eIDAS key).
>   MT signs **only** the DENY *verdict*; MT **never** signs the override. The operator-signed
>   record **embeds the MT-signed DENY verdict as evidence** (W3C **VC → VP** pattern: the MT
>   verdict is the VC; the operator wraps it, adds its decision, and signs the whole as a VP).
>   *Consequence: MT holds no personal data and performs no Art. 4(2) processing of the operator's
>   decision; the conscious-decision evidence is cryptographically held by the operator.*
> - **Mandatory fields (normative).** `action_id`, `aae_hash` + `aae_version`, `nonce`,
>   `timestamp`, `operator_id`, `operator_signature` (over the above + the embedded MT verdict).
> - **Replay protection.** Each pending action carries a unique `pending_id`; an override record
>   binds to exactly one `pending_id` / `action_id` (no record replay across actions).
> - **State loss = fail-closed.** If the operator gateway loses pending state (e.g. crash) the
>   default holds: the action is **discarded**, not allowed. Fail-closed is the crash default.
> - **Standing policy vs. auto-default.** A standing-policy override MUST be distinguishable from a
>   silent default: it carries an explicit **validity window** and a **re-confirmation** requirement
>   on expiry. Without these it is legally attackable as a "default without a conscious decision"
>   (cf. Art. 14 human-oversight evidence). A standing policy is itself an operator-signed record.
>
> MT's deliverables for scope (a) are therefore: the signed DENY verdict, **this** override-record
> format, and a reference SDK. The notification/UX and the operator key custody are the operator's.

**Non-contradiction:** MT's signing surface is *narrowed* (verdict only), consistent with the
§17.1.2 verdict service and the §17.1.x scope split. No change to scope (b) or to §6.1.

**Legal-process (counsel / Kirchinger, not design):** AGB wording that MT = protocol/verdict layer,
operator carries Art. 14 human-oversight incl. for standing policies, MT signature attests
mandate-check integrity (not network policy). Tracked separately; not part of this format spec.

---

## Cross-references
- arXiv-v2 spine §6.1 (this PR #7) — the (a)/(b) prose for the paper.
- arXiv-v2 §7.2 — conformance "4/5 + 1 open item" (Item 2).
- `docs/decisions/ADR-CEP-governance-v8.md` (PR #143, ACCEPTED) — CEP design of record.
- `docs/specs/cep-3-thresholds.md` (PR #145, commit `b2eb0ea`) — frozen K/Y/X, hard invariants.
- ai_review consistency pass 2026-06-10 (`~/moltstack/reviews/20260610_*operator-local-override-*`) — Item 4 source.
- TECH_SPEC v0.9 §17 (anchored block 46,986,137) — the unchanged base.

## Anchor-cycle checklist (do when v2 is anchored, NOT before)
- [ ] Fold Items 1–4 into TECH_SPEC as next version (e.g. v0.10) — additive, §17 v0.9 untouched in history.
- [ ] Override-record format (Item 4) shipped as a deliverable spec + reference SDK when the first operator integrates scope (a) — not before.
- [ ] Build PDF (`TECH_SPEC_VERSION=… LC_ALL=en_US.UTF-8 ./scripts/build_pdfs.sh tech_spec`).
- [ ] Anchor next-version sha256 on Base L2 alongside the arXiv-v2 anchor (one cycle).
- [ ] publications/integrity.html: new Current card; v0.9 → Historical (kept reachable, like v0.8.1).
- [ ] Backlog #28 entry closed.
