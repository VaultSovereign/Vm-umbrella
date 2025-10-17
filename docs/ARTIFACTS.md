CI Artifacts — Conventions

This umbrella recommends a standard set of CI artifacts across repos (inspired by vaultmesh-ai):

- build/ — compiled output (dist/, wheels/, binaries)
- docs/ — static site for GitHub Pages
- sbom.json — software bill of materials
- test-results/ — junit or similar
- coverage/ — coverage reports
- reports/ — additional JSON/markdown reports (lint, audit)

Guidelines

- Keep artifacts small and purposeful; attach to releases when relevant.
- Never commit build artifacts to the repo; use CI uploads and Releases.
- Prefer machine-readable (JSON) alongside human-readable (Markdown) reports.

See templates under templates/workflows for CI workflows that produce and publish these artifacts.

