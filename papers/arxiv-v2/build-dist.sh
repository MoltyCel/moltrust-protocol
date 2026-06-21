#!/usr/bin/env bash
# ============================================================================
# build-dist.sh — deterministic distribution build for arXiv-v2.
#
# Produces v2-paper-dist.pdf: the byte-frozen moltrust.ch distribution PDF that
# gets hashed (sha256) + anchored on Base L2 under Tag MolTrust/arXiv/v2.0.
# This is NOT the arXiv submit source (that is v2-paper.tex, biblatex+biber).
#
# Reproducibility (lesson from v1.0: LaTeX non-determinism made the v1.0 hash
# unreproducible). We pin every time-derived value via SOURCE_DATE_EPOCH so the
# PDF /CreationDate, /ModDate, trailer /ID and \today are byte-stable across runs.
#
# Toolchain (pin): TeX Live 2023/Debian, pdfTeX 3.141592653-2.6-1.40.25, bibtex
#                  (natbib path — the build host has no biblatex/biber).
# Run from the papers/arxiv-v2/ directory:  bash build-dist.sh
# ============================================================================
set -euo pipefail
cd "$(dirname "$0")"

# Fixed publication instant → deterministic PDF timestamps. Literal string input
# means the resulting epoch is identical on every run, on every host.
#   2026-06-14T00:00:00Z  ==  SOURCE_DATE_EPOCH 1781395200
export SOURCE_DATE_EPOCH="$(date -u -d '2026-06-14T00:00:00Z' +%s)"
export FORCE_SOURCE_DATE=1   # make pdftex apply SOURCE_DATE_EPOCH to \pdfcreationdate too

JOB=v2-paper-dist

pdflatex -interaction=nonstopmode -halt-on-error "$JOB.tex"
bibtex   "$JOB"
pdflatex -interaction=nonstopmode -halt-on-error "$JOB.tex"
pdflatex -interaction=nonstopmode -halt-on-error "$JOB.tex"

echo "=== build complete ==="
echo "SOURCE_DATE_EPOCH = $SOURCE_DATE_EPOCH"
sha256sum "$JOB.pdf"
