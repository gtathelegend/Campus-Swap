# Campus Swap — Supabase Setup Guide

## 1. Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com) and sign in
2. Click **New Project**, fill in your details
3. Wait for the project to be provisioned (~2 minutes)

---

## 2. Add Your Credentials

Open `lib/config/supabase_config.dart` and replace the placeholder values:

```dart
class SupabaseConfig {
  static const String url = 'https://xyzcompany.supabase.co';    // Project URL
  static const String anonKey = 'eyJhbGciOiJIUzI1NiIsInR5...';  // anon public key
}
```

Find these in: **Project Settings → API**

---

## 3. Run the SQL Schema

Go to **SQL Editor** in your Supabase dashboard and run the following:

```sql
-- ─────────────────────────────────────────────────────────────────────────────
-- EXTENSIONS
-- ─────────────────────────────────────────────────────────────────────────────
create extension if not exists "uuid-ossp";

-- ─────────────────────────────────────────────────────────────────────────────
-- PROFILES (extends auth.users)
-- ─────────────────────────────────────────────────────────────────────────────
create table public.profiles (
  id             uuid references auth.users(id) on delete cascade primary key,
  name           text not null default '',
  email          text not null default '',
  phone          text,
  bio            text,
  campus_location text default 'Main Campus',
  avatar_url     text,
  rating         double precision default 0.0,
  reviews_count  integer default 0,
  active_listings integer default 0,
  sold_items     integer default 0,
  verified       boolean default false,
  created_at     timestamptz default now()
);

alter table public.profiles enable row level security;

create policy "Profiles are publicly readable"
  on public.profiles for select using (true);

create policy "Users can update own profile"
  on public.profiles for update using (auth.uid() = id);

-- Trigger: auto-create profile row on signup
create or replace function public.handle_new_user()
returns trigger language plpgsql security definer set search_path = public as $$
begin
  insert into public.profiles (id, name, email)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    coalesce(new.email, '')
  );
  return new;
end;
$$;

create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ─────────────────────────────────────────────────────────────────────────────
-- PRODUCTS
-- ─────────────────────────────────────────────────────────────────────────────
create table public.products (
  id               uuid default uuid_generate_v4() primary key,
  seller_id        uuid references public.profiles(id) on delete cascade not null,
  name             text not null,
  description      text not null default '',
  price            double precision not null,
  condition        text not null,
  category         text not null,
  location         text not null,
  is_negotiable    boolean default false,
  min_offer        double precision,
  is_sold          boolean default false,
  is_draft         boolean default false,
  views_count      integer default 0,
  favorites_count  integer default 0,
  messages_count   integer default 0,
  image_urls       text[] default '{}',
  created_at       timestamptz default now()
);

alter table public.products enable row level security;

create policy "Products are publicly readable"
  on public.products for select using (true);

create policy "Sellers can create products"
  on public.products for insert with check (auth.uid() = seller_id);

create policy "Sellers can update own products"
  on public.products for update using (auth.uid() = seller_id);

create policy "Sellers can delete own products"
  on public.products for delete using (auth.uid() = seller_id);

-- Function to safely increment product views
create or replace function public.increment_product_views(pid uuid)
returns void language sql security definer as $$
  update public.products set views_count = views_count + 1 where id = pid;
$$;

-- ─────────────────────────────────────────────────────────────────────────────
-- SAVED ITEMS
-- ─────────────────────────────────────────────────────────────────────────────
create table public.saved_items (
  id         uuid default uuid_generate_v4() primary key,
  user_id    uuid references public.profiles(id) on delete cascade not null,
  product_id uuid references public.products(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique(user_id, product_id)
);

alter table public.saved_items enable row level security;

create policy "Users can view own saved items"
  on public.saved_items for select using (auth.uid() = user_id);

create policy "Users can save items"
  on public.saved_items for insert with check (auth.uid() = user_id);

create policy "Users can unsave items"
  on public.saved_items for delete using (auth.uid() = user_id);

-- ─────────────────────────────────────────────────────────────────────────────
-- CONVERSATIONS
-- ─────────────────────────────────────────────────────────────────────────────
create table public.conversations (
  id                  uuid default uuid_generate_v4() primary key,
  buyer_id            uuid references public.profiles(id) on delete cascade not null,
  seller_id           uuid references public.profiles(id) on delete cascade not null,
  product_id          uuid references public.products(id) on delete set null,
  last_message        text,
  last_message_at     timestamptz default now(),
  buyer_has_unread    boolean default false,
  seller_has_unread   boolean default false,
  created_at          timestamptz default now(),
  unique(buyer_id, seller_id, product_id)
);

alter table public.conversations enable row level security;

create policy "Participants can view their conversations"
  on public.conversations for select
  using (auth.uid() = buyer_id or auth.uid() = seller_id);

create policy "Buyers can start conversations"
  on public.conversations for insert
  with check (auth.uid() = buyer_id);

create policy "Participants can update conversations"
  on public.conversations for update
  using (auth.uid() = buyer_id or auth.uid() = seller_id);

-- ─────────────────────────────────────────────────────────────────────────────
-- MESSAGES
-- ─────────────────────────────────────────────────────────────────────────────
create table public.messages (
  id              uuid default uuid_generate_v4() primary key,
  conversation_id uuid references public.conversations(id) on delete cascade not null,
  sender_id       uuid references public.profiles(id) on delete cascade not null,
  text            text not null,
  created_at      timestamptz default now()
);

alter table public.messages enable row level security;

create policy "Participants can view messages"
  on public.messages for select using (
    exists (
      select 1 from public.conversations c
      where c.id = conversation_id
        and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())
    )
  );

create policy "Participants can send messages"
  on public.messages for insert with check (
    auth.uid() = sender_id
    and exists (
      select 1 from public.conversations c
      where c.id = conversation_id
        and (c.buyer_id = auth.uid() or c.seller_id = auth.uid())
    )
  );

-- ─────────────────────────────────────────────────────────────────────────────
-- BLOCKED USERS
-- ─────────────────────────────────────────────────────────────────────────────
create table public.blocked_users (
  id         uuid default uuid_generate_v4() primary key,
  blocker_id uuid references public.profiles(id) on delete cascade not null,
  blocked_id uuid references public.profiles(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique(blocker_id, blocked_id)
);

alter table public.blocked_users enable row level security;

create policy "Users can view own blocked list"
  on public.blocked_users for select using (auth.uid() = blocker_id);

create policy "Users can block others"
  on public.blocked_users for insert with check (auth.uid() = blocker_id);

create policy "Users can unblock"
  on public.blocked_users for delete using (auth.uid() = blocker_id);

-- ─────────────────────────────────────────────────────────────────────────────
-- REALTIME (enable for messaging)
-- ─────────────────────────────────────────────────────────────────────────────
-- Run these in the Supabase dashboard → Table Editor → Realtime:
-- Enable realtime for: messages, conversations
```

---

## 4. Create Storage Buckets

In **Storage → New Bucket**:

| Bucket Name   | Public | Description                |
|---------------|--------|----------------------------|
| `products`    | ✅ Yes  | Product listing images      |
| `avatars`     | ✅ Yes  | User profile pictures       |

For each bucket, add a **Storage Policy** (Policies tab):

### products bucket policies:
```sql
-- Allow anyone to view product images
create policy "Public product images"
  on storage.objects for select using (bucket_id = 'products');

-- Allow authenticated users to upload
create policy "Authenticated upload product images"
  on storage.objects for insert
  with check (bucket_id = 'products' and auth.role() = 'authenticated');

-- Allow users to delete own images
create policy "Delete own product images"
  on storage.objects for delete
  using (bucket_id = 'products' and auth.uid()::text = (storage.foldername(name))[1]);
```

### avatars bucket policies:
```sql
create policy "Public avatars"
  on storage.objects for select using (bucket_id = 'avatars');

create policy "Authenticated upload avatar"
  on storage.objects for insert
  with check (bucket_id = 'avatars' and auth.role() = 'authenticated');

create policy "Update own avatar"
  on storage.objects for update
  using (bucket_id = 'avatars' and auth.uid()::text = (storage.foldername(name))[1]);
```

---

## 5. Enable Email OTP (for verify screen)

Go to **Authentication → Providers → Email**:
- Enable **Email OTP**
- Set OTP length: 6
- Set OTP expiry: 600 seconds (10 min)

---

## 6. Enable Realtime

Go to **Database → Replication** and enable realtime for:
- `messages`
- `conversations`

---

## 7. Run the App

```bash
flutter pub get
flutter run
```

---

## Feature Summary

| Feature              | Implementation                                      |
|----------------------|-----------------------------------------------------|
| User signup/login    | Supabase Auth (email + OTP verification)            |
| User profiles        | `profiles` table with avatar storage               |
| Product listings     | `products` table with image upload to Storage       |
| Search & filters     | Supabase `.ilike()`, `.eq()`, `.lte()` queries     |
| Save/unsave items    | `saved_items` table with toggle                     |
| Real-time messaging  | `messages` + Supabase stream subscription          |
| Conversations        | `conversations` table with unread tracking          |
| Block users          | `blocked_users` table                              |
| My listings          | Filtered by `seller_id = current user`              |
| Seller profiles      | Profile data + products joined from DB              |
