# Research Notes — KYC/AML/FATF/DeFi Analogy (verified source collection)

> **STATUS: research notes for the writing phase. NOT paper text, NOT a thesis formulation.**
> Live-web research (4 streams) + a primary verify-pass on the 4 load-bearing caveat sources.
> Every source is tagged with a verification level. Do not quote a `[P-abs]`/`[S]` figure as if
> table-level-verified; the `## E` to-do list names what still needs a manual browser pull.

**Verification legend**
`[P]` primary read directly · `[P-arch]` primary text via archive.org/regulator mirror (live host 403) ·
`[P-abs]` primary abstract confirmed, inside figures via convergent secondary · `[S]` reputable secondary ·
`[U]` unverified / flagged.

---

## A. Verify-pass results — the 4 caveat sources (all HOLD, with corrections)

1. **IMF greylisting → capital-flow effect — HOLDS `[P-abs]`.**
   Kida, M. & Paetzold, S. (2021), *The Impact of Gray-Listing on Capital Flows: An Analysis Using
   Machine Learning*, IMF Working Paper WP/21/153, DOI 10.5089/9781513582436.001.
   Figures confirmed: total capital inflows **−7.6% of GDP**, FDI **−3.0%**, other investment **−3.6%**
   (also portfolio **−2.9%**), "large and statistically significant" (abstract verbatim). Mechanism =
   **de-risking** — but framed as *a* mechanism (alongside a "market-enforcement/heuristic" channel),
   not *the* sole one. Components don't sum to the −7.6% headline (separate specs/samples).
   ✅ **E1 CLOSED — TABLE-LEVEL CONFIRMED** (Table 1, read via a third-party mirror of the official
   print PDF after imf.org/SSRN 403'd): Total **−7.550\*\*\*** (SE 1.522, 95%CI [−10.53,−4.57]),
   FDI **−3.034\*\*\***, Portfolio **−2.926\*\*\***, Other **−3.551\*\*\*** — all sig. at 1%, year+country
   FE, robust SE clustered by country. **Method = double-selection lasso (NOT synthetic control — correct
   the earlier note).** Sample = **89 EMDCs, quarterly 2000q1–2017q4**, event window k=3. Robustness:
   k=4→−8.203, k=2→−5.789, k=1→−4.836; resampling (SMOTE/RU) −6.3…−7.5. Authors' caveat: greylist obs
   ≈0.7% of sample; −7.6% ≈ GFC 25th-percentile decline. (A floating secondary −3.2/−3.3/−3.1 was WRONG
   — it conflated Table 2 sub-components; disregard.) Mirror authoritative-but-not-imf.org.

2. **FATF "rational myth" counter-finding — HOLDS `[P]` (abstract).**
   Case-Ruchala, D. & Nance, M. T. (2024), *The Limits of Enforcement in Global Financial Governance:
   Blacklisting in FATF as Rational Myth*, *International Studies Quarterly* 68(3), sqae115,
   DOI 10.1093/isq/sqae115 (online 12 Aug 2024). Abstract read on primary OUP page: "listing is **not
   correlated with financial harm**" across **four** measures (cross-border banking liabilities,
   portfolio flows, FDI, World Bank aid); interprets compliance-despite-no-evidence as a **"rational
   myth"** (verbatim).
   ⚠️ **Load-bearing nuance:** its explicit empirical target is **Morse (2019)**, not the IMF WP. So
   IMF vs C-R&N is **finding-vs-finding** (opposing conclusions, different lists/samples/methods —
   IMF: greylist post-2010, ML/synthetic control; C-R&N: replication+extension of Morse, panel), **not
   a line-by-line rebuttal**. Cite both that way; do NOT present either as settled.

3. **FATF-as-governance-model lineage keystone — FULLY VERIFIED `[P]`.**
   **Newmeyer, Kevin** (2011), *The FATF as a model for Internet governance*, 2011 eCrime Researchers
   Summit (APWG/IEEE), pp. 1–5. Single author, Center for Hemispheric Defense Studies, Washington DC.
   Thesis confirmed (apply the FATF intergovernmental/blacklisting model to Internet/cyber governance).
   Author confirmed via OpenAlex W2115379802 + author Academia.edu; it is a **conceptual/position paper**.
   ✅ **E2 CLOSED — citation LOCKED.** DOI is **dead at the agency level** (404 at both doi.org AND
   api.crossref.org; OpenAlex lists no DOI) — **do NOT cite the DOI as resolvable.** Locked citation:
   *Newmeyer, Kevin. "The FATF as a Model for Internet Governance." In 2011 eCrime Researchers Summit,
   pp. 1–5. APWG/IEEE, 2011.* Anchor URL = `https://ieeexplore.ieee.org/document/5978781`. DBLP doesn't index it.

4. **FATF Plenary centralization + current lists — HOLDS `[P-arch]` (1 correction).**
   - Plenary = "**the decision-making body of the FATF. Its decisions are taken by consensus**" (Mandate
     paras 18–20, archive.org snapshot). ICRG Joint Groups "make recommendations… **put to Plenary for
     decision**" (ICRG Procedures para 30, regulatory mirror). → **the designation/listing decision is a
     centralized consensus act of the Plenary** (this is the "central operator" qualification).
   - **Grey list = 22 jurisdictions** (CORRECTION: prior research said ~23), dated **13 Feb 2026** (Mexico
     Plenary); incl. **Papua New Guinea + Kuwait** (confirmed new). Black list = **Iran, DPRK, Myanmar**
     (confirmed). ⚠️ fatf-gafi.org live 403'd → read via archive.org snapshots + a regulator's verbatim
     reproduction. 13 Feb 2026 is the most recent firmly-confirmed list (a possible June 2026 update not
     verifiable from a dated official source yet).
   ✅ **E3 CLOSED.** Grey list = **22** enumerated (Algeria, Angola, Bolivia, Bulgaria, Cameroon, Côte
   d'Ivoire, DR Congo, Haiti, Kenya, Kuwait\*, Lao PDR, Lebanon, Monaco, Namibia, Nepal, Papua New
   Guinea\*, South Sudan, Syria, Venezuela, Vietnam, Virgin Islands UK, Yemen; \*=new), 13 Feb 2026
   Mexico City Plenary (11–13 Feb). Plenary-centrality locked: ICRG Procedures (2022) "recommendations…
   **put to Plenary for decision**" (`fatf-gafi.org/content/dam/fatf-gafi/methodology/Assessment-Follow-Up-ICRG-Procedures-2022.pdf…`).
   **No June 2026 superseding list** confirmed; 13 Feb 2026 stands. Sources: financialcrime.lu (verbatim
   FATF outcomes), Comsure (enumerated 22), Basel Institute. archive.org unreachable this run → regulator reproductions.

---

## B. Full source collection by research point

### Point 1 — DeFi / On-chain governance (mixed: one counter-example, one primitive, one two-edged precedent, one negative-empirics)

**1a. Chainalysis on-chain sanctions oracle — ⚠️ does NOT support "enforcement without a central operator".**
Read path (`isSanctioned()`) permissionless; **write path / list-curation = a single owner address**
(`Ownable`, admin `0xDF90…36CD`) → SPOF. Update lags up to 66 days documented.
- `[P]` Chainalysis, *Chainalysis oracle for sanctions screening* (docs) — go.chainalysis.com/chainalysis-oracle-docs.html
- `[P]` Etherscan `SanctionsList` `0x40C57923924B5c5c5455c48D93317139ADDaC8fb` (`Ownable`, owner-only add/remove) — strongest SPOF artifact
- `[S]` DataFinnovation/ChainArgos (2024), *The Chainalysis Sanctions Oracle — When should you be concerned it's late?* (Medium) — single-owner addr + lag data
- `[U]` TRM Labs on-chain oracle contract = **does not exist** (TRM is off-chain API). Do not cite as on-chain.
- **Use:** failure-mode/negative example (how a public chain still reintroduces an operator), not support.

**1b. Ethereum Attestation Service (EAS) — partial support, but no enforcement layer.**
Genuinely permissionless/tokenless/no-owner-gate; but **no rule-setter and no enforcer** — consequence is
consumer/reputation-side. Supplies the *verification primitive*, not the *consequence*.
- `[P]` EAS docs FAQ — docs.attest.org/docs/quick--start/faqs ("permissionless, tokenless, free"; value = issuer reputation)
- `[P]` `SchemaRegistry.sol` / `EAS.sol` (github.com/ethereum-attestation-service/eas-contracts) — `external register`, no owner gate

**1c. Tornado Cash / Van Loon v. Treasury — two-edged keystone.**
SUPPORTS: 5th Cir. (26 Nov 2024, No. 23-50669) — immutable smart contracts are **not "property" under
IEEPA**; "no party can control immutable smart contracts… just software code"; contracts ran through
sanctions + delisting. BREAKS: enforcement re-targeted **identifiable persons** (Storm convicted 6 Aug
2025; Pertsev 64mo NL) + front-ends/mutable parts → "no operator" ≠ "no enforcement exposure"; and
immutability = also no *legitimate* governance.
- `[P]` *Van Loon v. Dep't of the Treasury*, No. 23-50669 (5th Cir. 2024) — law.justia.com/.../ca5/23-50669/
- `[P]` OFAC JY0916 (8 Aug 2022) designation; JY1702 (Semenov); W.D. Tex. final judgment 29 Apr 2025
- `[S]` Sidley / Arnold & Porter / Mayer Brown / Ballard Spahr (Dec 2024) — holdings; Mayer Brown (Aug 2025) — Storm verdict

**1d. DeFi DAO parameter governance — ⚠️ negative empirics (concentration + SPOF).**
On-chain vote + timelock + often multisig guardian, but empirically concentrated; attackable (Beanstalk).
- `[P-academic]` **Fritsch, Müller & Wattenhofer (ETH Zürich, 2022), arXiv:2204.01176** — 8 delegates = 50% Compound, 11 Uniswap. *(= already cited as ref39 in the paper.)*
- `[P-academic]` arXiv:2407.10945 (Gini > 0.99 Aave/Compound/ENS/Uniswap); arXiv:2510.05830 (delegation amplifies concentration)
- `[P]` Compound v2 Governance docs (Governor Bravo + Timelock); `[S]` Immunefi, *Beanstalk Governance Attack* (2022)

### Point 2 — FATF mechanics (holds on enforcement-by-consequence; breaks on "no central operator"; + empirics dispute)

- **Legal status / soft law:** `[S]` Zerden (2022), *Demystifying the FATF* (Lawfare) — "unofficial market enforcement"; `[P-academic]` Nance (2017), *The regime that FATF built*, Crime Law Soc Change, DOI 10.1007/s10611-017-9747-6; `[S]` *FATF Recommendations: Becoming Soft Law* (Mich. J. Int'l Law online).
- **Mutual evaluation:** `[P]` FATF *2022 Methodology* (40 Recommendations + 11 Immediate Outcomes); `[P]` FATF *Mutual Evaluations* topic page.
- **Lists + consequence:** `[P-arch]` FATF grey list (22, 13 Feb 2026) + black list (Iran/DPRK/Myanmar); `[P-abs]` **IMF WP 2021/153** (−7.6% GDP, see A1).
- **De-risking / correspondent banking = the real channel:** `[P]` FSB Correspondent-Banking Data Reports (2017/2018) — CBR **−19.3%** 2011–2018; `[P]` World Bank de-risking reports (2018). ⚠️ no single BIS paper draws FATF-listing→CBR-loss directly; chain assembled from IMF + FSB + World Bank ("supported by convergent sources").
- **Centralization qualifier:** `[P-arch]` FATF Mandate paras 18–20 (Plenary = consensus decision body) + ICRG Procedures para 30 (recommendations "put to Plenary for decision"); FATF founded 1989 by G7.
- **Empirics dispute (cite BOTH):** `[P-abs]` IMF "large effect" vs `[P]` **Case-Ruchala & Nance 2024 (ISQ) "rational myth"/null** — finding-vs-finding (see A2). `[P-academic]` Kudrle, *Risks* 11(5):81 (2023, MDPI) corroborates a measurable cost (third voice).

### Point 3 — Prior art / novelty boundary

**KYA / KYC-for-agents = ALREADY OCCUPIED (do not claim novelty on this half):**
- `[P]` **Quadri (2026), "KYA: A Framework-Agnostic Trust Layer…", arXiv:2605.25376** — closest name+concept collision; "KYA = local provenance/policy", **no AML/FATF**. MUST cite + differentiate.
- `[P]` **Grogan (2025), "AgentFacts: Universal KYA Standard…", arXiv:2506.13794** — "Know Your Agent" in title; metadata verification.
- `[S]` Industry KYA (Entrust, Sumsub, kyabook.com, …) — 2025/26 marketing category.

**AML/FATF-governance-FOR-agents = GENUINE GAP — but flag the inversion:**
- The "agentic AML" literature runs the analogy **backwards** (agents *perform* AML: arXiv:2509.08380, 2509.11595). State the inversion explicitly: we govern agents *under* an AML-style regime.
- Honest caveat: gap claim rests on web-indexed search; a manual SSRN/HeinOnline/law-review pass is warranted before any hard "first" claim.

**Governance-model lineage (cite as the precedent that the move itself is legitimate):**
- `[P]` **Newmeyer (2011), "The FATF as a model for Internet governance", IEEE eCrime** — see A3. Keystone.
- `[S]` *Soft Organizations, Hard Powers: FATF & FSB as Standard-Setting Bodies*; `[S]` Thierer, *Soft Law for Hard Problems*.

**Closest rivals to differentiate:**
- `[P]` AgentCity / "From Logic Monopoly to Social Contract" — arXiv:2603.25100, 2604.07007 (constitutional/**judicial** governance — NOT soft-law/peer-pressure).
- `[P]` **Yan, Nardin, Hübner, Boissier (2024), "An Agent-Centric Perspective on Norm Enforcement and Sanctions", arXiv:2403.15128** — peers-sanction-peers, best MAS grounding for "distributed consequence".
- `[P]` Governance-as-a-Service, arXiv:2508.18765 (graduated enforcement, but centralized service); ERC-8004 (reputation, no enforcement). Ostrom graduated-sanctions/polycentric = political-economy twin of mutual evaluation.

---

## C. Trade-off Befund (the load-bearing honesty for the thesis)

- **Holds:** enforcement-by-distributed-consequence-without-a-central-police is real and precedented
  (FATF market-exclusion; Tornado-Cash contracts unstoppable). The **AML-for-agents** move is novel.
- **Breaks / must hedge:** "no central operator at all" is qualified at *every* precedent —
  FATF listing = centralized Plenary act (G7-origin); Chainalysis oracle = single-owner SPOF; DAOs =
  concentrated + multisig guardians; Tornado-Cash = liability relocated to identifiable persons.
- **The sharp trade-off (Tornado Cash shows it cleanest):** *either* immutable+unstoppable-but-ungovernable
  *or* governable-but-concentrated/SPOF. Every real precedent sits on one horn.
- **Implication (not yet written):** CEP's job is to show *how it resolves this trade-off better*
  (conditions-based, publicly recomputable activation), not to claim the trade-off is absent.
- **Empirics honesty:** the "consequence is materially real" premise is itself disputed (IMF vs ISQ).
  Do not lean the whole argument on the magnitude of FATF's economic effect.

---

## D. Differentiation pointers (for the writing phase, not prose)

1. vs Quadri/Grogan KYA: prior KYA = *local* verification/provenance; we extend to *network-wide
   enforcement governance* (KYC→AML analogy). 2. vs agentic-AML: they apply agents *to* AML; we apply an
   AML/FATF *model to* agents (inversion). 3. vs AgentCity/Social-Contract: they centralize adjudication
   (judicial/DAO); the FATF analogy is deliberately operator-less (mutual evaluation + refusal-to-deal).
   4. vs DAO governance (ref39): empirically concentrated → CEP's caps/5-AND are the response.

---

## E. Verification to-dos — ALL CLOSED (2026-06-11)

- **E1 ✅ CLOSED** — IMF table-level figures confirmed (Table 1: −7.550/−3.034/−2.926/−3.551, all 1% sig;
  double-selection lasso; 89 EMDCs, 2000–2017). See A1. *(Optional: re-pull from imf.org canonical before
  final submission to cite the official host rather than the mirror.)*
- **E2 ✅ CLOSED** — Newmeyer citation locked; DOI dead at CrossRef → cite IEEE Xplore URL. See A3.
- **E3 ✅ CLOSED** — grey list = 22 (13 Feb 2026), Plenary-centrality locked, no June-2026 supersede. See A4.
- **E4 ✅ CLOSED (gap firmed)** — deeper pass (Google Scholar/arXiv/SSRN/ACM/IEEE) found NO work making the
  AML/FATF-operator-less-enforcement-FOR-agents move. New adjacents to differentiate: **ETHOS, arXiv:2412.17114**
  (on-chain registry/DAO/soulbound revocation — central/cryptographic, not reputational-consequence);
  **Chaffer, "Know Your Agent…", SSRN 5162127** (identity governance); **Hülsse (2008)** on the AML blacklist
  (FATF-mechanism lineage). The "KYA extends FATF Travel Rule to agents" line = **vendor/blog only**
  (Captain Compliance/MetaComp), not peer-reviewed. **A bare "first" is NOT defensible** → use the agreed
  "to our knowledge, no prior work…" wording with an explicit closest-prior-work paragraph (Yan 2024 / AgentCity
  / KYA-identity / Newmeyer-Nance lineage).

---

## F. Candidate bib entries (NOT yet added to references.bib — for the writing phase)

`ref42_newmeyer` (IEEE eCrime 2011) · `ref43_imf_greylist` (Kida & Paetzold WP/21/153) ·
`ref44_caseruchala_nance` (ISQ 2024 sqae115) · `ref45_vanloon` (5th Cir. 2024) ·
`ref46_eas` (Ethereum Attestation Service docs) · `ref47_chainalysis_oracle` (Chainalysis sanctions oracle) ·
`ref48_yan_norms` (arXiv:2403.15128) · `ref49_quadri_kya` (arXiv:2605.25376) ·
`ref50_grogan_agentfacts` (arXiv:2506.13794) · `ref51_fsb_cbr` (FSB correspondent-banking data) ·
`ref52_fatf_mandate` (FATF Mandate/Plenary) · `ref53_nance_regime` (Crime Law Soc Change 2017) ·
`ref54_ethos` (arXiv:2412.17114, on-chain agent governance — differentiate) · `ref55_chaffer_kya`
(SSRN 5162127, KYA identity governance) · `ref56_hulsse` (Hülsse 2008, AML blacklist lineage).
*(ref38 Arbitrum, ref39 Fritsch-DAO, ref40 SybilGuard, ref41 BrightID already in references.bib.)*
