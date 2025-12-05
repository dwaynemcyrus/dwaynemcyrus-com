
## Setup commands


## Code style
- TypeScript strict mode
- Single quotes in all JavaScript, TypeScript, Astro script blHere you go — a clean, authoritative Agents.md file you can drop straight into 
docs/Agents.md.
This reads like an internal engineering directive, which is exactly what you want.


Agents.md

Coding Rules & Style Conventions for dwaynemcyrus.com



This document defines the quote-style rules and related formatting conventions enforced across the project.
Agents, tools, collaborators, and future-you must all follow this consistently.

⸻

1. Core Rule

Use single quotes in all JavaScript, TypeScript, and Astro script blocks.
Use double quotes in HTML, JSX attributes, JSON, and Markdown frontmatter.

Consistency is the priority. All automated agents must adhere to this specification.

⸻

2. Language-Specific Rules

JavaScript / TypeScript

✔ Use single quotes for all strings.

const title = 'Thunder Recall';
import Engine from '../lib/engine';

Rationale: cleaner code, fewer escapes, easier embedding of HTML/JSON fragments.

⸻

Astro (script sections)

✔ Use single quotes inside <script> blocks or frontmatter script sections.

---
const pageTitle = 'AI Design Engineer | Dwayne M. Cyrus';
import BaseLayout from '../layouts/BaseLayout.astro';
---


⸻

JSX / React Islands

✔ Props use double quotes
✔ JS inside JSX uses single quotes

<Component mode="dark" title="Voyager OS" />

const status = 'active';


⸻

HTML / Astro Markup

✔ Use double quotes for attributes.

<a href="/projects" class="link">Projects</a>


⸻

JSON Files (package.json, config, schemas)

✔ Double quotes are mandatory — JSON spec requires them.

{
  "name": "dwaynemcyrus-site",
  "version": "0.1.0"
}


⸻

Markdown Frontmatter

✔ Use double quotes in YAML frontmatter for clarity and consistency.

title: "Event-Driven State Engine"
description: "Exploration into reactive AI systems."
tags:
  - ai
  - systems

Markdown content itself has no restrictions.

⸻

SQL / Supabase Queries

✔ Single quotes for values
✔ Double quotes for identifiers (only when required)

SELECT * FROM profiles WHERE subscription_status = 'active';


⸻

3. Enforcement

All agents and collaborators must format code using Prettier with the following mandatory setting:

{
  "singleQuote": true
}

Additional Prettier or EditorConfig rules should not overwrite or contradict the quote rules in this document.

⸻

4. Purpose

These conventions exist to:
	•	Maintain consistency across the entire codebase.
	•	Simplify reasoning for both humans and automated agents.
	•	Reduce cognitive load and refactoring churn.
	•	Preserve clean diffs and predictable formatting under Cursor-assisted development.

⸻

5. Non-Negotiable

Agents must not:
	•	Switch quote styles arbitrarily.
	•	Introduce double quotes in JS/TS unless escaping requires it.
	•	Rewrite HTML/JSX attributes using single quotes.
	•	Alter JSON quotation behavior.

This is the enforced house style.

⸻

If you want, I can now produce the matching .prettierrc and .editorconfig files so Cursor formats everything automatically according to this spec.ocks
