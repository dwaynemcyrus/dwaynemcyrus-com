## Current
- [ ] setup the base template with components to the homepage

## Future
- [ ] In v6 of AstroJS `Astro.generator` is being deprecated.
- [ ] Investigate what other deprecated code has found their way into your current build

`git submodule update --remote`

***

## For the OS
- [ ] IF on capture the text gets moved into the body when a template is added where does the frontmatter show up in the document? At the top?
- [ ] Test inserting a template with command, is it on cursor? What frontmatter changes?

- [ ] Tests
  - [x] type [[ and confirm wikilink suggestions appear
  - [>] type # and confirm tag suggestions appear if matching tags exist
  - [ ] intentionally break a known field, for example workbench: maybe or tags: test, and confirm save is blocked with a clear error
  - [ ] check Supabase:
     - items.content stores body only after save
     - frontmatter keeps unknown keys
     - item_history gets a new updated snapshot row per save