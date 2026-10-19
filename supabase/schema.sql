create table if not exists public.site_admins (
  user_id uuid primary key references auth.users (id) on delete cascade,
  created_at timestamptz not null default now()
);

create table if not exists public.news (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 200),
  body text not null check (char_length(body) between 1 and 10000),
  published_at timestamptz not null default now(),
  created_by uuid not null default auth.uid() references auth.users (id)
);

create table if not exists public.documents (
  id uuid primary key default gen_random_uuid(),
  title text not null check (char_length(title) between 1 and 200),
  description text not null default '' check (char_length(description) <= 2000),
  file_url text not null check (file_url ~* '^https?://'),
  created_at timestamptz not null default now(),
  created_by uuid not null default auth.uid() references auth.users (id)
);

alter table public.site_admins enable row level security;
alter table public.news enable row level security;
alter table public.documents enable row level security;

revoke all on public.site_admins from anon, authenticated;
grant select on public.news, public.documents to anon, authenticated;
grant insert, update, delete on public.news, public.documents to authenticated;

create or replace function public.is_site_admin()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.site_admins
    where user_id = (select auth.uid())
  );
$$;

revoke all on function public.is_site_admin() from public, anon;
grant execute on function public.is_site_admin() to authenticated;

drop policy if exists "Public can read news" on public.news;
create policy "Public can read news"
  on public.news for select
  to anon, authenticated
  using (true);

drop policy if exists "Admins can insert news" on public.news;
create policy "Admins can insert news"
  on public.news for insert
  to authenticated
  with check (public.is_site_admin() and created_by = (select auth.uid()));

drop policy if exists "Admins can update news" on public.news;
create policy "Admins can update news"
  on public.news for update
  to authenticated
  using (public.is_site_admin())
  with check (public.is_site_admin());

drop policy if exists "Admins can delete news" on public.news;
create policy "Admins can delete news"
  on public.news for delete
  to authenticated
  using (public.is_site_admin());

drop policy if exists "Public can read documents" on public.documents;
create policy "Public can read documents"
  on public.documents for select
  to anon, authenticated
  using (true);

drop policy if exists "Admins can insert documents" on public.documents;
create policy "Admins can insert documents"
  on public.documents for insert
  to authenticated
  with check (public.is_site_admin() and created_by = (select auth.uid()));

drop policy if exists "Admins can update documents" on public.documents;
create policy "Admins can update documents"
  on public.documents for update
  to authenticated
  using (public.is_site_admin())
  with check (public.is_site_admin());

drop policy if exists "Admins can delete documents" on public.documents;
create policy "Admins can delete documents"
  on public.documents for delete
  to authenticated
  using (public.is_site_admin());
