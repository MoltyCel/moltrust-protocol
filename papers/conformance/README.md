# AAE Conformance Vectors

Conformance test vectors for the Agent Authorization Envelope (AAE) Internet-Draft
live in a standalone repository:

- Repository: https://github.com/MoltyCel/aae-conformance-vectors
- Release: [v1.0.0](https://github.com/MoltyCel/aae-conformance-vectors/releases/tag/v1.0.0)
- Tracks: [draft-kroehl-agentic-trust-aae-00](https://datatracker.ietf.org/doc/draft-kroehl-agentic-trust-aae/)
- License: Apache 2.0

The set holds 15 signed test vectors and a reference verifier that implements the
draft Section 5 verification algorithm (steps 1-9) and passes all 15. Each vector
pairs an input AAE (a JWS in compact serialization) with the expected verifier
result and a reference to the governing draft section.

An implementation claiming AAE conformance against draft-kroehl-agentic-trust-aae-00
should match every vector's `result` and, for rejections, the `verification_step`.

The reference verifier is the documented conformance pass. Production verifier
alignment with the draft is recorded in the repository's
[docs/CONFORMANCE.md](https://github.com/MoltyCel/aae-conformance-vectors/blob/main/docs/CONFORMANCE.md);
no production conformance pass is claimed in v1.0.0.
