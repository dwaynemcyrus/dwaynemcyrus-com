# Publishing Spine (Phase 1)

This spec defines the Phase 1 export pipeline from Supabase to a public mirror that Astro can build from.
Phase 1 is strictly public, published content only.

## Scope
- No auth
- No comments
- No Stripe
- No dashboards
- Only public + published documents

## Source Tables
- `documents` (current state)
- `document_versions` is ignored in Phase 1

## Export Rules (Default-Deny)
Export a document only if all of the following are true:
- `visibility = 'public'`
- `status = 'published'`
- `canonical` is present and non-empty
- `canonical` is allowlisted (Phase 1: `/lab/` or `/projects/`)

## Output Target
- Public mirror repo or folder
- One markdown file per exported document

## Folder Structure
- `lab` collection: `/lab/{filename}.md`
- `projects` collection: `/projects/{filename}.md`

## Filename Rules
- `filename = slug ?? canonical tail`
- Normalize to lowercase
- Replace spaces with `-`
- Strip any leading or trailing `/`

## Frontmatter Mapping
All frontmatter values should use double quotes.

Required:
- `id`
- `title`
- `canonical`
- `body_md` (as body, not frontmatter)

Optional:
- `slug`
- `collection`
- `visibility`
- `status`
- `redirect_from`
- `summary` (from `metadata.summary`)
- `tags` (from `metadata.tags`)
- `tiers` (from `tiers` array)
- `date` (from `metadata.date` or `created_at`)

## Body
- `body_md` is output as-is (GFM allowed)

## Redirects
- `redirect_from` remains in frontmatter for future use

## Logging
Exporter outputs:
- total scanned
- total exported
- total skipped, with reason per skip

## Example Output
```md
---
id: "01J8Q5ZB1Z5JQ9N3FZ3QJ2Z9A1"
title: "Hello Canon"
slug: "hello-canon"
collection: "lab"
visibility: "public"
status: "published"
canonical: "/lab/hello-canon"
redirect_from: []
summary: "First test document."
tags: []
tiers: []
date: "2025-12-01"
---

# Hello Canon

This is the first public document.
```

## Minimal Exporter Script Outline
1. Connect to Supabase using a service role key.
2. Query `documents` with the Phase 1 filters.
3. Validate required fields; skip if invalid.
4. Derive output path from `collection` + `slug` or `canonical`.
5. Build frontmatter + body markdown.
6. Write files into the public mirror folder.
7. Print a summary report (exported/skipped).
