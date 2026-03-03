-- ============================================================
-- Supabase Migration — Finance App
-- Run this entire script in: Supabase Dashboard > SQL Editor
-- ============================================================

-- 1. TRANSACTIONS
create table if not exists transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  description text not null,
  amount numeric not null,
  type text not null check (type in ('income', 'expense')),
  category text not null default 'General',
  date date,
  created_at timestamptz default now()
);
alter table transactions enable row level security;
drop policy if exists "Users manage own transactions" on transactions;
create policy "Users manage own transactions" on transactions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 2. RECURRING TRANSACTIONS
create table if not exists recurring_transactions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  description text not null,
  amount numeric not null,
  type text not null check (type in ('income', 'expense')),
  category text not null default 'General',
  frequency text not null default 'monthly',
  created_at timestamptz default now()
);
alter table recurring_transactions enable row level security;
drop policy if exists "Users manage own recurring" on recurring_transactions;
create policy "Users manage own recurring" on recurring_transactions
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 3. GOALS
create table if not exists goals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references auth.users(id) on delete cascade not null,
  name text not null,
  target_amount numeric not null,
  current_amount numeric not null default 0,
  initial_amount numeric not null default 0,
  deadline date,
  created_at timestamptz default now()
);
alter table goals enable row level security;
drop policy if exists "Users manage own goals" on goals;
create policy "Users manage own goals" on goals
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- 4. USER SETTINGS
create table if not exists user_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  currency text not null default 'EUR',
  language text not null default 'en',
  updated_at timestamptz default now()
);
alter table user_settings enable row level security;
drop policy if exists "Users manage own settings" on user_settings;
create policy "Users manage own settings" on user_settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);
