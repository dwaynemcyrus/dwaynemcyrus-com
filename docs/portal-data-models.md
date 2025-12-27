# Voyagers Portal Data Models + Test Data

This document drafts the Phase 5 portal data model and provides test data to populate every portal surface.
It is written for Supabase Postgres, but can be adapted to other stores.

## 1) Reference enums (suggested)

Tiers (normalized to match current app code):
- group
- community
- armory
- patron

Visibility audience options:
- all
- group
- community
- armory
- patron

Session status options:
- scheduled
- completed
- canceled

Question status options:
- open
- answered
- archived

Upload status options:
- submitted
- in_review
- delivered

## 2) Core tables

### 2.1 portal_announcements
Announcements are visible per tier.

Columns:
- id (uuid, pk)
- title (text)
- body_md (text)
- audience (text) -- all | group | community | armory | patron
- published_at (timestamptz)
- created_at (timestamptz)
- created_by (uuid) -- user id

### 2.2 portal_resources
Resources can be links or files, with tier gating.

Columns:
- id (uuid, pk)
- title (text)
- description (text)
- resource_type (text) -- link | file
- url (text, nullable)
- file_path (text, nullable) -- Supabase Storage path
- audience (text)
- tags (text[])
- created_at (timestamptz)
- created_by (uuid)

### 2.3 portal_sessions
Scheduled sessions or recordings.

Columns:
- id (uuid, pk)
- title (text)
- summary (text)
- session_type (text) -- live | recording
- status (text) -- scheduled | completed | canceled
- starts_at (timestamptz, nullable)
- ends_at (timestamptz, nullable)
- meeting_url (text, nullable)
- recording_url (text, nullable)
- audience (text)
- created_at (timestamptz)
- created_by (uuid)

### 2.4 portal_questions
Questions submitted by members; staff replies can be appended.

Columns:
- id (uuid, pk)
- user_id (uuid)
- title (text)
- body_md (text)
- status (text) -- open | answered | archived
- audience (text) -- who can see the response
- created_at (timestamptz)
- answered_at (timestamptz, nullable)

### 2.5 portal_feedback_notes
Private staff feedback for a member (not necessarily tied to a question).

Columns:
- id (uuid, pk)
- user_id (uuid)
- title (text)
- body_md (text)
- created_at (timestamptz)
- created_by (uuid)

### 2.6 portal_uploads
Member submissions (files, reports, summaries) for review.

Columns:
- id (uuid, pk)
- user_id (uuid)
- title (text)
- summary (text)
- file_path (text, nullable)
- status (text) -- submitted | in_review | delivered
- audience (text)
- created_at (timestamptz)
- updated_at (timestamptz)

### 2.7 portal_cohorts
Cohort definitions.

Columns:
- id (uuid, pk)
- name (text)
- cohort_code (text) -- short human code
- description (text)
- start_date (date)
- end_date (date)
- audience (text) -- who can see cohort details
- created_at (timestamptz)
- created_by (uuid)

### 2.8 portal_cohort_members
Membership map of users to cohorts.

Columns:
- id (uuid, pk)
- cohort_id (uuid)
- user_id (uuid)
- role (text) -- member | lead | mentor
- joined_at (timestamptz)

## 3) Test data (seed)

Use these sample user ids in Supabase auth users:
- owner: 00000000-0000-0000-0000-000000000001
- group:  00000000-0000-0000-0000-000000000002
- community: 00000000-0000-0000-0000-000000000003
- armory: 00000000-0000-0000-0000-000000000004
- patron: 00000000-0000-0000-0000-000000000005

### 3.1 Announcements
```sql
insert into portal_announcements (id, title, body_md, audience, published_at, created_at, created_by)
values
  ('11111111-1111-1111-1111-111111111111', 'Welcome to Voyagers', 'We are live. Start here.', 'all', now(), now(), '00000000-0000-0000-0000-000000000001'),
  ('11111111-1111-1111-1111-111111111112', 'Community kickoff', 'Community call this Friday.', 'community', now(), now(), '00000000-0000-0000-0000-000000000001'),
  ('11111111-1111-1111-1111-111111111113', 'Armory deep dive', 'Armory-only teardown recording.', 'armory', now(), now(), '00000000-0000-0000-0000-000000000001'),
  ('11111111-1111-1111-1111-111111111114', 'Patron briefing', 'Private roadmap notes.', 'patron', now(), now(), '00000000-0000-0000-0000-000000000001');
```

### 3.2 Resources
```sql
insert into portal_resources (id, title, description, resource_type, url, file_path, audience, tags, created_at, created_by)
values
  ('22222222-2222-2222-2222-222222222221', 'Portal Getting Started', 'Orientation guide PDF', 'file', null, 'resources/portal/getting-started.pdf', 'all', array['onboarding'], now(), '00000000-0000-0000-0000-000000000001'),
  ('22222222-2222-2222-2222-222222222222', 'Community Playbook', 'Weekly rituals + templates', 'file', null, 'resources/community/playbook.pdf', 'community', array['playbook'], now(), '00000000-0000-0000-0000-000000000001'),
  ('22222222-2222-2222-2222-222222222223', 'Armory Tech Pack', 'Advanced teardown resources', 'file', null, 'resources/armory/tech-pack.zip', 'armory', array['advanced','teardown'], now(), '00000000-0000-0000-0000-000000000001'),
  ('22222222-2222-2222-2222-222222222224', 'Patron Brief', 'Private brief link', 'link', 'https://example.com/patron-brief', null, 'patron', array['brief'], now(), '00000000-0000-0000-0000-000000000001');
```

### 3.3 Sessions
```sql
insert into portal_sessions (id, title, summary, session_type, status, starts_at, ends_at, meeting_url, recording_url, audience, created_at, created_by)
values
  ('33333333-3333-3333-3333-333333333331', 'Monthly Town Hall', 'Open update + Q&A', 'live', 'scheduled', now() + interval '7 days', null, 'https://example.com/townhall', null, 'all', now(), '00000000-0000-0000-0000-000000000001'),
  ('33333333-3333-3333-3333-333333333332', 'Community Live Review', 'Feedback session', 'live', 'scheduled', now() + interval '10 days', null, 'https://example.com/community-review', null, 'community', now(), '00000000-0000-0000-0000-000000000001'),
  ('33333333-3333-3333-3333-333333333333', 'Armory Masterclass', 'Deep dive recording', 'recording', 'completed', null, null, null, 'https://example.com/armory-recording', 'armory', now(), '00000000-0000-0000-0000-000000000001'),
  ('33333333-3333-3333-3333-333333333334', 'Patron Strategy Call', 'Private strategy session', 'live', 'scheduled', now() + interval '3 days', null, 'https://example.com/patron-call', null, 'patron', now(), '00000000-0000-0000-0000-000000000001');
```

### 3.4 Questions
```sql
insert into portal_questions (id, user_id, title, body_md, status, audience, created_at, answered_at)
values
  ('44444444-4444-4444-4444-444444444441', '00000000-0000-0000-0000-000000000002', 'Feedback on landing page', 'How should I tighten the copy?', 'open', 'group', now(), null),
  ('44444444-4444-4444-4444-444444444442', '00000000-0000-0000-0000-000000000003', 'Positioning clarity', 'Do you see a better framing?', 'answered', 'community', now(), now()),
  ('44444444-4444-4444-4444-444444444443', '00000000-0000-0000-0000-000000000004', 'Stack decision', 'Should we ship this in Next or Astro?', 'answered', 'armory', now(), now()),
  ('44444444-4444-4444-4444-444444444444', '00000000-0000-0000-0000-000000000005', 'Private roadmap', 'What is next quarter focus?', 'open', 'patron', now(), null);
```

### 3.5 Feedback notes
```sql
insert into portal_feedback_notes (id, user_id, title, body_md, created_at, created_by)
values
  ('55555555-5555-5555-5555-555555555551', '00000000-0000-0000-0000-000000000003', 'Messaging refinement', 'Tighten the first paragraph and lead with the outcome.', now(), '00000000-0000-0000-0000-000000000001'),
  ('55555555-5555-5555-5555-555555555552', '00000000-0000-0000-0000-000000000004', 'Architecture direction', 'Stick with Next for the app; Astro for canon.', now(), '00000000-0000-0000-0000-000000000001');
```

### 3.6 Uploads
```sql
insert into portal_uploads (id, user_id, title, summary, file_path, status, audience, created_at, updated_at)
values
  ('66666666-6666-6666-6666-666666666661', '00000000-0000-0000-0000-000000000002', 'Landing page draft', 'New hero and CTA structure.', 'uploads/group/landing-draft.pdf', 'submitted', 'group', now(), now()),
  ('66666666-6666-6666-6666-666666666662', '00000000-0000-0000-0000-000000000003', 'Brand review deck', 'Updated tone and palette.', 'uploads/community/brand-review.pdf', 'in_review', 'community', now(), now()),
  ('66666666-6666-6666-6666-666666666663', '00000000-0000-0000-0000-000000000004', 'System design', 'Architecture diagram and notes.', 'uploads/armory/system-design.pdf', 'delivered', 'armory', now(), now());
```

### 3.7 Cohorts
```sql
insert into portal_cohorts (id, name, cohort_code, description, start_date, end_date, audience, created_at, created_by)
values
  ('77777777-7777-7777-7777-777777777771', 'Voyagers Cohort Spring', 'SPR25', 'Spring cohort for armory + patron.', '2025-03-01', '2025-06-01', 'armory', now(), '00000000-0000-0000-0000-000000000001'),
  ('77777777-7777-7777-7777-777777777772', 'Community Sprint', 'COM25', 'Short sprint for community tier.', '2025-04-01', '2025-05-15', 'community', now(), '00000000-0000-0000-0000-000000000001');
```

### 3.8 Cohort members
```sql
insert into portal_cohort_members (id, cohort_id, user_id, role, joined_at)
values
  ('88888888-8888-8888-8888-888888888881', '77777777-7777-7777-7777-777777777771', '00000000-0000-0000-0000-000000000004', 'member', now()),
  ('88888888-8888-8888-8888-888888888882', '77777777-7777-7777-7777-777777777771', '00000000-0000-0000-0000-000000000005', 'member', now()),
  ('88888888-8888-8888-8888-888888888883', '77777777-7777-7777-7777-777777777771', '00000000-0000-0000-0000-000000000001', 'lead', now()),
  ('88888888-8888-8888-8888-888888888884', '77777777-7777-7777-7777-777777777772', '00000000-0000-0000-0000-000000000003', 'member', now());
```
