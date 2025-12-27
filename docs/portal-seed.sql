-- Voyagers portal seed data (Phase 5)
-- Assumes auth.users rows exist for the ids referenced below.

insert into public.portal_announcements (id, title, body_md, audience, published_at, created_at, created_by)
values
  ('11111111-1111-1111-1111-111111111111', 'Welcome to Voyagers', 'We are live. Start here.', 'all', now(), now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('11111111-1111-1111-1111-111111111112', 'Community kickoff', 'Community call this Friday.', 'community', now(), now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('11111111-1111-1111-1111-111111111113', 'Armory deep dive', 'Armory-only teardown recording.', 'armory', now(), now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('11111111-1111-1111-1111-111111111114', 'Patron briefing', 'Private roadmap notes.', 'patron', now(), now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26');

insert into public.portal_resources (id, title, description, resource_type, url, file_path, audience, tags, created_at, created_by)
values
  ('22222222-2222-2222-2222-222222222221', 'Portal Getting Started', 'Orientation guide PDF', 'file', null, 'resources/portal/getting-started.pdf', 'all', array['onboarding'], now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('22222222-2222-2222-2222-222222222222', 'Community Playbook', 'Weekly rituals + templates', 'file', null, 'resources/community/playbook.pdf', 'community', array['playbook'], now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('22222222-2222-2222-2222-222222222223', 'Armory Tech Pack', 'Advanced teardown resources', 'file', null, 'resources/armory/tech-pack.zip', 'armory', array['advanced','teardown'], now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('22222222-2222-2222-2222-222222222224', 'Patron Brief', 'Private brief link', 'link', 'https://example.com/patron-brief', null, 'patron', array['brief'], now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26');

insert into public.portal_sessions (id, title, summary, session_type, status, starts_at, ends_at, meeting_url, recording_url, audience, created_at, created_by)
values
  ('33333333-3333-3333-3333-333333333331', 'Monthly Town Hall', 'Open update + Q&A', 'live', 'scheduled', now() + interval '7 days', null, 'https://example.com/townhall', null, 'all', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('33333333-3333-3333-3333-333333333332', 'Community Live Review', 'Feedback session', 'live', 'scheduled', now() + interval '10 days', null, 'https://example.com/community-review', null, 'community', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('33333333-3333-3333-3333-333333333333', 'Armory Masterclass', 'Deep dive recording', 'recording', 'completed', null, null, null, 'https://example.com/armory-recording', 'armory', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('33333333-3333-3333-3333-333333333334', 'Patron Strategy Call', 'Private strategy session', 'live', 'scheduled', now() + interval '3 days', null, 'https://example.com/patron-call', null, 'patron', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26');

insert into public.portal_questions (id, user_id, title, body_md, status, audience, created_at, answered_at)
values
  ('44444444-4444-4444-4444-444444444441', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Feedback on landing page', 'How should I tighten the copy?', 'open', 'group', now(), null),
  ('44444444-4444-4444-4444-444444444442', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Positioning clarity', 'Do you see a better framing?', 'answered', 'community', now(), now()),
  ('44444444-4444-4444-4444-444444444443', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Stack decision', 'Should we ship this in Next or Astro?', 'answered', 'armory', now(), now()),
  ('44444444-4444-4444-4444-444444444444', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Private roadmap', 'What is next quarter focus?', 'open', 'patron', now(), null);

insert into public.portal_feedback_notes (id, user_id, title, body_md, created_at, created_by)
values
  ('55555555-5555-5555-5555-555555555551', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Messaging refinement', 'Tighten the first paragraph and lead with the outcome.', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('55555555-5555-5555-5555-555555555552', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Architecture direction', 'Stick with Next for the app; Astro for canon.', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26');

insert into public.portal_uploads (id, user_id, title, summary, file_path, status, audience, created_at, updated_at)
values
  ('66666666-6666-6666-6666-666666666661', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Landing page draft', 'New hero and CTA structure.', 'uploads/group/landing-draft.pdf', 'submitted', 'group', now(), now()),
  ('66666666-6666-6666-6666-666666666662', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'Brand review deck', 'Updated tone and palette.', 'uploads/community/brand-review.pdf', 'in_review', 'community', now(), now()),
  ('66666666-6666-6666-6666-666666666663', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'System design', 'Architecture diagram and notes.', 'uploads/armory/system-design.pdf', 'delivered', 'armory', now(), now());

insert into public.portal_cohorts (id, name, cohort_code, description, start_date, end_date, audience, created_at, created_by)
values
  ('77777777-7777-7777-7777-777777777771', 'Voyagers Cohort Spring', 'SPR25', 'Spring cohort for armory + patron.', '2025-03-01', '2025-06-01', 'armory', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26'),
  ('77777777-7777-7777-7777-777777777772', 'Community Sprint', 'COM25', 'Short sprint for community tier.', '2025-04-01', '2025-05-15', 'community', now(), '60e97597-1eca-4af6-b89d-da0ca28d1f26');

insert into public.portal_cohort_members (id, cohort_id, user_id, role, joined_at)
values
  ('88888888-8888-8888-8888-888888888881', '77777777-7777-7777-7777-777777777771', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'member', now()),
  ('88888888-8888-8888-8888-888888888882', '77777777-7777-7777-7777-777777777771', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'member', now()),
  ('88888888-8888-8888-8888-888888888883', '77777777-7777-7777-7777-777777777771', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'lead', now()),
  ('88888888-8888-8888-8888-888888888884', '77777777-7777-7777-7777-777777777772', '60e97597-1eca-4af6-b89d-da0ca28d1f26', 'member', now())
on conflict (cohort_id, user_id) do nothing;
