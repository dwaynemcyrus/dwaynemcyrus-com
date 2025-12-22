# Public Mirror Authoring Checklist (Phase 1)

Any document intended for public export must meet all of these:

## Required (export eligibility)
- `visibility = public`
- `status = published`
- `canonical` is non-empty
- `canonical` starts with an allowlisted prefix (see `docs/canonical-allowlist.md`)
- `body_md` is non-empty
- `title` is non-empty
- `id` is non-empty (ULID string)

## Recommended (frontmatter quality)
- `slug` (used for filename)
- `metadata.summary` (drives summary in frontmatter)
- `metadata.tags` (array)
- `metadata.date` (ISO date string)

## Common pitfalls
- `canonical` missing or not allowlisted → export skipped
- `body_md` containing literal `\n` instead of real newlines
