# Website Scope & Phases
## 0. PURPOSE

Build a long-lived personal platform with:

* a calm, durable public canon
* a separate authenticated app for writing, control, monetization, and operations
* strong guarantees of sovereignty, portability, and safety
* Obsidian-like authoring with wiki-links across public, gated, and private content

The system must remain sane for 10+ years.

---

## 1. CORE ARCHITECTURE (FINAL)

### 1.1 Source of Truth

* Supabase is the single source of truth for all content
* All documents are authored, edited, and versioned here
---

### 1.2 Surfaces

#### Public Canon (Reader Surface)

* Domain: dwaynemcyrus.com
* Framework: Astro
* Purpose: reading, browsing, trust, SEO
* Characteristics:

  * static-first
  * no auth
  * no user state
  * no dashboards
  * minimal JS
* Input: public mirror repo (Markdown)
* Output: rendered HTML pages

Public sections include:

* /library
* /lab
* /artist
* /engineer
* /mentor
* /linked
* /newsletter
* /press
* /store (browse only)
* /resources
* /now
* /contact
* /colophon
* /imprint
* /privacy

Public pages may read comments only.

---

#### App / Control Surface

* Domain: app.dwaynemcyrus.com
* Framework: Next.js
* Purpose: doing, not reading
* Responsibilities:

  * Supabase auth (magic links)
  * CMS for all content
  * memberships & patronage
  * Voyagers mentorship portals
  * comment posting & moderation
  * store checkout & digital delivery
  * personal dashboards (OKRs, habits, journals)
  * backend for future iOS app
---

## 2. REPOSITORIES (FINAL)

### Repo A — Site Code (Private)

* Astro public site
* No authored content

### Repo V — Vault Repo (Private, All Markdown)

* Obsidian-style vault
* Contains ALL markdown:

  * public
  * gated
  * private
* Organized by collections, not visibility
* Visibility controlled via frontmatter
* Used for:

  * wiki-link resolution
  * offline access
  * sovgnty backup
* Never authoritative

### Repo P — Public Mirror Repo

* Generated export only
* Contains:

  * visibility: public
  * status: published
* Safe build input for Astro
* Can be deleted and regenerated at any time
---

## 3. CONTENT MODEL (LOCKED)

### 3.1 Documents (Supabase)

All content lives in Supabase.

Each document has:

* id (ULID, required, permanent)
* title
* slug
* aliases[]
* collection
* visibility

* (public, members, patron, voyagers_lodge, voyagers_rite, voyagers_forge, voyagers_1t, private)
* status (draft, published, archived)
* canonical (required only for public+published)
* redirect_from[] (optional)
* body_md
* metadata (tags, summary, hero, etc.)
* timestamps

### 3.2 Version Control

* document_versions table
* Append-only snapshots
* Git is not used for private or gated versioning
---

## 4. CANONICAL URL RULES (FINAL)

* Canonical = the permanent public URL
* Human-readable (never ID-based)
* Required only for public + published docs
* IDs are internal identity, not public URLs
* Title/slug can change without breaking canonical
* Redirects handle canonical changes if needed
---

## 5. WIKI-LINK SUPPORT (LOCKED)

### Authoring Syntax

* Obsidian-style wiki-links:

  * [[Title]]
  * [[Title|Alias]]
  * [[Title#Section]]
* GitHub Flavored Markdown supported

### Resolution Order

1. Title (normalized)
2. Alias
3. Slug
4. ID (internal fallback)

⠀
### Linking Behavior

* Public target → canonical URL
* Gated/private target → app.dwaynemcyrus.com/doc/<id>

A global link index is generated from Supabase / vault.

---

## 6. CONTENT FLOWS (FINAL)

### 6.1 Authoring

```
App → Supabase (documents + versions)
```

### 6.2 Vault Mirror

```
Supabase → Vault Repo (all markdown)
```

### 6.3 Public Publishing

```
Supabase → Vault Repo → Public Mirror Repo → Astro Build → dwaynemcyrus.com
```

Conditions:

* default-deny export
* must be visiust be status: published
* must have valid canonical
* allowlisted canonical paths only
---

## 7. STORE (LOCKED)

### Public Store

* dwaynemcyrus.com/store
* product pages
* storytelling
* SEO
* no checkout

### App Store

* app.dwaynemcyrus.com/store
* Stripe checkout
* digital delivery via Supabase Storage
* purchase history
* entitlements/licenses

### Product Types

* Digital products (priority)
* Print-on-demand (external fulfillment)

Store purchases ≠ memberships.

---

## 8. MEMBERSHIP & PORTALS

### Patronage

* /members/*
* Stripe subscriptions
* entitlements:

  * members
  * patron

### Voyagers

* /portal/*
* tiered entitlements:

  * yagers_lodge
  * voyagers_rite
  * voyagers_forge
  * voyagers_1to1
* optional cohorts
---

## 9. COMMENTS MODEL

* Public pages: read-only
* Members/clients: post via app
* Moderation in app
* Comments keyed by canonical URL
---

## 10. PERSONAL DASHBOARDS

* /dashboard/* (app)
* Owner-only
* OKRs
* habits
* journals
* reviews
* metrics
---

## 11. LOCAL VAULT (OBSIDIAN-STYLE)

* Generated export from Supabase
* Markdown + YAML or md + json
* Includes:

  * personal
  * members
  * Voyagers
* Encrypted at rest
* Backup + offline access
* Not the editor of record
---

## 12. PHASED EXECUTION PLAN (STRICT)

### PHASE 0 — IA & Schema Lock

✔ Done

---

### PHASE 1 — Publishing Spine (CURRENT)

Goale publishing works end-to-end.

Build only:

1. Supabase project
2. documents + document_versions
3. Vault export
4. Public mirror export
5. Astro builds public canon
6. Vercel deploy loop

⠀
🚫 No auth

🚫 No CMS UI beyond minimal

🚫 No Stripe

🚫 No comments

🚫 No dashboards

---

### PHASE 2 — CMS UI (App Lite)

* Create/edit documents
* Set visibility/status
* T
---

### PHASE 3 — Auth & Roles

* Supabase magic links
* Admin / owner roles
* Route protection
---

### PHASE 4 — Patronage

* Stripe subscriptions
* Members area
* Gated content
---

### PHASE 5 — Voyagers Portal

* Tiered access
* Cohorts
* Portal content
---

### PHASE 6 — Comments

* Public read
* Member post
* Moderation
---

### PHASE 7 — Store

* Digital products
* Checkout
* Delivery
* POD integration later
---

### PHASE 8 — Dashboardhabits
* journals
* reviews
---

### PHASE 9 — Local Vault Sync
* Incremental sync
* Conflict handling
---
### PHASE 10 — iOS App
* Supabase auth
* Authoring/editing
* Offline-first later
---
## 13. NON-NEGOTIABLE RULES
1. Supabase is the source of truth
2. Git is never the editor
3. Public canon stays static-first
4. App owns complexity
5. One phase at a time
6. Default-deny exports
7. Human-readable canon URLs
8. IDs areernal only
---
## 14. CURRENT INSTRUCTION
We are in Phase 1 only.

Any AI assisting must:
* ignore future phases unless asked
* focus on schemas, exporters, and Astro build
* avoid adding auth, Stripe, comments, dashboards

