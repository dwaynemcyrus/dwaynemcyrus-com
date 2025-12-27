-- Voyagers portal schema (Phase 5)
-- Requires auth.users for user references.

create extension if not exists "pgcrypto";

create or replace function public.has_active_entitlement(required_tier text)
returns boolean
language sql
stable
as $$
	select exists (
		select 1
		from public.entitlements
		where user_id = auth.uid()
			and tier = required_tier
			and active = true
			and (expires_at is null or expires_at > now())
	);
$$;

create or replace function public.can_access_audience(required_audience text)
returns boolean
language sql
stable
as $$
	select
		required_audience = 'all'
		or public.has_active_entitlement(required_audience);
$$;

create table if not exists public.portal_admins (
	user_id uuid primary key references auth.users(id),
	added_at timestamptz not null default now()
);

create or replace function public.is_portal_admin()
returns boolean
language sql
stable
as $$
	select exists (
		select 1
		from public.portal_admins
		where user_id = auth.uid()
	);
$$;

alter table public.portal_admins enable row level security;
create policy "portal_admins_select"
on public.portal_admins
for select
using (public.is_portal_admin());

create policy "portal_admins_manage"
on public.portal_admins
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_announcements (
	id uuid primary key default gen_random_uuid(),
	title text not null,
	body_md text not null,
	audience text not null check (audience in ('all','group','community','armory','patron')),
	published_at timestamptz,
	created_at timestamptz not null default now(),
	created_by uuid not null references auth.users(id)
);

create index if not exists portal_announcements_audience_idx on public.portal_announcements (audience);
create index if not exists portal_announcements_published_idx on public.portal_announcements (published_at desc);

alter table public.portal_announcements enable row level security;
create policy "portal_announcements_select"
on public.portal_announcements
for select
using (public.can_access_audience(audience) or public.is_portal_admin());

create policy "portal_announcements_manage"
on public.portal_announcements
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_resources (
	id uuid primary key default gen_random_uuid(),
	title text not null,
	description text,
	resource_type text not null check (resource_type in ('link','file')),
	url text,
	file_path text,
	audience text not null check (audience in ('all','group','community','armory','patron')),
	tags text[] not null default '{}',
	created_at timestamptz not null default now(),
	created_by uuid not null references auth.users(id),
	check (
		(resource_type = 'link' and url is not null) or
		(resource_type = 'file' and file_path is not null)
	)
);

create index if not exists portal_resources_audience_idx on public.portal_resources (audience);
create index if not exists portal_resources_tags_idx on public.portal_resources using gin (tags);

alter table public.portal_resources enable row level security;
create policy "portal_resources_select"
on public.portal_resources
for select
using (public.can_access_audience(audience) or public.is_portal_admin());

create policy "portal_resources_manage"
on public.portal_resources
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_sessions (
	id uuid primary key default gen_random_uuid(),
	title text not null,
	summary text,
	session_type text not null check (session_type in ('live','recording')),
	status text not null check (status in ('scheduled','completed','canceled')),
	starts_at timestamptz,
	ends_at timestamptz,
	meeting_url text,
	recording_url text,
	audience text not null check (audience in ('all','group','community','armory','patron')),
	created_at timestamptz not null default now(),
	created_by uuid not null references auth.users(id),
	check (
		(session_type = 'live' and meeting_url is not null) or
		(session_type = 'recording' and recording_url is not null)
	)
);

create index if not exists portal_sessions_audience_idx on public.portal_sessions (audience);
create index if not exists portal_sessions_starts_idx on public.portal_sessions (starts_at);

alter table public.portal_sessions enable row level security;
create policy "portal_sessions_select"
on public.portal_sessions
for select
using (public.can_access_audience(audience) or public.is_portal_admin());

create policy "portal_sessions_manage"
on public.portal_sessions
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_questions (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id),
	title text not null,
	body_md text not null,
	status text not null check (status in ('open','answered','archived')),
	audience text not null check (audience in ('all','group','community','armory','patron')),
	created_at timestamptz not null default now(),
	answered_at timestamptz
);

create index if not exists portal_questions_user_idx on public.portal_questions (user_id);
create index if not exists portal_questions_status_idx on public.portal_questions (status);

alter table public.portal_questions enable row level security;
create policy "portal_questions_select"
on public.portal_questions
for select
using (
	user_id = auth.uid()
	or (status = 'answered' and public.can_access_audience(audience))
	or public.is_portal_admin()
);

create policy "portal_questions_insert"
on public.portal_questions
for insert
with check (user_id = auth.uid());

create policy "portal_questions_update"
on public.portal_questions
for update
using (public.is_portal_admin())
with check (public.is_portal_admin());

create policy "portal_questions_delete"
on public.portal_questions
for delete
using (public.is_portal_admin());

create table if not exists public.portal_feedback_notes (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id),
	title text not null,
	body_md text not null,
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now(),
	created_by uuid not null references auth.users(id)
);

create index if not exists portal_feedback_user_idx on public.portal_feedback_notes (user_id);

alter table public.portal_feedback_notes enable row level security;
create policy "portal_feedback_notes_select"
on public.portal_feedback_notes
for select
using (user_id = auth.uid() or public.is_portal_admin());

create policy "portal_feedback_notes_manage"
on public.portal_feedback_notes
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_uploads (
	id uuid primary key default gen_random_uuid(),
	user_id uuid not null references auth.users(id),
	title text not null,
	summary text,
	file_path text,
	status text not null check (status in ('submitted','in_review','delivered')),
	audience text not null check (audience in ('all','group','community','armory','patron')),
	created_at timestamptz not null default now(),
	updated_at timestamptz not null default now()
);

create index if not exists portal_uploads_user_idx on public.portal_uploads (user_id);
create index if not exists portal_uploads_status_idx on public.portal_uploads (status);

alter table public.portal_uploads enable row level security;
create policy "portal_uploads_select"
on public.portal_uploads
for select
using (user_id = auth.uid() or public.is_portal_admin());

create policy "portal_uploads_insert"
on public.portal_uploads
for insert
with check (user_id = auth.uid());

create policy "portal_uploads_update"
on public.portal_uploads
for update
using (public.is_portal_admin())
with check (public.is_portal_admin());

create policy "portal_uploads_delete"
on public.portal_uploads
for delete
using (public.is_portal_admin());

create table if not exists public.portal_cohorts (
	id uuid primary key default gen_random_uuid(),
	name text not null,
	cohort_code text not null,
	description text,
	start_date date,
	end_date date,
	audience text not null check (audience in ('all','group','community','armory','patron')),
	created_at timestamptz not null default now(),
	created_by uuid not null references auth.users(id),
	unique (cohort_code)
);

create index if not exists portal_cohorts_audience_idx on public.portal_cohorts (audience);

alter table public.portal_cohorts enable row level security;
create policy "portal_cohorts_select"
on public.portal_cohorts
for select
using (public.can_access_audience(audience) or public.is_portal_admin());

create policy "portal_cohorts_manage"
on public.portal_cohorts
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());

create table if not exists public.portal_cohort_members (
	id uuid primary key default gen_random_uuid(),
	cohort_id uuid not null references public.portal_cohorts(id) on delete cascade,
	user_id uuid not null references auth.users(id),
	role text not null check (role in ('member','lead','mentor')),
	joined_at timestamptz not null default now(),
	unique (cohort_id, user_id)
);

create index if not exists portal_cohort_members_user_idx on public.portal_cohort_members (user_id);

alter table public.portal_cohort_members enable row level security;
create policy "portal_cohort_members_select"
on public.portal_cohort_members
for select
using (user_id = auth.uid() or public.is_portal_admin());

create policy "portal_cohort_members_manage"
on public.portal_cohort_members
for all
using (public.is_portal_admin())
with check (public.is_portal_admin());
