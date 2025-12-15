# Content Submodule Setup

This document explains how the content submodule is configured and how to work with it.

## Structure

The content is stored in a git submodule at `src/content/` pointing to `git@github.com:dwaynemcyrus/knowledge.git`.

### Collections

The knowledge repo contains the following collections that map to Astro Content Collections:

- **essays/** → Essays collection (essays, articles, long-form writing)
- **notes/** → Notes collection (atomic notes for digital garden)
- **projects/** → Projects collection (project case studies)
- **references/** → References collection (reference materials, book notes, etc.)

### Configuration

The `src/content.config.ts` file defines the schemas for all collections. This file is tracked by the **main repo** (not the submodule) since it's part of the site code. This location follows Astro v5's Content Collections API convention.

## Setup Script

The `scripts/setup-ssh-and-submodules.sh` script handles:
- Initializing the submodule on first clone
- Updating submodules to latest versions
- Ensuring SSH access is configured

## Working with the Submodule

### Initial Setup

```bash
# Run the setup script
bash scripts/setup-ssh-and-submodules.sh
```

Or manually:
```bash
git submodule update --init --recursive
```

### Updating Content

```bash
# Update to latest from knowledge repo
cd src/content
git pull origin main
cd ../..

# Or update from main repo
git submodule update --remote src/content
```

### Adding/Editing Content

Content should be edited in the knowledge repo directly, not through the submodule. The submodule is read-only from this repo's perspective.

### Building

The build process automatically includes the submodule content. On Vercel, make sure to use the build command:
```bash
bash scripts/setup-ssh-and-submodules.sh && astro build
```

## Schema Matching

The content collections config (`src/content.config.ts`) matches the frontmatter structure used in the knowledge repo:

- **Essays**: cuid, date, title, tags, status, resources, etc.
- **Notes**: cuid, date, title, tags, source, chains (wiki-links)
- **Projects**: Flexible schema with passthrough for varying structures
- **References**: cuid, date, title, status, source, tags

## Future Considerations

- Wiki-link resolution (V2+) will work across all collections
- The submodule structure supports the "single brain, many surfaces" architecture
- Content can be versioned and maintained independently from the site code

