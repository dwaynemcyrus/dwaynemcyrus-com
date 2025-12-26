# Dwayne M. Cyrus Platform — Project Scope & Architecture

## 0. OVERVIEW

This document defines the complete architecture for Dwayne M. Cyrus's personal platform — a system for publishing, mentorship, and personal operations that must remain maintainable for 10+ years.

### 0.1 The Four Surfaces

| Domain | Framework | Purpose |
|--------|-----------|---------|
| `dwaynemcyrus.com` | Astro | Public canon — reading, SEO, trust, brand positioning |
| `app.dwaynemcyrus.com` | Next.js | Business operations — portal, billing, digital store, client interactions |
| `prints.dwaynemcyrus.com` | POD Platform | Art prints — physical products via print-on-demand |
| `getanchored.app` | TBD | Personal OS — all writing, habits, OKRs, journals, session prep |

### 0.2 Core Principles

1. **getanchored.app is canonical** for all authored content
2. **Git is the content repository** — markdown files, version history, portability
3. **Supabase is for operational data** — users, entitlements, session records, Q&A, orders
4. **Public canon stays static-first** — no auth, no user state, minimal JS
5. **App owns complexity** — auth, billing, client interactions
6. **One writing environment** — all content authored in Anchored, never in app.dwaynemcyrus.com

### 0.3 Brand Context

Dwayne M. Cyrus positions himself in the category of men's emotional mastery. The public site establishes authority and trust. The portal serves mentorship clients (Voyagers program). Anchored is the personal operating system that powers everything and will eventually become a client-facing product.

---

## 1. SYSTEM ARCHITECTURE

```
┌─────────────────────────────────────────────────────────────────────────┐
│                        getanchored.app                                  │
│                    (Personal OS / Canonical Vault)                      │
├─────────────────────────────────────────────────────────────────────────┤
│  ALL writing happens here:                                              │
│                                                                         │
│  Personal:          Content:             Mentorship:                    │
│  • Journals         • Articles           • Session prep                 │
│  • OKRs             • Resources          • Internal notes (private)     │
│  • Habits           • Announcements      • Client summaries             │
│  • Reviews          • Essays                                            │
│                                                                         │
│  Storage: Git vault (markdown) + private DB (encrypted personal data)  │
└─────────────────────────────────────────────────────────────────────────┘
                              │
            ┌─────────────────┼─────────────────┐
            ▼                 ▼                 ▼
     public-mirror      Supabase sync      Private (no sync)
     (filtered)         (operational)      (journals, OKRs, etc.)
            │                 │
            ▼                 ▼
┌───────────────────┐  ┌─────────────────────────────────────────────────┐
│ dwaynemcyrus.com  │  │            app.dwaynemcyrus.com                 │
│ (Public Canon)    │  │            (Business Operations)                │
├───────────────────┤  ├─────────────────────────────────────────────────┤
│ Astro static site │  │ Portal, Billing, Digital Store, Clients         │
│ Built from Git    │  │ Reads from Supabase + vault references          │
│ No auth needed    │  │ NO content authoring                            │
└───────────────────┘  └─────────────────────────────────────────────────┘
                              │
                              │ "Buy print" links
                              ▼
                       ┌─────────────────────────────────────────────────┐
                       │         prints.dwaynemcyrus.com                 │
                       │            (Print Store)                        │
                       ├─────────────────────────────────────────────────┤
                       │ POD platform storefront (Printful/Gelato)       │
                       │ Art prints, posters, merchandise                │
                       │ Fulfillment handled by platform                 │
                       └─────────────────────────────────────────────────┘
```

---

## 2. DOMAIN RESPONSIBILITIES

### 2.1 getanchored.app (Personal OS)

**Purpose:** Single environment for all of Dwayne's writing, thinking, and personal operations.

**Owns:**
- All markdown content (articles, resources, session materials)
- Personal data (journals, OKRs, habits, reviews)
- Session preparation and internal notes
- Client summaries (authored here, synced to portal)

**Outputs:**
- Git vault repository (all markdown)
- Syncs to Supabase (session summaries, announcements)
- Exports public-mirror for Astro builds

**Complete Sitemap:**

```
/                               ← Dashboard / home
│
├─ /login
├─ /logout
├─ /auth/callback
│
├─ /write                       ← Content authoring
│  ├─ /new                      ← New document
│  ├─ /[id]                     ← Edit document
│  └─ /drafts                   ← Work in progress
│
├─ /vault                       ← Browse all content
│  ├─ /engineer/*
│  ├─ /mentor/*
│  ├─ /artist/*
│  ├─ /labs/*
│  ├─ /library/*
│  ├─ /members/*
│  ├─ /mentorship/*
│  └─ /search                   ← Full-text search
│
├─ /sessions                    ← Session management
│  ├─ /upcoming                 ← Scheduled sessions
│  ├─ /past                     ← Session archive
│  ├─ /new                      ← Create session
│  └─ /[id]                     ← Session workspace
│     ├─ /prep                  ← Preparation notes
│     ├─ /notes                 ← Internal debrief (private)
│     └─ /summary               ← Client-facing summary
│
├─ /journal                     ← Private journaling
│  ├─ /daily                    ← Daily entries
│  │  └─ /[date]
│  ├─ /weekly                   ← Weekly reflections
│  │  └─ /[date]
│  └─ /prompts                  ← Journaling prompts
│
├─ /okrs                        ← Objectives & Key Results
│  ├─ /current                  ← Active quarter
│  ├─ /archive                  ← Past quarters
│  └─ /[quarter]                ← e.g., /2024-q1
│     └─ /[objective-id]
│
├─ /habits                      ← Habit tracking
│  ├─ /today                    ← Daily check-in
│  ├─ /streaks                  ← Streak overview
│  └─ /manage                   ← Add/edit habits
│
├─ /reviews                     ← Periodic reviews
│  ├─ /weekly
│  │  └─ /[date]
│  ├─ /monthly
│  │  └─ /[month]
│  ├─ /quarterly
│  │  └─ /[quarter]
│  └─ /annual
│     └─ /[year]
│
├─ /sync                        ← Vault sync controls
│  ├─ /status                   ← Sync status
│  ├─ /publish                  ← Trigger public-mirror export
│  └─ /history                  ← Sync log
│
├─ /settings                    ← App settings
│  ├─ /profile
│  ├─ /integrations             ← Git, Supabase connections
│  └─ /preferences
│
└─ /clients                     ← Future: client access
   ├─ /[client-id]
   │  ├─ /journal
   │  ├─ /habits
   │  └─ /goals
   └─ /overview                 ← Coach dashboard
```

**Notes:**
- All routes require authentication (owner-only initially)
- `/vault/*` mirrors Git vault structure for browsing/editing
- `/sessions/*` creates content in `vault/mentorship/sessions/`
- `/journal`, `/okrs`, `/habits`, `/reviews` are private (never synced to Git)
- `/clients/*` is placeholder for future SaaS functionality

**Key Features:**
- Markdown editor with wiki-link support
- Habit tracking and OKR management
- Session management (prep, notes, summaries)
- Content promotion workflow
- Git commit on save

**Future:** Becomes a SaaS product for clients after dogfooding.

---

### 2.2 dwaynemcyrus.com (Public Canon)

**Purpose:** Static public website for reading, SEO, and brand authority.

**Characteristics:**
- Static-first (Astro)
- No authentication
- No user state or dashboards
- Minimal JavaScript
- Human-readable canonical URLs

**Complete Sitemap:**

```
/                           ← Home
│
├─ /engineer                ← Engineering identity
│  ├─ /philosophy
│  ├─ /projects
│  │  └─ /[slug]
│  │     ├─ /releases
│  │     └─ /roadmap
│  ├─ /cv
│  └─ /engagement
│
├─ /mentor                  ← Mentorship identity
│  ├─ /voyagers             ← Program overview
│  ├─ /path                 ← The journey/methodology
│  ├─ /engagement           ← How to work together
│  └─ /application          ← Apply to join
│
├─ /artist                  ← Artist identity
│  ├─ /statement
│  ├─ /work
│  │  ├─ /visual
│  │  │  └─ /[slug]
│  │  └─ /poetry
│  │     └─ /[slug]
│  ├─ /practice
│  │  ├─ /everydays         ← Daily creative practice
│  │  │  └─ /[slug or date]
│  │  └─ /poetry
│  │     └─ /[slug or date]
│  └─ /exhibitions
│
├─ /labs                    ← Experiments & explorations
│  ├─ /software
│  │  └─ /[slug]
│  │     ├─ /changelog
│  │     └─ /roadmap
│  ├─ /visual
│  │  └─ /[slug]
│  └─ /systems
│     └─ /[slug]
│
├─ /library                 ← Collected writings (all public)
│  ├─ /directives
│  │  └─ /[slug]
│  ├─ /principles
│  │  └─ /[slug]
│  ├─ /fragments
│  │  └─ /[slug]
│  ├─ /field-notes          ← Curated notes
│  │  └─ /[slug]
│  └─ /downloads            ← Public PDFs, resources
│     └─ /[slug]
│
├─ /newsletter
│  ├─ /subscribe
│  └─ /archive
│     └─ /[slug]
│
├─ /linked                  ← Curated links/bookmarks
│  └─ /[slug]
│
├─ /press
│  ├─ /appearances
│  │  └─ /[slug]
│  ├─ /writing              ← External publications
│  │  └─ /[slug]
│  └─ /assets               ← Press kit, logos, photos
│
├─ /store                   ← Product browsing (checkout via app)
├─ /resources               ← Public resources
├─ /now                     ← Current focus
├─ /colophon                ← Site credits
├─ /contact                 ← Contact information
├─ /imprint                 ← Legal
├─ /privacy                 ← Privacy policy
│
├─ /login                   ← Redirect to app.dwaynemcyrus.com/login
└─ /logout                  ← Redirect to app.dwaynemcyrus.com/logout
```

**Notes:**
- All content on dwaynemcyrus.com is public
- Members-only content (dispatches, audio, private archive) lives on app.dwaynemcyrus.com
- `/login` and `/logout` are 301 redirects to the app, keeping the public site static

**Input:** Public-mirror Git repository (filtered export from vault)

**Build Trigger:** Git push to public-mirror triggers Vercel deploy

---

### 2.3 app.dwaynemcyrus.com (Business Operations)

**Purpose:** Authenticated operations — portal, billing, store, client interactions.

**Owns:**
- User authentication (Supabase magic links)
- Entitlements and access control
- Stripe billing and subscriptions
- Store checkout and digital delivery
- Client Q&A and feedback (operational records)
- Comment moderation

**Does NOT Own:**
- Content authoring (that's Anchored's job)
- Session content (reads from vault via Supabase references)

**Portal Features:**
- Announcements (synced from Anchored)
- Resources (synced from Anchored)
- Sessions (displays prep/summary from vault)
- Q&A (clients ask questions, Dwayne responds)
- Feedback notes (private to each client)
- Uploads (client submissions for review)

**Complete Sitemap:**

```
/                           ← Dashboard / home (authenticated)
│
├─ /login                   ← Magic link auth
├─ /logout
├─ /auth/callback           ← OAuth callback
│
├─ /portal                  ← Voyagers mentorship portal
│  ├─ /announcements
│  ├─ /resources
│  ├─ /sessions
│  │  └─ /[id]
│  ├─ /questions
│  │  └─ /[id]
│  ├─ /feedback
│  └─ /uploads
│
├─ /members                 ← General membership area
│  ├─ /archive              ← Members-only content index
│  │  └─ /[slug]
│  ├─ /dispatches           ← Craig Mod-style letters
│  │  └─ /[slug]
│  ├─ /audio                ← Audio letters / broadcasts
│  │  └─ /[slug]
│  └─ /downloads            ← Members-only downloads
│     └─ /[slug]
│
├─ /content                 ← Gated content viewer
│  └─ /[id]                 ← View any gated document by ID
│
├─ /store                   ← Checkout & purchases
│  ├─ /cart
│  ├─ /checkout
│  └─ /purchases
│     └─ /[id]
│
├─ /subscribe               ← Subscription management
│  ├─ /success
│  └─ /cancel
│
├─ /account                 ← User account
│  ├─ /billing
│  └─ /settings
│
├─ /documents               ← CMS (owner only)
│  ├─ /new
│  └─ /[id]
│
├─ /api                     ← API routes
│  ├─ /checkout
│  └─ /webhooks
│     └─ /stripe
│
└─ /unauthorized            ← Access denied page
```

**Notes:**
- All routes require authentication except `/login`, `/auth/callback`, and `/unauthorized`
- `/members/*` contains content exclusive to paid subscribers
- `/portal/*` contains Voyagers mentorship features
- `/documents/*` is owner-only CMS access
- `/content/[id]` renders any gated document by its ULID

**Key Principle:** This surface displays and manages operational data. All substantive content originates in Anchored.

---

## 3. CONTENT MODEL

### 3.1 Content Types and Locations

| Content Type | Authored In | Stored In | Synced To | Visible In |
|--------------|-------------|-----------|-----------|------------|
| Articles, essays | Anchored | Git vault | Public-mirror (if public) | dwaynemcyrus.com |
| Resources | Anchored | Git vault | Supabase (metadata) | Portal |
| Announcements | Anchored | Git vault | Supabase | Portal |
| Session prep | Anchored | Git vault | Supabase (reference) | Portal (selective) |
| Session notes (internal) | Anchored | Private DB | None | Anchored only |
| Session summary | Anchored | Git vault | Supabase | Portal |
| Q&A responses | Portal | Supabase | Vault (if promoted) | Portal |
| Feedback notes | Portal | Supabase | Vault (if promoted) | Portal |
| Journals | Anchored | Private DB | None | Anchored only |
| OKRs, habits | Anchored | Private DB | None | Anchored only |

### 3.2 Document Schema (Git Vault)

All markdown documents in the vault include YAML frontmatter:

```yaml
---
id: 01HQ3K5V7X... (ULID, permanent identifier)
title: Document Title
slug: document-slug (optional, for URL generation)
aliases: [] (alternative titles for wiki-link resolution)
collection: engineer | mentor | artist | labs | library | members | newsletter | linked | press | mentorship | pages
visibility: public | members | patron | voyagers | group | community | armory | private
status: draft | published | archived
canonical: /library/document-slug (required for public + published)
redirect_from: [] (old URLs that should redirect here)
tiers: [] (for gated content: group, community, armory, patron, members)
tags: []
summary: Brief description
date: 2024-01-15 (publication or event date)
hero: /images/hero.jpg (optional hero image)
---

Document content in markdown...
```

**Collection Reference:**

| Collection | Description | Default Visibility |
|------------|-------------|-------------------|
| `engineer` | Engineering identity content | public |
| `mentor` | Mentorship philosophy & program info | public |
| `artist` | Creative work and practice | public |
| `labs` | Experiments (software, visual, systems) | public |
| `library` | Collected writings (directives, principles, etc.) | public |
| `members` | Subscriber-exclusive content | members |
| `newsletter` | Newsletter archive | public |
| `linked` | Curated links/bookmarks | public |
| `press` | Appearances and external writing | public |
| `mentorship` | Portal content (sessions, resources, Q&A) | voyagers |
| `pages` | Static pages (now, contact, etc.) | public |

### 3.3 Visibility Levels

| Visibility | Who Can Access | Where Displayed |
|------------|----------------|-----------------|
| `public` | Everyone | dwaynemcyrus.com |
| `members` | Any paid subscriber | Portal |
| `patron` | Patron tier | Portal |
| `voyagers` | Any Voyagers tier | Portal |
| `group` | Group coaching tier | Portal |
| `community` | Community tier | Portal |
| `armory` | Armory tier | Portal |
| `private` | Owner only | Anchored |

### 3.4 Version Control

**Git Vault:**
- All markdown commits create version history
- Portable and inspectable
- Supports branching for drafts if needed

**Supabase (document_versions table):**
- Append-only snapshots for operational documents
- Used for content synced to Supabase
- Tracks who made changes and when

---

## 4. DATA ARCHITECTURE

### 4.1 Git Vault Structure

The vault mirrors the public site's information architecture plus private/gated content:

```
vault/
│
├── engineer/                       ← Engineering identity
│   ├── philosophy.md
│   ├── cv.md
│   ├── engagement.md
│   └── projects/
│       └── [project-slug]/
│           ├── index.md
│           ├── releases.md
│           └── roadmap.md
│
├── mentor/                         ← Mentorship identity
│   ├── voyagers.md
│   ├── path.md
│   ├── engagement.md
│   └── application.md
│
├── artist/                         ← Artist identity
│   ├── statement.md
│   ├── work/
│   │   ├── visual/
│   │   │   └── [slug].md
│   │   └── poetry/
│   │       └── [slug].md
│   ├── practice/
│   │   ├── everydays/
│   │   │   └── [date-or-slug].md
│   │   └── poetry/
│   │       └── [date-or-slug].md
│   └── exhibitions.md
│
├── labs/                           ← Experiments
│   ├── software/
│   │   └── [slug]/
│   │       ├── index.md
│   │       ├── changelog.md
│   │       └── roadmap.md
│   ├── visual/
│   │   └── [slug].md
│   └── systems/
│       └── [slug].md
│
├── library/                        ← Collected writings (public)
│   ├── directives/
│   │   └── [slug].md
│   ├── principles/
│   │   └── [slug].md
│   ├── fragments/
│   │   └── [slug].md
│   ├── field-notes/
│   │   └── [slug].md
│   └── downloads/
│       └── [slug].md
│
├── members/                        ← Members-only content (gated)
│   ├── archive/
│   │   └── [slug].md
│   ├── dispatches/
│   │   └── [slug].md
│   ├── audio/
│   │   └── [slug].md
│   └── downloads/
│       └── [slug].md
│
├── newsletter/
│   └── archive/
│       └── [slug].md
│
├── linked/                         ← Curated links
│   └── [slug].md
│
├── press/
│   ├── appearances/
│   │   └── [slug].md
│   └── writing/
│       └── [slug].md
│
├── mentorship/                     ← Portal content (synced to Supabase)
│   ├── resources/
│   │   └── [slug].md
│   ├── announcements/
│   │   └── [date]-[title].md
│   ├── sessions/
│   │   └── [date]-[type]-[topic]/
│   │       ├── prep.md
│   │       ├── notes.md            ← Private, not in Git (Anchored DB)
│   │       └── summary.md
│   ├── answers/                    ← Promoted from Q&A
│   │   └── [slug].md
│   └── feedback/                   ← Promoted from portal
│       └── [slug].md
│
├── pages/                          ← Static pages
│   ├── now.md
│   ├── contact.md
│   ├── colophon.md
│   ├── resources.md
│   ├── imprint.md
│   └── privacy.md
│
└── _index/                         ← Generated indexes (optional)
    ├── links.json                  ← Wiki-link resolution index
    └── tags.json                   ← Tag aggregation
```

**Collection → URL Mapping:**

| Vault Path | Public URL | Visibility |
|------------|------------|------------|
| `engineer/projects/foo/` | `/engineer/projects/foo` | public |
| `library/principles/bar.md` | `/library/principles/bar` | public |
| `members/dispatches/baz.md` | `app.../members/dispatches/baz` | members |
| `mentorship/sessions/...` | `app.../portal/sessions/[id]` | voyagers |

### 4.2 Supabase Schema

#### Users and Auth

```sql
-- Managed by Supabase Auth
-- Users authenticate via magic link
```

#### Entitlements

```sql
entitlements
  - id: uuid
  - user_id: uuid (references auth.users)
  - tier: text (group | community | armory | patron | members)
  - active: boolean
  - expires_at: timestamptz (nullable)
  - created_at: timestamptz
  - updated_at: timestamptz
```

#### Documents (Synced from Vault)

```sql
documents
  - id: text (ULID, matches vault frontmatter)
  - title: text
  - slug: text (nullable)
  - collection: text (nullable)
  - visibility: text
  - status: text
  - canonical: text
  - tiers: text[] (nullable)
  - vault_path: text (path in Git vault)
  - body_md: text (nullable, for quick access)
  - metadata: jsonb
  - created_at: timestamptz
  - updated_at: timestamptz
```

#### Portal Sessions

```sql
portal_sessions
  - id: uuid
  - title: text
  - session_type: text (1v1 | group | community)
  - audience: text (tier name or 'all')
  - user_id: uuid (nullable, for 1v1 sessions)
  - starts_at: timestamptz
  - recording_url: text (nullable)
  - vault_path: text (path to session folder in vault)
  - summary_md: text (synced from vault summary.md)
  - summary_visible: boolean (toggle display in portal)
  - created_at: timestamptz
  - updated_at: timestamptz
```

#### Portal Q&A

```sql
portal_questions
  - id: uuid
  - user_id: uuid (who asked)
  - title: text
  - body_md: text
  - status: text (open | answered | closed)
  - audience: text (tier of the asker)
  - created_at: timestamptz

portal_responses
  - id: uuid
  - question_id: uuid (references portal_questions)
  - body_md: text
  - promoted_to_vault: boolean
  - vault_path: text (nullable, set after promotion)
  - created_at: timestamptz
```

#### Portal Feedback

```sql
portal_feedback
  - id: uuid
  - user_id: uuid (nullable, for individual feedback)
  - tier: text (nullable, for tier-wide feedback)
  - title: text
  - body_md: text
  - promoted_to_vault: boolean
  - vault_path: text (nullable)
  - created_at: timestamptz
```

#### Portal Announcements (Synced from Vault)

```sql
portal_announcements
  - id: uuid
  - vault_path: text
  - title: text
  - body_md: text
  - audience: text (tier or 'all')
  - published_at: timestamptz (nullable)
  - created_at: timestamptz
```

#### Portal Resources (Synced from Vault)

```sql
portal_resources
  - id: uuid
  - vault_path: text
  - title: text
  - description: text (nullable)
  - resource_type: text (link | file | document)
  - url: text (nullable)
  - file_path: text (nullable)
  - audience: text
  - created_at: timestamptz
```

#### Store (Future)

```sql
products
  - id: uuid
  - title: text
  - description: text
  - price_cents: integer
  - product_type: text (digital | pod)
  - stripe_product_id: text
  - created_at: timestamptz

orders
  - id: uuid
  - user_id: uuid
  - product_id: uuid
  - stripe_payment_intent_id: text
  - status: text
  - created_at: timestamptz
```

#### Stripe Customers

```sql
stripe_customers
  - id: uuid
  - user_id: uuid
  - stripe_customer_id: text
  - created_at: timestamptz
```

---

## 5. CONTENT FLOWS

### 5.1 Public Publishing Flow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Anchored   │───►│  Git Vault   │───►│ Public-Mirror│───►│  Astro Build │
│   (author)   │    │  (all docs)  │    │  (filtered)  │    │              │
└──────────────┘    └──────────────┘    └──────────────┘    └──────────────┘
                                                                   │
                                                                   ▼
                                                          ┌──────────────┐
                                                          │dwaynemcyrus  │
                                                          │    .com      │
                                                          └──────────────┘
```

**Export Criteria for Public-Mirror:**
- `visibility: public`
- `status: published`
- Has valid `canonical` URL
- Canonical path is on the allowlist

**Process:**
1. Author/edit document in Anchored
2. Commit to Git vault
3. Export script filters for public + published
4. Writes to public-mirror repository
5. Git push triggers Vercel build
6. Astro renders static HTML

### 5.2 Portal Content Flow

```
┌──────────────┐    ┌──────────────┐    ┌──────────────┐
│   Anchored   │───►│  Git Vault   │───►│   Supabase   │
│   (author)   │    │              │    │   (sync)     │
└──────────────┘    └──────────────┘    └──────────────┘
                                               │
                                               ▼
                                        ┌──────────────┐
                                        │    Portal    │
                                        │  (display)   │
                                        └──────────────┘
```

**Synced Content Types:**
- Announcements → `portal_announcements`
- Resources → `portal_resources`
- Session summaries → `portal_sessions.summary_md`

**Sync Trigger:** Git webhook or scheduled job

### 5.3 Session Lifecycle Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                            BEFORE SESSION                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. Create session folder in Anchored:                                  │
│     vault/mentorship/sessions/2024-01-15-armory-group/                 │
│                                                                         │
│  2. Write prep.md:                                                      │
│     - Agenda                                                            │
│     - Topics to cover                                                   │
│     - Exercises planned                                                 │
│     - Resources to reference                                            │
│                                                                         │
│  3. Session record created in Supabase (portal_sessions)               │
│     - vault_path set to session folder                                  │
│     - summary_visible: false                                            │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                            DURING SESSION                               │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Session happens (live or recorded)                                     │
│  Recording URL added to Supabase record if applicable                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                            AFTER SESSION                                │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  4. Write notes.md (INTERNAL - NEVER SYNCED):                          │
│     - Raw observations                                                  │
│     - Progress notes                                                    │
│     - Private assessments                                               │
│     - Ideas for next session                                            │
│     Stored in Anchored private DB, linked by vault_path                │
│                                                                         │
│  5. Write summary.md (CLIENT-FACING):                                  │
│     - Key takeaways                                                     │
│     - Action items                                                      │
│     - Resources referenced                                              │
│     - Encouragement                                                     │
│                                                                         │
│  6. Sync summary to Supabase:                                          │
│     - summary_md populated from summary.md                              │
│     - summary_visible: true                                             │
│                                                                         │
│  7. Client sees summary in Portal                                       │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.4 Q&A and Feedback Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                         CLIENT ASKS QUESTION                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  1. Client submits question via Portal                                  │
│     → Stored in portal_questions                                        │
│     → Status: open                                                      │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────────┐
│                         DWAYNE RESPONDS                                 │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  2. Dwayne writes response in Portal                                    │
│     → Stored in portal_responses                                        │
│     → Question status: answered                                         │
│                                                                         │
│  3. Decision point:                                                     │
│                                                                         │
│     QUICK REPLY (operational):                                          │
│     - "Check resource X"                                                │
│     - "We'll discuss Tuesday"                                           │
│     → Stays in Supabase only                                            │
│     → promoted_to_vault: false                                          │
│                                                                         │
│     SUBSTANTIVE ANSWER (valuable content):                              │
│     - Detailed technique explanation                                    │
│     - Reusable wisdom                                                   │
│     → Click [Promote to Vault]                                          │
│     → Opens form: title, tags, visibility                               │
│     → Commits to vault/mentorship/answers/                              │
│     → promoted_to_vault: true                                           │
│     → vault_path set                                                    │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

### 5.5 Content Promotion Flow

```
┌─────────────────────────────────────────────────────────────────────────┐
│                      [PROMOTE TO VAULT] ACTION                          │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  Triggered from: Q&A response, Feedback note, or any operational text  │
│                                                                         │
│  1. User clicks [Promote to Vault] in Portal                           │
│                                                                         │
│  2. Form appears:                                                       │
│     - Title (pre-filled from context)                                   │
│     - Collection (mentorship/answers, mentorship/feedback, etc.)       │
│     - Tags                                                              │
│     - Visibility (usually 'private' or tier-specific)                  │
│                                                                         │
│  3. On submit:                                                          │
│     - Generate ULID                                                     │
│     - Create markdown file with frontmatter                             │
│     - Commit to Git vault                                               │
│     - Update Supabase record:                                           │
│       → promoted_to_vault: true                                         │
│       → vault_path: path to new file                                    │
│                                                                         │
│  4. Content now lives in vault:                                         │
│     - Versioned in Git                                                  │
│     - Searchable in Anchored                                            │
│     - Can be further edited                                             │
│     - Can be re-published if valuable                                   │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## 6. WIKI-LINK SUPPORT

### 6.1 Authoring Syntax

Obsidian-style wiki-links are supported throughout:

```markdown
[[Document Title]]
[[Document Title|Display Text]]
[[Document Title#Section]]
```

### 6.2 Resolution Order

1. Title (normalized, case-insensitive)
2. Alias (from frontmatter `aliases` array)
3. Slug
4. ID (internal fallback)

### 6.3 Link Rendering

| Target Visibility | Rendered URL |
|-------------------|--------------|
| `public` | `https://dwaynemcyrus.com{canonical}` |
| Gated (`members`, `patron`, etc.) | `https://app.dwaynemcyrus.com/content/{id}` |
| `private` | Internal Anchored link only |

### 6.4 Link Index

A global link index is generated from the vault to enable:
- Wiki-link resolution at build time
- Broken link detection
- Backlink generation

---

## 7. CANONICAL URL RULES

1. **Canonical = permanent public URL** (e.g., `/library/emotional-mastery-guide`)
2. **Human-readable, never ID-based** for public content
3. **Required only for public + published** documents
4. **IDs are internal** — used for database references, not public URLs
5. **Title/slug can change** without breaking canonical
6. **Redirects handle changes** via `redirect_from` frontmatter

---

## 8. AUTHENTICATION & AUTHORIZATION

### 8.1 Auth Provider

Supabase Auth with magic links (passwordless email).

### 8.2 User Roles

| Role | Description | Access |
|------|-------------|--------|
| `owner` | Dwayne (identified by email) | Everything |
| `member` | Paid subscriber | Members content |
| `patron` | Patron tier subscriber | Patron + members content |
| `group` | Group coaching client | Group + Voyagers content |
| `community` | Community tier | Community + Voyagers content |
| `armory` | Armory tier | Armory + Voyagers content |
| `voyager` | Any Voyagers tier | Base Voyagers content |

### 8.3 Entitlement Checking

```typescript
// Pseudocode for access control
const hasAccess = (user, document) => {
  if (document.visibility === 'public') return true;
  if (!user) return false;
  if (isOwner(user)) return true;

  const userTiers = getActiveTiers(user);
  const requiredTiers = document.tiers || [document.visibility];

  if (requiredTiers.includes('all')) {
    return userTiers.length > 0;
  }

  return userTiers.some(tier => requiredTiers.includes(tier));
};
```

---

## 9. STORE MODEL

The store is split by fulfillment type across three surfaces:

```
dwaynemcyrus.com/store              → Showcase/landing (links to both stores)
app.dwaynemcyrus.com/store          → Digital products (Stripe checkout)
prints.dwaynemcyrus.com             → Art prints (POD platform storefront)
```

### 9.1 Public Store Landing (dwaynemcyrus.com/store)

- Showcase page with product categories
- SEO-optimized product storytelling
- No checkout — routes users to appropriate store:
  - "Digital Products" → app.dwaynemcyrus.com/store
  - "Art Prints" → prints.dwaynemcyrus.com

### 9.2 Digital Store (app.dwaynemcyrus.com/store)

- **Products:** Workbooks, templates, courses, guides
- **Checkout:** Stripe
- **Delivery:** Instant via Supabase Storage
- **Features:**
  - Purchase history
  - License/entitlement management
  - Member discounts (tied to entitlements)
  - Re-download access

### 9.3 Print Store (prints.dwaynemcyrus.com)

- **Products:** Art prints, posters, merchandise
- **Platform:** POD service storefront (Printful, Gelato, or similar)
- **Fulfillment:** POD handles printing, shipping, returns
- **Setup:** DNS subdomain pointing to POD platform
- **Integration:** Linked from `/artist/work/*` pages

### 9.4 Why Split Stores

| Concern | Digital (app.dwaynemcyrus.com) | Prints (prints.dwaynemcyrus.com) |
|---------|-------------------------------|----------------------------------|
| Fulfillment | Instant download | Physical shipping |
| Margin | ~100% | ~30-50% after POD costs |
| Audience | Mentorship clients | Art collectors |
| Infrastructure | Your code + Stripe | POD platform (turnkey) |
| Returns | N/A | POD handles |

### 9.5 Product Flow from Public Site

```
/artist/work/visual/[slug]     → "Buy print" → prints.dwaynemcyrus.com/[product]
/mentor/voyagers               → "Get workbook" → app.dwaynemcyrus.com/store/[product]
/store                         → Landing with both paths
```

**Note:** Store purchases are separate from memberships. Buying a product does not grant tier access.

---

## 10. MEMBERSHIP & PORTAL TIERS

### 10.1 Patronage (General Membership)

- Path: `/members/*`
- Stripe subscriptions
- Tiers: `members`, `patron`

### 10.2 Voyagers (Mentorship Program)

- Path: `/portal/*`
- Tiered coaching program
- Tiers: `group`, `community`, `armory`, `patron`
- Optional cohort groupings

### 10.3 Tier Hierarchy

```
patron (highest)
   ↓
armory
   ↓
community
   ↓
group
   ↓
members (base paid tier)
   ↓
(free/unauthenticated)
```

Higher tiers include access to all lower tier content.

---

## 11. COMMENTS MODEL

- **Public pages (dwaynemcyrus.com):** Read-only comment display
- **Members/clients:** Post comments via app
- **Moderation:** Handled in app.dwaynemcyrus.com
- **Keyed by:** Canonical URL (links comments across surfaces)

---

## 12. PERSONAL OPERATIONS (ANCHORED)

These features live in getanchored.app and are private to the owner (initially):

### 12.1 Journals

- Daily/weekly entries
- Private, never synced to Git
- Stored in Anchored's encrypted database

### 12.2 OKRs (Objectives & Key Results)

- Quarterly objectives
- Measurable key results
- Progress tracking

### 12.3 Habits

- Daily habit tracking
- Streaks and analytics

### 12.4 Reviews

- Weekly, monthly, quarterly, annual reviews
- Reflection templates

### 12.5 Future: Client Access

When Anchored becomes a product, clients will have their own:
- Journals
- Habit tracking
- Goal setting
- Progress visible to coach (Dwayne) if permitted

---

## 13. REPOSITORIES

### Repo: dwaynemcyrus-com (Private)

- Astro public site code
- No authored content (reads from public-mirror)
- Deployment config

### Repo: dwaynemcyrus-app (Private)

- Next.js app code
- Portal, billing, store logic
- No authored content

### Repo: vault (Private)

- All markdown content
- Organized by collection
- Visibility controlled via frontmatter
- Source for public-mirror export

### Repo: public-mirror (Can be public)

- Generated export only
- Contains only `visibility: public` + `status: published`
- Safe build input for Astro
- Deletable and regeneratable

### Repo: getanchored-app (Private)

- Anchored application code
- Personal OS functionality

---

## 14. TECHNOLOGY STACK

| Surface | Framework | Hosting | Database |
|---------|-----------|---------|----------|
| dwaynemcyrus.com | Astro | Vercel | None (static) |
| app.dwaynemcyrus.com | Next.js | Vercel | Supabase |
| prints.dwaynemcyrus.com | POD Platform | Printful/Gelato | Managed by platform |
| getanchored.app | TBD | TBD | Supabase + local |

### Shared Services

- **Supabase:** Auth, PostgreSQL, Storage, Realtime
- **Stripe:** Payments, subscriptions (digital products)
- **Git:** Content versioning, CI/CD triggers
- **Vercel:** Hosting, edge functions
- **POD Platform:** Print fulfillment, shipping, returns (Printful, Gelato, or similar)

---

## 15. PHASED EXECUTION PLAN

### Phase 0 — IA & Schema Lock ✓

- Architecture defined
- Content model locked
- This document

### Phase 1 — Publishing Spine

**Goal:** Public publishing works end-to-end.

- [ ] Supabase project setup
- [ ] Documents + document_versions tables
- [ ] Vault repository structure
- [ ] Public-mirror export script
- [ ] Astro builds from public-mirror
- [ ] Vercel deploy pipeline

**Not included:** Auth, CMS UI, Stripe, comments

### Phase 2 — CMS UI (App Lite)

- [ ] Basic document editor in app
- [ ] Create/edit/delete documents
- [ ] Visibility and status controls
- [ ] Manual trigger for vault sync

### Phase 3 — Auth & Roles

- [ ] Supabase magic link auth
- [ ] Owner role detection
- [ ] Route protection
- [ ] Entitlements table

### Phase 4 — Patronage

- [ ] Stripe subscription integration
- [ ] Members area in portal
- [ ] Gated content access
- [ ] Billing management

### Phase 5 — Voyagers Portal

- [ ] Tiered access (group, community, armory, patron)
- [ ] Session management
- [ ] Q&A system
- [ ] Feedback notes
- [ ] Cohort support

### Phase 6 — Comments

- [ ] Public read on dwaynemcyrus.com
- [ ] Member posting via app
- [ ] Moderation interface

### Phase 7 — Store

- [ ] Product catalog
- [ ] Stripe checkout
- [ ] Digital delivery
- [ ] Purchase history
- [ ] POD integration (later)

### Phase 8 — Anchored MVP

- [ ] Markdown authoring with wiki-links
- [ ] Git commit on save
- [ ] Session prep workflow
- [ ] Internal notes (private)
- [ ] Vault sync to Supabase

### Phase 9 — Personal Operations

- [ ] Journals
- [ ] OKR tracking
- [ ] Habit tracking
- [ ] Reviews

### Phase 10 — Content Promotion

- [ ] Promote to Vault from Portal
- [ ] Vault export improvements
- [ ] Backlink support

### Phase 11 — Local Vault Sync

- [ ] Incremental sync to local
- [ ] Conflict handling
- [ ] Offline access

### Phase 12 — Anchored Product

- [ ] Multi-user support
- [ ] Client onboarding
- [ ] Coach visibility features
- [ ] Billing for Anchored

### Phase 13 — iOS App

- [ ] Supabase auth
- [ ] Authoring/editing
- [ ] Offline-first (later)

---

## 16. NON-NEGOTIABLE RULES

1. **getanchored.app is canonical** for all authored content
2. **Git is the content repository** — versioned, portable, owned
3. **Supabase is for operational data** — not the source of truth for content
4. **Public canon stays static-first** — Astro, no runtime auth
5. **App owns complexity** — auth, billing, client interactions
6. **One phase at a time** — don't skip ahead
7. **Default-deny exports** — content is private unless explicitly published
8. **Human-readable canonical URLs** — never expose IDs publicly
9. **IDs are internal only** — ULIDs for database, not URLs
10. **No content authoring in app.dwaynemcyrus.com** — that's Anchored's job

---

## 17. GLOSSARY

| Term | Definition |
|------|------------|
| **Anchored** | getanchored.app — the personal OS and canonical content source |
| **Vault** | Git repository containing all markdown content |
| **Public-mirror** | Filtered export of public+published content for Astro |
| **Canon** | The public website (dwaynemcyrus.com) |
| **Portal** | Client-facing area in app.dwaynemcyrus.com |
| **Voyagers** | Mentorship program with tiered access |
| **Tier** | Access level (group, community, armory, patron, members) |
| **Promote** | Action to move operational content into the vault |
| **Wiki-link** | Obsidian-style `[[link]]` syntax |
| **Canonical URL** | Permanent public URL for a document |
| **Entitlement** | User's access rights based on subscription/tier |

---

## 18. CHANGE LOG

| Date | Change |
|------|--------|
| 2024-XX-XX | Initial architecture (Supabase as source of truth) |
| 2024-XX-XX | Revised: getanchored.app as canonical, three-surface model |

---

*This document is the authoritative reference for platform architecture. All implementation decisions should align with the principles and flows defined here.*
