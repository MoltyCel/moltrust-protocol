# MolTrust Protocol

**A Verification Standard for Autonomous Software Agents**

The MolTrust Protocol defines a complete verification standard for autonomous software agents, built on W3C Decentralized Identifiers (DIDs) and Verifiable Credentials (VCs), with on-chain anchoring on Base L2.

## Documents

| Document | Version | SHA-256 | Base L2 Block |
|----------|---------|---------|---------------|
| [Whitepaper](./WHITEPAPER.md) | v0.4 | `80551caf...cf06829` | [43693580](https://basescan.org/block/43693580) |
| [Technical Specification](./TECH_SPEC.md) | v0.2.2 | `bd53e0e4...f5fa26` | [43693582](https://basescan.org/block/43693582) |

PDF versions are available in the [`docs/`](./docs/) folder and at [moltrust.ch/whitepaper](https://moltrust.ch/whitepaper.html).

## Three-Layer Architecture

1. **Protocol Standard** — W3C DID identity, credential issuance, lifecycle management, revocation
2. **Reference Registry** — ERC-8004 on-chain identity, credential anchoring on Base L2
3. **Reputation Model** — Swarm Intelligence trust propagation, anti-collusion mechanisms

## On-Chain Anchors

Both documents are permanently anchored on Base L2. The SHA-256 hash of each document is stored in the transaction calldata — tamper-evident, publicly verifiable, permanently immutable.

**Whitepaper v0.4**
- SHA-256: `80551caf6d96ca7ea52d00cce427fd79e148022e23be125a5c968b641cf06829`
- TX: [`0x1d1be1242c8c3fd2fe9403ab609f2e6861e496bdd0cf781a5fe38ff0d9217e4e`](https://basescan.org/tx/0x1d1be1242c8c3fd2fe9403ab609f2e6861e496bdd0cf781a5fe38ff0d9217e4e)
- Block: 43693580 | Timestamp: 2026-03-22T10:48:27 UTC

**Technical Specification v0.2.2**
- SHA-256: `bd53e0e428873984ce916df142e13862d06268e386d6ac700d486ead34f5fa26`
- TX: [`0x9beb79954801a6b32ef8e117ea578d1276649edfa953171441757744a2131161`](https://basescan.org/tx/0x9beb79954801a6b32ef8e117ea578d1276649edfa953171441757744a2131161)
- Block: 43693582 | Timestamp: 2026-03-22T10:48:31 UTC

## License

This work is licensed under [CC BY 4.0](./LICENSE).

## About

MolTrust is operated by CryptoKRI GmbH, Zurich, Switzerland.

- Website: [moltrust.ch](https://moltrust.ch)
- API: [api.moltrust.ch](https://api.moltrust.ch)
- X/Twitter: [@MolTrust](https://x.com/MolTrust)
