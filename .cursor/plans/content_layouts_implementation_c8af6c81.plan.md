---
name: Content Layouts Implementation
overview: Build out the five core layout components (BaseLayout, PageLayout, CollectionLayout, ArticleLayout, LabExperimentLayout) as specified in the architecture, following the site's styling and code conventions.
todos:
  - id: global-styles
    content: Create src/styles/global.css with typography, layout utilities, and basic reset
    status: completed
  - id: base-layout
    content: Create BaseLayout.astro with HTML structure, head metadata, and nav/footer slots
    status: completed
    dependencies:
      - global-styles
  - id: page-layout
    content: Create PageLayout.astro as simple wrapper for static pages
    status: completed
    dependencies:
      - base-layout
  - id: collection-layout
    content: Create CollectionLayout.astro for collection index pages with header and content slots
    status: completed
    dependencies:
      - base-layout
  - id: article-layout
    content: Create ArticleLayout.astro with article header (title, date, tags) and body content slot
    status: completed
    dependencies:
      - base-layout
  - id: lab-layout
    content: Create LabExperimentLayout.astro with question, outcome, status, and field notes sections
    status: completed
    dependencies:
      - base-layout
---

# Build Content Layouts

Implement the five layout components specified in [docs/site-architecture.md](docs/site-architecture.md) that will serve as the foundation for all pages across the site.

## Layouts to Create

1. **BaseLayout.astro** - Foundation layout with HTML structure, head metadata, navigation/footer slots
2. **PageLayout.astro** - Simple page wrapper for static pages like `/cv`, `/about`, `/contact`
3. **CollectionLayout.astro** - For collection index pages like `/projects`, `/lab`
4. **ArticleLayout.astro** - For article detail pages like `/projects/[slug]`, `/writing/[slug]`
5. **LabExperimentLayout.astro** - Specialized layout for lab experiments at `/lab/[slug]`

## Implementation Details

### BaseLayout.astro

- HTML document structure with semantic elements
- Head section with configurable title, description, and metadata
- Slots for header/navigation and footer (placeholder components for now)
- Main content slot
- Basic responsive viewport setup
- Global CSS import

### PageLayout.astro

- Wraps BaseLayout
- Simple centered content area
- Appropriate for CV, about, contact pages

### CollectionLayout.astro

- Wraps BaseLayout
- Header section for collection title and description
- Content slot for collection items (cards)
- Sidebar slot (optional) for filters/tags (future)

### ArticleLayout.astro

- Wraps BaseLayout
- Article header with title, date, tags, metadata
- Article body with markdown content
- Optional sidebar for related content or backlinks (future)

### LabExperimentLayout.astro

- Wraps BaseLayout
- Prominent "question" field at top
- "Outcome you care about" section
- Status badge (draft/active/archived)
- Findings section (optional)
- Field notes body content
- Different tone/design from standard articles

### Global Styles

- Create `src/styles/global.css` with:
  - CSS reset/normalize basics
  - Typography system (font stack, heading styles)
  - Basic layout utilities (container, spacing)
  - Responsive breakpoints
  - Focus on clarity and readability

## Code Conventions

- TypeScript strict mode
- Single quotes in JS/TS, double quotes in HTML attributes
- Semantic HTML structure
- Simple CSS (no Tailwind yet per architecture)
- Follow existing Astro component patterns

## File Structure

```
src/
├── layouts/
│   ├── BaseLayout.astro
│   ├── PageLayout.astro
│   ├── CollectionLayout.astro
│   ├── ArticleLayout.astro
│   └── LabExperimentLayout.astro
└── styles/
    └── global.css
```