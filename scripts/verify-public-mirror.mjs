import { readdir } from 'node:fs/promises';
import { join } from 'node:path';

const TARGET_DIR = process.env.PUBLIC_MIRROR_DIR || 'public-mirror';

const hasMarkdownFiles = async (dir) => {
	let entries;
	try {
		entries = await readdir(dir, { withFileTypes: true });
	} catch (error) {
		return false;
	}

	for (const entry of entries) {
		const fullPath = join(dir, entry.name);
		if (entry.isDirectory()) {
			if (await hasMarkdownFiles(fullPath)) {
				return true;
			}
		} else if (entry.isFile() && entry.name.endsWith('.md')) {
			return true;
		}
	}

	return false;
};

const run = async () => {
	const found = await hasMarkdownFiles(TARGET_DIR);
	if (!found) {
		console.error(`No markdown files found in ${TARGET_DIR}. Run the exporter first.`);
		process.exit(1);
	}

	console.log(`Public mirror check passed: ${TARGET_DIR}`);
};

run().catch((error) => {
	console.error(error);
	process.exit(1);
});
