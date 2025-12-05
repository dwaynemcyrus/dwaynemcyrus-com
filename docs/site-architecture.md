# Site Architecture — dwaynemcyrus.com
>**Version:** 1.1**Last Updated:** December 2025**Project Type:** AI Design Engineer Portfolio + Lab + Digital Garden (with future Membership)
This document defines how the site is structured today and how it will evolve into a digital garden and member space. It’s a living spec.

# Table of Contents
1 Project Overview
2 Tech Stack
3 Site Architecture & Routes
4 Content Types & Collections
5 Database & Membership Model (Future)
6 Core Features
7 Project Structure
8 Security & Performance
9 Build Phases

⠀
# 1\. Project Overview
### Vision
A public-facing **AI Design Engineer** site that:
* Showcases serious engineering work (projects, systems, tools).
* Exposes the **Lab**: R&D, experiments, engines, exploratory work.
* Gradually grows into a **digital garden** of interconnected notes, essays, and artifacts.
* Long-term: supports a **membership layer** for deeper content, tools, and personal OS features.

⠀Core Principles
* **Clarity over spectacle** – content and structure first.
* **Ownership** – code, content, and data controlled by you.
* **Incremental complexity** – ship a clean V1, then layer in garden + membership.
* **Wiki-thinking** – notes, lab entries, essays and projects cross-link.
* **Single brain, many surfaces** – portfolio, lab, writing, garden all draw from the same underlying thinking.

⠀Audience
* **Visitors** – see portfolio, lab highlights, public writing.
* **Followers / subscribers (future)** – get updates, more context.
* **Members (future)** – deeper content, experiments, tools, and OS features.

⠀
# 2\. Tech Stack
### Frontend
* **Astro 5.x**
  * Current: static pages + content collections.
  * Islands: React/TSX where needed (interactions, dashboards later).
* **React (islands only)** for:
  * Filters, galleries, dashboards, habit trackers, comments (future).
* **TypeScript**
  * Strict config, used from now on for components and logic.
* **Styling**
  * Start simple (CSS or minimal utility classes).
  * Tailwind CSS is allowed in a later pass if/when it pays off.

⠀Backend & Data (Planned, not V1)
* **Supabase**
  * PostgreSQL + Auth.
  * Row Level Security (RLS) for member data.
  * Tables for posts, comments, habits, goals, images, wiki_links, etc.
* **Stripe**
  * Subscription management for paid membership.
* **MailerLite or similar**
  * Newsletter + onboarding flows.

⠀Deployment & Tooling
* **GitHub** – repo + version control.
* **Vercel** – hosting, SSR for auth flows, edge functions later.
* **Remark/Rehype plugins** – markdown pipeline (wiki-links, GFM, etc.).

⠀
# 3\. Site Architecture & Routes
The current site is an **AI Engineer portfolio** with CV, Projects, and Lab. The digital garden spec extends this with more sections and a future member 
area.
### Route Map
### /
### ├── /                       (Home – AI Design Engineer landing)
### │
### ├── /cv                     (CV – print-friendly)
### │
### ├── /projects               (Projects index – content collection)
### │   └── /projects/[slug]    (Project case studies)
### │
### ├── /lab                    (Lab index – experiments & engines)
### │   └── /lab/[slug]         (Individual lab experiment)
### │
### ├── /writing                (Essays / notes – optional in V1)
### │   └── /writing/[slug]
### │
### ├── /garden                 (Global digital garden index – V2+)
### │   └── /garden/[slug]      (Atomic note – wiki-linked)
### │
### ├── /archives               (Media/archives index – V2+)
### │   └── /archives/[category]/[slug]
### │
### ├── /galleries              (Image galleries – V2+)
### │   └── /galleries/[category]
### │
### ├── /town-hall              (Community posts – V3+)
### │   └── /town-hall/[slug]
### │
### ├── /guestbook              (Public guestbook – V3+)
### │
### ├── /members                (Member area – V3+)
### │   ├── /members/dashboard
### │   ├── /members/content
### │   └── /members/account
### │
### ├── /auth                   (Auth flows – V3+)
### │   ├── /auth/login
### │   ├── /auth/signup
### │   ├── /auth/reset-password
### │   └── /auth/callback
### │
### ├── /about                  (Optional narrative page)
### └── /contact                (Email link or simple form)
### How this differs from the pure Digital Garden doc
* **Your spine remains**: /, /cv, /projects, /lab.
* **Digital garden concepts** are layered on:
  * /writing and /garden instead of putting everything under /garden.
  * Lab stays distinct: R&D, experiments, engines.
* **Membership / town hall / habits** are explicitly **later phases**.

⠀
# 4\. Content Types & Collections
Astro Content Collections drive all content surfaces. These mirror your current plan (Projects + Lab) but borrow from the digital garden structure where 
useful.
### 4.1 Projects —src/content/projects
**Purpose:** Serious engineering work, interfaces, systems, and tools.
**Schema:**
* title – string
* slug – string
* summary – string
* date – date
* status – planned | active | shipped | archived
* tags – string[]
* role – string (e.g. “Solo”, “Lead”, “Contributor”)
* techStack – string[]
* featured – boolean
* heroImage – string (optional)
* repoUrl – string (optional)
* liveUrl – string (optional)
* body – markdown case study

⠀4.2 Lab — src/content/lab
**Purpose:** Experiments, engines, prototypes, explorations, field notes.
**Schema:**
* title – string
* slug – string
* question – string (framing question)
* description – string
* status – draft | active | archived
* date – date (optional)
* tags – string[] (optional)
* cover – string (optional)
* outcomeYouCareAbout – string
* findings – string (optional)
* memberOnly – boolean (for future gating)
* body – markdown, field-note style

⠀4.3 Writing — src/content/writing (V1 optional)
**Purpose:** Essays, arguments, technical notes, philosophy.
**Schema:**
* title – string
* slug – string
* summary – string
* date – date
* tags – string[]
* featured – boolean
* memberOnly – boolean (future)
* body – markdown

⠀4.4 Garden Notes — src/content/garden (V2+)
**Purpose:** Smaller, more atomic notes forming the “digital garden graph”.
**Schema:**
* title – string
* slug – string
* date – date
* tags – string[] (optional)
* draft – boolean (default false)
* memberOnly – boolean (default false)
* body – markdown, heavy on wiki-links ([[Like this]])

⠀Notes can link to projects, lab entries, archives, etc.
### 4.5 Archives & Galleries —src/content/archives (V2+)
**Purpose:** Photography, visual archives, sketches, or structured series.
**Schema (flexible):**
* title – string
* slug – string
* category – string (e.g. “photography”, “sketches”)
* year – number (optional)
* tags – string[]
* coverImage – string
* images – array of image identifiers/paths or references
* body – markdown (contextual text)

⠀4.6 Town Halls & Member Content (V3+)
May live in **content collections** or primarily in **Supabase posts**:
* town-hall collection (optional) mirrors posts table.
* Member-only posts can be gated via auth and is_member_only flags.

⠀
# 5\. Database & Membership Model (Future)
When Supabase comes in, the filesystem content stays primary for long-form work. The DB handles:
* Auth & profiles
* Member status
* Comments
* Guestbook
* Habits/goals
* Image metadata
* Wiki link index

⠀Key Tables (Conceptual)
* profiles
  * Tied to Supabase auth.users.
  * Fields: email, name, avatar, subscription_status, tier, stripe ids, timestamps.
* posts
  * Represents town halls, member content, maybe some garden notes mirror.
  * Fields: slug, title, content_type (town-hall, member-content, etc.), is_member_only, is_published, tags, metadata, etc.
* comments
  * Threaded comments for posts (public/time-gated + member-only).
* guestbook_entries
  * Public guestbook messages (with moderation flag).
* images
  * Storage path (Supabase Storage), Cloudinary ref (if used), category, tags, metadata.
* habits, habit_logs, goals
  * Power the personal OS / habit + goal tracker as a member feature.
* wiki_links
  * Source slug, target slug, link_text.
  * Used for backlinks and potential graph visualizations.

⠀All tables use **RLS** to ensure users only see their stuff when appropriate and public content is safe to expose.

# 6\. Core Features
### 6.1 Wiki-Links (Obsidian-style) – V2+
Goal: [[Wiki-style links]] work across garden, writing, lab, and (optionally) projects.
* Use a **remark plugin** chain to:
  * Parse [[Link]], [[Link|Custom Text]], [[note#Heading]], etc.
  * Resolve to correct routes:
    * Garden note: /garden/[slug]
    * Project: /projects/[slug]
    * Lab: /lab/[slug]
    * Writing: /writing/[slug]
  * Tag broken links for later content creation.
* Optionally store wiki-link relationships in Supabase in wiki_links for:
  * Backlinks in templates.
  * Future graph views.

⠀6.2 Image Galleries – V2+
* Original uploads: **Supabase Storage**.
* Delivery: Cloudinary (or similar) for optimization and transforms.
* In Astro:
  * Query images (from DB or frontmatter).
  * Render grid + lightbox (PhotoSwipe or minimal custom).

⠀6.3 Lab System (Now)
* /lab index:
  * Cards showing: title, question, status, tags.
* /lab/[slug] detail:
  * Headline question.
  * Outcome you care about.
  * Field notes + findings.
  * Links to related projects, garden notes, or writing.
* This is your primary R&D surface and should feel like **live research**, not polished marketing.

⠀6.4 Town Hall (V3+)
* /town-hall – archive of community posts.
* /town-hall/[slug] – individual town hall.
* Comment window:
  * Public comments for a time window.
  * Afterwards, only members view/comment.
* Backed by posts + comments tables and possibly scheduled edge functions for “closing soon” emails.

⠀6.5 Habits & Goals (V4+)
* Member-only **personal OS**: habits, goals, progress.
* Tabs or widgets under /members/dashboard.
* Powered by habits, habit_logs, goals tables.

⠀6.6 Guestbook (V3+)
* Simple page at /guestbook.
* Shows recent messages.
* Authenticated users can sign.

⠀6.7 Membership System (V3+)
* Tier: **Free** vs **Member**.
* Stripe Checkout + Webhook → Supabase profiles.subscription_status.
* Gating rules:
  * Some lab entries, writing, garden notes, town halls, and archives marked memberOnly.
  * Frontend checks auth + profile status.

⠀
# 7\. Project Structure (Astro)
Baseline structure, aligned with how your current site is set up, expanded for the garden:
### /
### ├── astro.config.mjs
### ├── package.json
### ├── tsconfig.json
### ├── src/
### │   ├── pages/
### │   │   ├── index.astro
### │   │   ├── cv.astro
### │   │   ├── projects/
### │   │   │   ├── index.astro
### │   │   │   └── [slug].astro
### │   │   ├── lab/
### │   │   │   ├── index.astro
### │   │   │   └── [slug].astro
### │   │   ├── writing/            (V1 optional)
### │   │   ├── garden/             (V2+)
### │   │   ├── archives/           (V2+)
### │   │   ├── galleries/          (V2+)
### │   │   ├── town-hall/          (V3+)
### │   │   ├── guestbook.astro     (V3+)
### │   │   ├── members/            (V3+)
### │   │   ├── auth/               (V3+)
### │   │   ├── about.astro         (optional)
### │   │   └── contact.astro       (optional)
### │   │
### │   ├── layouts/
### │   │   ├── BaseLayout.astro
### │   │   ├── PageLayout.astro
### │   │   ├── CollectionLayout.astro
### │   │   ├── ArticleLayout.astro
### │   │   └── LabExperimentLayout.astro
### │   │
### │   ├── components/
### │   │   ├── Nav.astro
### │   │   ├── Footer.astro
### │   │   ├── ProjectCard.astro
### │   │   ├── LabCard.astro
### │   │   ├── TagPill.astro
### │   │   ├── SectionHeader.astro
### │   │   ├── Callout.astro
### │   │   ├── Gallery/*           (V2+)
### │   │   ├── Comments/*          (V3+)
### │   │   └── Members/*           (V3+)
### │   │
### │   └── content/
### │       ├── config.ts
### │       ├── projects/
### │       ├── lab/
### │       ├── writing/
### │       └── garden/
### └── ...

# 8\. Security & Performance
* Start: fully static, no user data → low risk, fast.
* As Supabase + auth come in:
  * Enforce RLS on all private tables.
  * Use JWT-based auth from Supabase client in islands.
* Performance:
  * Keep the majority of the site static.
  * Only hydrate where necessary (filters, dashboards, comments).
  * Use image optimization (Cloudinary or Astro’s image tools).

⠀
# 9\. Build Phases
### Phase 1 — Current / Immediate
* New Astro v5 repo in Cursor.
* Implement:
  * /, /cv, /projects, /projects/[slug], /lab, /lab/[slug].
* Set up content collections: projects, lab, writing (optional).
* Base layout, collection layouts, cards, typography.

⠀Phase 2 — Digital Garden Layer
* Add garden collection + /garden routes.
* Wire up remark plugins for wiki-links.
* Add backlinks component (filesystem-only; DB optional).

⠀Phase 3 — Membership & Community
* Introduce Supabase + Stripe.
* Implement /auth, /members, /town-hall, /guestbook.
* Gate selected lab, writing, garden pieces by memberOnly.
* Comments on town halls and member content.

⠀Phase 4 — Personal OS
* Add habits/goals tables + UI under /members/dashboard.
* Deeper integrations: dashboards, graphs, more advanced R&D surfaces.
`docs/site-architecture.md`
