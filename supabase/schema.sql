-- XENOS PRISON — Supabase database
-- Kør hele filen i Supabase > SQL Editor.
-- Login er Supabase Auth. Betalinger sker via Tebex, ikke i denne database.

create table if not exists public.site_admins (
  user_id uuid primary key references auth.users(id) on delete cascade
);
alter table public.site_admins enable row level security;
create policy "Admins can see own membership" on public.site_admins
  for select to authenticated using (user_id = (select auth.uid()));

create or replace function public.is_site_admin()
returns boolean language sql stable security definer set search_path = '' as $$
  select exists (select 1 from public.site_admins where user_id = (select auth.uid()));
$$;

create table if not exists public.forum_threads (
  id bigint generated always as identity primary key,
  author_id uuid not null references auth.users(id) on delete cascade,
  author_name text not null check (char_length(author_name) between 1 and 64),
  category text not null check (category in ('Generelt','Hjælp','Forslag','Fejlmeldinger')),
  title text not null check (char_length(title) between 5 and 120),
  body text not null check (char_length(body) between 10 and 5000),
  created_at timestamptz not null default now()
);
create index if not exists forum_threads_created_idx on public.forum_threads(created_at desc);
create index if not exists forum_threads_author_idx on public.forum_threads(author_id,created_at desc);
alter table public.forum_threads enable row level security;
create policy "Read forum threads" on public.forum_threads
  for select to anon, authenticated using (true);
create policy "Create own forum thread" on public.forum_threads
  for insert to authenticated with check (author_id = (select auth.uid()));
create policy "Remove own forum thread or admin" on public.forum_threads
  for delete to authenticated using (author_id = (select auth.uid()) or (select public.is_site_admin()));

create table if not exists public.forum_replies (
  id bigint generated always as identity primary key,
  thread_id bigint not null references public.forum_threads(id) on delete cascade,
  author_id uuid not null references auth.users(id) on delete cascade,
  author_name text not null check (char_length(author_name) between 1 and 64),
  body text not null check (char_length(body) between 2 and 3000),
  created_at timestamptz not null default now()
);
create index if not exists forum_replies_thread_idx on public.forum_replies(thread_id,created_at);
create index if not exists forum_replies_author_idx on public.forum_replies(author_id,created_at desc);
alter table public.forum_replies enable row level security;
create policy "Read forum replies" on public.forum_replies
  for select to anon, authenticated using (true);
create policy "Create own forum reply" on public.forum_replies
  for insert to authenticated with check (author_id = (select auth.uid()));
create policy "Remove own reply or admin" on public.forum_replies
  for delete to authenticated using (author_id = (select auth.uid()) or (select public.is_site_admin()));

create table if not exists public.applications (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null check (role in ('staff','bygger','youtuber')),
  minecraft_name text not null check (char_length(minecraft_name) between 3 and 24),
  discord_name text not null check (char_length(discord_name) between 2 and 80),
  age integer check (age between 13 and 100),
  availability text not null default '' check (char_length(availability) <= 120),
  experience text not null check (char_length(experience) between 20 and 4000),
  motivation text not null check (char_length(motivation) between 20 and 4000),
  contribution text not null check (char_length(contribution) between 20 and 4000),
  portfolio text not null default '' check (char_length(portfolio) <= 500),
  status text not null default 'afventer' check (status in ('afventer','under behandling','godkendt','afvist')),
  created_at timestamptz not null default now()
);
create index if not exists applications_author_idx on public.applications(user_id,created_at desc);
alter table public.applications enable row level security;
create policy "Applicants and admins can read" on public.applications
  for select to authenticated using (user_id = (select auth.uid()) or (select public.is_site_admin()));
create policy "Applicant can submit their own application" on public.applications
  for insert to authenticated with check (user_id = (select auth.uid()) and status = 'afventer');
create policy "Admins can update applications" on public.applications
  for update to authenticated using ((select public.is_site_admin())) with check ((select public.is_site_admin()));
create policy "Admins can delete applications" on public.applications
  for delete to authenticated using ((select public.is_site_admin()));

-- Grundlæggende spam-beskyttelse. Tilføj evt. CAPTCHA og hårdere moderationsværktøjer.
create or replace function public.limit_forum_posts()
returns trigger language plpgsql security definer set search_path = '' as $$
begin
  if tg_table_name = 'forum_threads' then
    if exists (select 1 from public.forum_threads
               where author_id = new.author_id and created_at > now() - interval '30 seconds') then
      raise exception 'Vent mindst 30 sekunder mellem nye tråde';
    end if;
  else
    if exists (select 1 from public.forum_replies
               where author_id = new.author_id and created_at > now() - interval '5 seconds') then
      raise exception 'Vent lidt mellem dine svar';
    end if;
  end if;
  return new;
end;
$$;
create trigger forum_thread_rate_limit before insert on public.forum_threads
  for each row execute function public.limit_forum_posts();
create trigger forum_reply_rate_limit before insert on public.forum_replies
  for each row execute function public.limit_forum_posts();

-- Valgfrit: markér din egen konto som admin, når du har oprettet den.
-- Find brugerens UUID under Authentication > Users i Supabase.
-- Erstat værdien og kør linjen alene i SQL Editor:
-- insert into public.site_admins (user_id) values ('DIN-UUID-HER');

-- VIGTIGT: Dette skema gør det muligt at modtage ansøgninger og moderere i
-- Supabase Table Editor. En separat staff-administrationsside er IKKE inkluderet.
-- Du skal konfigurere databeskyttelse, retention og evt. spamkontrol inden launch.
