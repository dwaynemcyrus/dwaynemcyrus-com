// Future reference: https://docs.astro.build/en/guides/content-collections/

// 1. Import utilities from `astro:content`
import { defineCollection, z } from 'astro:content';

// 2. Import loader(s)
import { glob } from 'astro/loaders';

// Normalize empty strings/nulls to undefined so optional fields can be left blank in frontmatter.
const allowEmpty = <T extends z.ZodTypeAny>(schema: T) =>
	z.preprocess((val) => (val === '' || val === null ? undefined : val), schema);

// 3. Define your collection(s)

// Essays Collection - matches knowledge repo structure
const essays = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './src/content/essays' }),
	schema: z.object({
		cuid: allowEmpty(z.string().optional()),
		date: z.coerce.date(),
		dateUpdated: allowEmpty(z.coerce.date().optional()),
		title: z.string(),
		subtitle: allowEmpty(z.string().optional()),
		status: allowEmpty(z.union([z.string(), z.array(z.string())]).optional()),
		growth: allowEmpty(z.array(z.string()).optional()),
		description: allowEmpty(z.string().optional()),
		collection: allowEmpty(z.array(z.string()).optional()),
		genre: allowEmpty(z.string().optional()),
		length: allowEmpty(z.array(z.string()).optional()),
		tags: allowEmpty(z.array(z.string()).optional().default([])),
		bookmark: allowEmpty(z.boolean().optional()),
		resources: allowEmpty(z.array(z.string()).optional()),
		coverLink: allowEmpty(z.string().optional()),
		coverAltText: allowEmpty(z.string().optional()),
		coverCaptionText: allowEmpty(z.string().optional()),
	}),
});

// Lab Collection - experiments that feed other systems
const lab = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './src/content/lab' }),
	schema: z.object({
		cuid: allowEmpty(z.string().optional()),
		date: z.coerce.date(),
		title: z.string(),
		subtitle: allowEmpty(z.string().optional()),
		summary: allowEmpty(z.string().optional()),
		description: allowEmpty(z.string().optional()),
		status: allowEmpty(z.string().optional()),
		slug: allowEmpty(z.string().optional()),
		collection: allowEmpty(z.array(z.string()).optional()),
		categories: allowEmpty(z.array(z.string()).optional()),
		resources: allowEmpty(z.array(z.string()).optional()),
		tags: allowEmpty(z.array(z.string()).optional().default([])),
		coverURL: allowEmpty(z.string().optional()),
		coverAltText: allowEmpty(z.string().optional()),
		coverCaptionText: allowEmpty(z.string().optional()),
		coverThumbURL: allowEmpty(z.string().optional()),
		dateUpdated: allowEmpty(z.coerce.date().optional()),
		dateStart: allowEmpty(z.coerce.date().optional()),
		dateEnd: allowEmpty(z.coerce.date().optional()),
	}),
});

// Notes Collection - atomic notes for digital garden
const notes = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './src/content/notes' }),
	schema: z.object({
		cuid: allowEmpty(z.string().optional()),
		date: z.coerce.date(),
		title: z.string(),
		collection: allowEmpty(z.array(z.string()).optional()),
		tags: allowEmpty(z.array(z.string()).optional().default([])),
		source: allowEmpty(z.array(z.string()).optional()),
		chains: allowEmpty(z.array(z.string()).optional()),
	}),
});

// Projects Collection - matches knowledge repo structure
const projects = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './src/content/projects' }),
	schema: z.object({
		title: z.string(),
		slug: allowEmpty(z.string().optional()),
		status: allowEmpty(z.union([z.string(), z.array(z.string())]).optional()),
		summary: allowEmpty(z.string().optional()),
		date: z.coerce.date(),
		cuid: z.string(),
		dateUpdated: allowEmpty(z.coerce.date().optional()),
		tags: allowEmpty(z.array(z.string()).optional().default([])),
		collection: allowEmpty(z.array(z.string()).optional()),
		subtitle: allowEmpty(z.string().optional()),
		categories: allowEmpty(z.array(z.string()).optional()),
		description: allowEmpty(z.string().optional()),
		coverAltText: allowEmpty(z.string().optional()),
		coverCaptionText: allowEmpty(z.string().optional()),
		coverLink: allowEmpty(z.string().optional()),
		dateStart: allowEmpty(z.coerce.date().optional()),
		dateEnd: allowEmpty(z.coerce.date().optional()),
		resources: allowEmpty(z.array(z.string()).optional()),
		// Allow flexible schema for additional fields
	}).passthrough(),
});

// References Collection - reference materials
const references = defineCollection({
	loader: glob({ pattern: '**/[^_]*.md', base: './src/content/references' }),
	schema: z.object({
		cuid: allowEmpty(z.string().optional()),
		date: z.coerce.date(),
		title: z.string(),
		status: allowEmpty(z.array(z.string()).optional()),
		description: allowEmpty(z.string().optional()),
		collection: allowEmpty(z.array(z.string()).optional()),
		source: allowEmpty(z.array(z.string()).optional()),
		tags: allowEmpty(z.array(z.string()).optional().default([])),
	}),
});

// 4. Export a single `collections` object to register your collection(s)
export const collections = {
	// essays,
	// notes,
	lab,
	projects,
	// references,
};
