# Versioning Guidelines (drop into docs/versioning.md)
# Versioning Guidelines

This repo follows a simple, practical versioning model:

- **v0.x.y** — Pre-1.0. Architecture, foundations, first features.
- **v1.x.y** — Public portfolio + lab stable.
- **v2.x.y** — Digital garden layer stable.
- **v3.x.y** — Membership + auth stable.
- **v4.x.y** — Personal OS (habits/goals/dashboard) stable.

We’re not doing strict Semantic Versioning; we’re doing **milestone-based versioning** aligned with the site’s evolution.

---

What Deserves a Version Bump?
**MAJOR**
* New phase (v0 → v1 → v2 → v3 → v4).
* Architecture changes that break existing routes/components meaningfully.

⠀**MINOR**
* New section or feature (e.g. /writing launch, /garden filters, basic backlinks).
* New components that change the experience noticeably.

⠀**PATCH**
* Bug fixes.
* Typo/copy corrections.
* Minor visual polish or refactors that don’t change behavior.


---

## 1. Version Format

`MAJOR.MINOR.PATCH`

- **MAJOR**  
  Big structural/feature phase shift (v0 → v1, v1 → v2, etc.).
- **MINOR**  
  New features, content types, UX improvements that don’t break the overall architecture.
- **PATCH**  
  Bug fixes, copy fixes, visual polish, small refactors.

Examples:

- `0.1.0` – Initial Astro scaffold + basic layouts.
- `0.2.0` – Content collections (projects, lab, writing) added.
- `1.0.0` – First public-ready portfolio + lab.
- `2.0.0` – Digital garden (`/garden`) launched.

---

## 2. Phase Definitions

### v0.x — Foundation

Goal: Set up the system and get a working internal version.

Includes:
- Astro v5 project scaffolded.
- Base layout system (`BaseLayout`, `PageLayout`, `CollectionLayout`, `ArticleLayout`, `LabExperimentLayout`).
- Content collections for `projects`, `lab`, `writing`.
- Basic routes (`/`, `/cv`, `/projects`, `/lab`).

`1.0.0` is only possible when:
- Home, CV, projects, and lab are stable.
- Site is deployable and coherent for external viewers.

---

### v1.x — Portfolio + Lab

The site can be shared publicly as your **AI Design Engineer + Lab** hub.

Includes:
- Solid `projects` and `lab` content.
- Clean navigation, typography, and responsive layout.
- Initial writing allowed, but not required.

`2.0.0` happens when:
- Digital garden features (`/garden` + wiki-links) are live and coherent.

---

### v2.x — Digital Garden

Digital garden is first-class:

- `/garden` exists and is usable.
- Wiki-links (`[[like this]]`) work between notes and optionally projects/lab/writing.
- Backlinks visible somewhere (even in a primitive way).

`3.0.0` happens when:
- Membership + auth are integrated and working.

---

### v3.x — Membership + Auth

Includes:
- Supabase auth + profiles.
- Stripe subscriptions.
- `/members` area.
- Gated content working (lab entries, writing, garden notes, town halls if present).

`4.0.0` happens when:
- Habits/goals dashboard is functional and stable.

---

### v4.x — Personal OS

Includes:
- Habits, goals, logs, dashboards under `/members`.
- Stable enough for daily personal use.

---

## 3. Tagging & Releases

When you hit a meaningful version bump:

1. Update `CHANGELOG.md`.
2. Update any version references in:
   - `package.json` (optional; use if you want).
   - `docs/versioning.md` (if relevant).
3. Create a git tag:

```bash
git tag v1.0.0
git push origin v1.0.0


