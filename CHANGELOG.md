# Changelog Template

---

## 2. CHANGELOG Template (`CHANGELOG.md`)

```md
# Changelog

All notable changes to this project will be documented in this file.

Format roughly follows [Keep a Changelog] style, but adapted for this project.

---

## [Unreleased]

### Added
- 

### Changed
- 

### Fixed
- 

---

## [0.1.0] – YYYY-MM-DD

**Status:** v0 – Foundation

### Added
- Initialized new Astro v5 project in a fresh repo.
- Added `docs/site-architecture.md` as the source of truth.
- Created basic layouts: `BaseLayout`, `PageLayout`.
- Set up initial routes:
  - `/` (placeholder home)
  - `/cv` (placeholder)
- Configured TypeScript and strict Astro settings.

### Changed
- 

### Fixed
- 

---

## [0.2.0] – YYYY-MM-DD

**Status:** v0 – Content Collections

### Added
- Defined Astro content collections:
  - `projects`
  - `lab`
  - `writing` (optional)
- Implemented:
  - `/projects` index + `[slug]` detail pages.
  - `/lab` index + `[slug]` experiment pages.
- Added shared components:
  - `Nav`
  - `Footer`
  - `ProjectCard`
  - `LabCard`
  - `TagPill`

### Changed
- Updated layout hierarchy to use `CollectionLayout` and `ArticleLayout`.

### Fixed
- 

---

## [0.3.0] – YYYY-MM-DD

**Status:** v0 – Migration & Copy

### Added
- Migrated core homepage copy from the previous site.
- Added first batch of project entries:
  - Thunder Recall
  - Voyager OS
  - Scriptorium
- Added first Lab experiments, each with:
  - `question`
  - `outcomeYouCareAbout`
  - field-note style body.

### Changed
- Tuned typography and layout for better readability.
- Updated navigation to reflect new sections.

### Fixed
- 

---

## [1.0.0] – YYYY-MM-DD

**Status:** v1 – Public Portfolio + Lab

### Added
- Stable, public-ready:
  - Home
  - CV
  - Projects
  - Lab
- Deployed to production (`dwaynemcyrus.com`).
- Documented versioning model and phases.

### Changed
- Refined information architecture and copy for clarity and positioning.

### Fixed
- Minor layout bugs and responsive issues.

---

[Unreleased]: https://github.com/<your-username>/<your-repo>/compare/v1.0.0...HEAD
[0.1.0]: https://github.com/<your-username>/<your-repo>/tree/v0.1.0
[0.2.0]: https://github.com/<your-username>/<your-repo>/tree/v0.2.0
[0.3.0]: https://github.com/<your-username>/<your-repo>/tree/v0.3.0
[1.0.0]: https://github.com/<your-username>/<your-repo>/tree/v1.0.0

