// Future reference: https://docs.astro.build/en/guides/content-collections/

// 1. Import utilities from `astro:content`
import { defineCollection, z } from 'astro:content';

// 2. Import loader(s)
import { glob } from 'astro/loaders';

// Normalize empty strings/nulls to undefined so optional fields can be left blank in frontmatter.
const allowEmpty = <T extends z.ZodTypeAny>(schema: T) =>
	z.preprocess((val) => (val === '' || val === null ? undefined : val), schema);

// 3. Define your collection(s)

const publishSchema = z.object({
	id: z.string(),
	title: z.string(),
	slug: allowEmpty(z.string().optional()),
	collection: allowEmpty(z.string().optional()),
	visibility: z.string(),
	status: z.string(),
	canonical: z.string(),
	redirect_from: allowEmpty(z.array(z.string()).optional().default([])),
	summary: allowEmpty(z.string().optional()),
	tags: allowEmpty(z.array(z.string()).optional().default([])),
	tiers: allowEmpty(z.array(z.string()).optional().default([])),
	date: allowEmpty(z.coerce.date().optional()),
});

// Lab Collection - public mirror export
const lab = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './public-mirror/lab' }),
	schema: publishSchema,
});

// Projects Collection - public mirror export
const projects = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './public-mirror/projects' }),
	schema: publishSchema,
});

// 4. Export a single `collections` object to register your collection(s)
export const collections = {
	lab,
	projects,
};
