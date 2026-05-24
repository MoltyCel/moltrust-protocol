#!/bin/bash
# Reproducible PDF builds for MolTrust publications.
# Pipeline: pandoc → --pdf-engine=typst → PDF (single step).
# The two-step (`--to typst` then `typst compile`) loses pandoc's Typst
# template helpers (e.g. #horizontalrule) and breaks; do not split.
#
# Usage: ./scripts/build_pdfs.sh [tech_spec|whitepaper|all]
#   TECH_SPEC_VERSION=0.8.1 (default)
#   WHITEPAPER_VERSION=0.8 (default)
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

build_tech_spec() {
  local version="$1"
  local out="docs/MolTrust_Protocol_TechSpec_v${version}.pdf"
  echo "Building TechSpec v${version} → ${out}"
  pandoc TECH_SPEC.md \
    --pdf-engine=typst \
    --metadata=title:"The MolTrust Protocol: Technical Specification" \
    --metadata=subtitle:"Version ${version} — Draft for Review" \
    --metadata=author:"MolTrust / CryptoKRI GmbH, Zurich" \
    --metadata=date:"$(date +'%B %Y')" \
    --toc --toc-depth=2 \
    -o "${out}"
  echo "  → $(ls -la "${out}" | awk '{print $5, $NF}')"
}

build_whitepaper() {
  local version="$1"
  local out="docs/MolTrust_Protocol_Whitepaper_v${version}.pdf"
  echo "Building Whitepaper v${version} → ${out}"
  pandoc WHITEPAPER.md \
    --pdf-engine=typst \
    --metadata=title:"The MolTrust Protocol" \
    --metadata=subtitle:"Version ${version} — A Verification Standard for Autonomous Software Agents" \
    --metadata=author:"MolTrust / CryptoKRI GmbH, Zurich" \
    --metadata=date:"$(date +'%B %Y')" \
    --toc --toc-depth=2 \
    -o "${out}"
  echo "  → $(ls -la "${out}" | awk '{print $5, $NF}')"
}

case "${1:-all}" in
  tech_spec)  build_tech_spec "${TECH_SPEC_VERSION:-0.8.1}" ;;
  whitepaper) build_whitepaper "${WHITEPAPER_VERSION:-0.8}" ;;
  all)
    build_tech_spec  "${TECH_SPEC_VERSION:-0.8.1}"
    build_whitepaper "${WHITEPAPER_VERSION:-0.8}"
    ;;
  *) echo "Usage: $0 [tech_spec|whitepaper|all]"; exit 1 ;;
esac
