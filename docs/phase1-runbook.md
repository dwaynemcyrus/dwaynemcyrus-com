# Phase 1 Runbook (Publishing Spine)

This is the minimum repeatable sequence to publish the public canon.

## 1) Export Public Mirror
```bash
SUPABASE_URL="https://your-project-id.supabase.co" \
SUPABASE_SERVICE_ROLE_KEY="your-service-role-key" \
PUBLIC_MIRROR_DIR="public-mirror" \
npm run export:public
```

## 2) Verify Public Mirror
```bash
npm run build
```

The `prebuild` guard fails if `public-mirror/` is empty.

## 3) Deploy
Deploy the Astro build from this repo after a successful export.

## Notes
- Update `docs/canonical-allowlist.md` before adding new public routes.
- Keep the service role key private (never commit it).
