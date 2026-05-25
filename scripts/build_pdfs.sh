#!/bin/bash
# Reproducible PDF builds for MolTrust publications
# Usage: ./scripts/build_pdfs.sh [tech_spec|whitepaper|all]
#
# Env vars (override defaults):
#   TECH_SPEC_VERSION    (default: 0.8.1)
#   WHITEPAPER_VERSION   (default: 0.8)
#   BUILD_DATE           (default: current month, en-locale)
#
# Locale is forced to en_US for reproducible English output regardless
# of build host locale.
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

# Force English locale for deterministic month names
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Default date: current month in English (en-locale ensured above)
BUILD_DATE="${BUILD_DATE:-$(LC_ALL=en_US.UTF-8 date +'%B %Y')}"

build_tech_spec() {
  local version="$1"
  local out="docs/MolTrust_Protocol_TechSpec_v${version}.pdf"

  echo "Building TechSpec v${version} (${BUILD_DATE}) → ${out}"
  # Single-step via --pdf-engine=typst — the two-step
  # (pandoc --to typst → typst compile) loses pandoc's template helpers
  # (e.g. #horizontalrule) and fails. Single-step inlines them.
  pandoc TECH_SPEC.md \
    --pdf-engine=typst \
    --metadata=title:"The MolTrust Protocol: Technical Specification" \
    --metadata=subtitle:"Version ${version} — Draft for Review" \
    --metadata=author:"MolTrust / CryptoKRI GmbH, Zurich" \
    --metadata=date:"${BUILD_DATE}" \
    --metadata=lang:"en" \
    --variable=lang:"en" \
    --toc \
    --toc-depth=2 \
    -o "${out}"
  echo "  → $(ls -la "${out}" | awk '{print $5, $9}')"
}

build_whitepaper() {
  local version="$1"
  local out="docs/MolTrust_Protocol_Whitepaper_v${version}.pdf"

  echo "Building Whitepaper v${version} (${BUILD_DATE}) → ${out}"
  pandoc WHITEPAPER.md \
    --pdf-engine=typst \
    --metadata=title:"The MolTrust Protocol" \
    --metadata=subtitle:"Version ${version} — A Verification Standard for Autonomous Software Agents" \
    --metadata=author:"MolTrust / CryptoKRI GmbH, Zurich" \
    --metadata=date:"${BUILD_DATE}" \
    --metadata=lang:"en" \
    --variable=lang:"en" \
    --toc \
    --toc-depth=2 \
    -o "${out}"
  echo "  → $(ls -la "${out}" | awk '{print $5, $9}')"
}

case "${1:-all}" in
  tech_spec) build_tech_spec "${TECH_SPEC_VERSION:-0.8.1}" ;;
  whitepaper) build_whitepaper "${WHITEPAPER_VERSION:-0.8}" ;;
  all)
    build_tech_spec "${TECH_SPEC_VERSION:-0.8.1}"
    build_whitepaper "${WHITEPAPER_VERSION:-0.8}"
    ;;
  *) echo "Usage: $0 [tech_spec|whitepaper|all]"; exit 1 ;;
esac
