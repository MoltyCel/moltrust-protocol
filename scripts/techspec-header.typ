// TechSpec v0.9 layout hardening (injected via pandoc --include-in-header).
// Content-neutral: affects pagination/optics only, not text.

// Keep every heading with the content that follows it — no orphan heading
// stranded at the bottom of a page (Typst 0.12+ block "sticky" = keep-with-next).
#show heading: set block(sticky: true)

// Keep tables (and table/image figures) together — no page break through a table.
// Verified: the tallest table in the document is 22 rows (~15 cm) < one page, so
// breakable:false never clips; at worst a table shifts wholesale to the next page.
#show figure: set block(breakable: false)
#show table: set block(breakable: false)

// Title-page logo: top-left, dezent, explicit 2 cm width (the SVG declares
// width=512 but viewBox 0 0 72 72 — explicit width avoids deriving from 512px).
// Implemented as a FIRST-PAGE-ONLY page header so it lands on the title page
// without creating a stray blank page (a bare top-level #place before pandoc's
// `conf` does create one). conf sets only page margin/numbering, not `header`,
// so this survives. `place` inside the header is out-of-flow → no header height
// reserved on pages > 1, and the gate keeps it to page 1 only.
#set page(header: context {
  if here().page() == 1 {
    place(top + left, dx: 0pt, dy: 4pt, image("/scripts/assets/moltrust-logo.svg", width: 2cm))
  }
})
