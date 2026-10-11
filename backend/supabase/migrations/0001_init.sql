-- AUC Rideshare schema (PostgreSQL / Supabase).
-- Run in the Supabase SQL editor, or with `supabase db push`.

create table if not exists profiles (
  auc_id             text primary key check (auc_id ~ '^\d{9}$'),
  first_name         text not null,
  last_name          text not null,
  phone_number       text not null unique,
  password_hash      text not null,
  is_driver          boolean not null default false,
  is_banned          boolean not null default false,
  phone_verified     boolean not null default false,
  last_known_address text,
  created_at         timestamptz not null default now()
);

create table if not exists ride (
  ride_id      bigint generated always as identity primary key,
  rider_id     text not null references profiles (auc_id) on delete cascade,
  driver_id    text references profiles (auc_id) on delete set null,
  status       text not null default 'requested'
               check (status in ('requested', 'accepted', 'completed', 'canceled')),
  requested_at timestamptz not null default now(),
  accepted_at  timestamptz,
  completed_at timestamptz,
  canceled_at  timestamptz,
  canceled_by  text references profiles (auc_id) on delete set null
);
create index if not exists ride_status_idx on ride (status);
create index if not exists ride_rider_idx on ride (rider_id);
create index if not exists ride_driver_idx on ride (driver_id);

create table if not exists ratings (
  ride_id    bigint not null references ride (ride_id) on delete cascade,
  rater_id   text not null references profiles (auc_id) on delete cascade,
  ratee_id   text not null references profiles (auc_id) on delete cascade,
  score      smallint not null check (score between 1 and 5),
  created_at timestamptz not null default now(),
  primary key (ride_id, rater_id)
);
create index if not exists ratings_ratee_idx on ratings (ratee_id);

-- Friend requests
create table if not exists request (
  id          bigint generated always as identity primary key,
  sender_id   text not null references profiles (auc_id) on delete cascade,
  receiver_id text not null references profiles (auc_id) on delete cascade,
  status      text not null default 'Pending' check (status in ('Pending', 'Accepted', 'Declined')),
  sent_at     timestamptz not null default now(),
  check (sender_id <> receiver_id)
);
create index if not exists request_receiver_idx on request (receiver_id, status);

create table if not exists locations (
  user_id    text primary key references profiles (auc_id) on delete cascade,
  lat        double precision not null check (lat between -90 and 90),
  lng        double precision not null check (lng between -180 and 180),
  updated_at timestamptz not null default now()
);

-- Only the backend (service-role key) touches these tables. Enabling RLS with no policies
-- means the public anon key can read or write nothing, even if it leaks.
alter table profiles  enable row level security;
alter table ride      enable row level security;
alter table ratings   enable row level security;
alter table request   enable row level security;
alter table locations enable row level security;
