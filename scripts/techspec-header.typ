// TechSpec v0.9 layout hardening (pandoc --include-in-header). Optics only.
// Headings keep-with-next; table/figure bodies kept whole.
#show heading: set block(sticky: true)
#show figure: set block(breakable: false)
#show table: set block(breakable: false)
// Title-page logo in the true top-left page corner (full-page coords), page 1 only.
#set page(background: context {
  if here().page() == 1 {
    place(top + left, dx: 0.8cm, dy: 0.8cm, image("/scripts/assets/moltrust-logo.svg", width: 2cm))
  }
})
