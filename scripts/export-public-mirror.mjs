import { mkdir, writeFile } from 'node:fs/promises';
import { join } from 'node:path';

const SUPABASE_URL = process.env.SUPABASE_URL;
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY;
const TARGET_DIR = process.env.PUBLIC_MIRROR_DIR || 'public-mirror';
const PAGE_SIZE = 1000;

if (!SUPABASE_URL || !SUPABASE_SERVICE_ROLE_KEY) {
	console.error('Missing SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY.');
	process.exit(1);
}

const allowlistedPrefixes = ['/lab/', '/projects/'];

const slugify = (value) =>
	value
		.toLowerCase()
		.replace(/[^a-z0-9]+/g, '-')
		.replace(/(^-|-$)/g, '');

const toYamlScalar = (value) => {
	if (value === null || value === undefined) return '""';
	return `"${String(value).replace(/"/g, '\\"')}"`;
};

const toYamlArray = (value) => {
	if (!Array.isArray(value) || value.length === 0) return '[]';
	return value.map((item) => `- ${toYamlScalar(item)}`).join('\n');
};

const makeFrontmatter = (doc) => {
	const metadata = doc.metadata || {};
	const dateValue = metadata.date || doc.created_at;
	const summaryValue = metadata.summary || '';
	const tagsValue = metadata.tags || [];

	const lines = [
		'---',
		`id: ${toYamlScalar(doc.id)}`,
		`title: ${toYamlScalar(doc.title)}`,
		`slug: ${toYamlScalar(doc.slug || '')}`,
		`collection: ${toYamlScalar(doc.collection || '')}`,
		`visibility: ${toYamlScalar(doc.visibility)}`,
		`status: ${toYamlScalar(doc.status)}`,
		`canonical: ${toYamlScalar(doc.canonical)}`,
		`redirect_from: ${toYamlArray(doc.redirect_from)}`,
		`summary: ${toYamlScalar(summaryValue)}`,
		`tags: ${toYamlArray(tagsValue)}`,
		`date: ${toYamlScalar(dateValue || '')}`,
		'---',
	];

	return lines.join('\n');
};

const derivePath = (doc) => {
	const canonical = doc.canonical || '';
	const prefix = allowlistedPrefixes.find((allowed) => canonical.startsWith(allowed));
	if (!prefix) return null;

	const folder = prefix.replace(/\//g, '');
	const canonicalTail = canonical.replace(prefix, '').replace(/^\//, '');
	const baseName = doc.slug || canonicalTail;
	if (!baseName) return null;

	return {
		folder,
		filename: slugify(baseName),
	};
};

const fetchDocumentsBatch = async (offset) => {
	const url = new URL(`${SUPABASE_URL}/rest/v1/documents`);
	url.searchParams.set(
		'select',
		[
			'id',
			'title',
			'slug',
			'collection',
			'visibility',
			'status',
			'canonical',
			'redirect_from',
			'body_md',
			'metadata',
			'created_at',
		].join(',')
	);
	url.searchParams.set('visibility', 'eq.public');
	url.searchParams.set('status', 'eq.published');
	url.searchParams.set('canonical', 'not.is.null');

	const rangeStart = offset;
	const rangeEnd = offset + PAGE_SIZE - 1;

	const response = await fetch(url.toString(), {
		headers: {
			apikey: SUPABASE_SERVICE_ROLE_KEY,
			authorization: `Bearer ${SUPABASE_SERVICE_ROLE_KEY}`,
			Prefer: 'count=exact',
			Range: `${rangeStart}-${rangeEnd}`,
		},
	});

	if (!response.ok) {
		throw new Error(`Supabase query failed: ${response.status} ${response.statusText}`);
	}

	const total = response.headers.get('content-range');
	const items = await response.json();

	return { items, total };
};

const exportDocuments = async () => {
	let exported = 0;
	let skipped = 0;
	let scanned = 0;
	let offset = 0;
	let totalCount = null;
	const skipReasons = {};

	while (totalCount === null || offset < totalCount) {
		const { items, total } = await fetchDocumentsBatch(offset);
		if (total && total.includes('/')) {
			totalCount = Number(total.split('/')[1]);
		}

		if (!items.length) break;

		for (const doc of items) {
			scanned += 1;

			if (!doc.id || !doc.title || !doc.canonical || !doc.body_md) {
				skipped += 1;
				skipReasons.missing_required = (skipReasons.missing_required || 0) + 1;
				continue;
			}

			if (!allowlistedPrefixes.some((prefix) => doc.canonical.startsWith(prefix))) {
				skipped += 1;
				skipReasons.canonical_not_allowlisted = (skipReasons.canonical_not_allowlisted || 0) + 1;
				continue;
			}

			const target = derivePath(doc);
			if (!target || !target.filename) {
				skipped += 1;
				skipReasons.invalid_path = (skipReasons.invalid_path || 0) + 1;
				continue;
			}

			const outputDir = join(TARGET_DIR, target.folder);
			await mkdir(outputDir, { recursive: true });

			const frontmatter = makeFrontmatter(doc);
			const content = `${frontmatter}\n\n${doc.body_md.trim()}\n`;
			const outputPath = join(outputDir, `${target.filename}.md`);
			await writeFile(outputPath, content, 'utf8');
			exported += 1;
		}

		offset += PAGE_SIZE;
	}

	console.log('Export complete.');
	console.log(`Scanned: ${scanned}`);
	console.log(`Exported: ${exported}`);
	console.log(`Skipped: ${skipped}`);
	if (Object.keys(skipReasons).length > 0) {
		console.log('Skip reasons:', skipReasons);
	}
};

exportDocuments().catch((error) => {
	console.error(error);
	process.exit(1);
});
