-- 알바 시간 계산기 Supabase schema
-- Supabase SQL Editor에서 실행하세요

create table if not exists public.shifts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  date text not null,
  start_time text not null,
  end_time text not null,
  break_min integer default 0,
  created_at timestamptz default now(),
  constraint shifts_user_date_unique unique (user_id, date)
);

alter table public.shifts enable row level security;

create policy "shifts_user_policy" on public.shifts
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);

create table if not exists public.user_settings (
  user_id uuid not null references auth.users(id) on delete cascade primary key,
  wage integer default 10030,
  updated_at timestamptz default now()
);

alter table public.user_settings enable row level security;

create policy "settings_user_policy" on public.user_settings
  for all using (auth.uid() = user_id)
  with check (auth.uid() = user_id);
