# Campus Swap

A student-to-student second-hand marketplace mobile app built with Flutter and Supabase. Campus Swap lets university students buy, sell, and trade used items — textbooks, electronics, furniture, clothing — directly on campus.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Screenshots](#screenshots)
- [Tech Stack](#tech-stack)
- [Architecture](#architecture)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Supabase Setup](#supabase-setup)
- [Design System](#design-system)
- [Contributing](#contributing)

---

## Overview

Campus Swap solves a common student problem: what do you do with your textbooks, furniture, and gear at the end of a semester? Instead of discarding or hauling them home, students can list items for sale and connect with buyers on campus — no shipping, no strangers, no fees.

Key highlights:

- Real-time in-app messaging between buyers and sellers
- OTP-based email verification for student authenticity
- Multi-photo listings with condition grading and negotiable pricing
- Category and filter-based product discovery
- Star ratings and reviews for sellers
- User blocking and content reporting for community safety

---

## Features

### Authentication
- Email + OTP sign-up and login (6-digit code, 10-minute expiry)
- Password change and reset flows
- Student verification badge

### Listings
- Create listings with up to multiple photos (camera or gallery)
- Set price, condition (New / Like New / Good / Fair), category, location
- Toggle negotiable pricing and set a minimum offer
- Edit, delete, or mark items as sold
- View counter on each listing

### Discovery
- Home feed with featured categories
- Full-text search across product names
- Filter by category, condition, and max price
- Save / bookmark items for later
- Seller profile pages showing all active listings and ratings

### Messaging
- Real-time conversations tied to specific product listings
- Unread message badges on conversation list
- Live updates via Supabase Realtime subscriptions

### Profile & Settings
- Edit name, bio, avatar, campus location, and phone
- View personal listing history (active and sold)
- Email notification preferences
- Push notification settings per event type
- Blocked users management

### Moderation
- Report users or content
- Block users (hides their listings and messages)

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter (Material 3, SDK ≥ 3.3.0) |
| Backend | Supabase (PostgreSQL, Auth, Storage, Realtime) |
| State management | Provider 6 |
| Typography | Google Fonts — Manrope (headings) + Inter (body) |
| Image handling | image_picker 1.1 |
| Notifications | flutter_local_notifications 17 |
| Icons | cupertino_icons |

---

## Architecture

The app follows a layered service-provider-UI pattern:

```
UI Screens (35 screens)
      │
      ▼
Provider (AuthProvider)
      │
      ▼
Services (9 service classes)
      │
      ▼
Supabase SDK (auth · database · storage · realtime)
```

**Services**

| Service | Responsibility |
|---|---|
| `AuthService` | Sign up, login, OTP verify, password reset, sign out |
| `ProductService` | CRUD listings, search, filters, saved items, view tracking |
| `MessageService` | Conversations, messages, unread flags, realtime subscriptions |
| `ProfileService` | Get/update profiles, seller lookup, blocked users |
| `StorageService` | Image picking, compression, upload to Supabase Storage |
| `NotificationService` | Local notifications, realtime listeners (messages, reviews) |
| `PreferenceService` | Email and push notification preferences |
| `ReportService` | Report users and content |
| `ReviewService` | Submit and retrieve star ratings and written reviews |

**State management**

`AuthProvider` wraps `AuthService` and listens to Supabase auth state changes (`signedIn`, `tokenRefreshed`, `signedOut`). On login it initializes `NotificationService`; on logout it tears it down. All screens access auth state via `context.watch<AuthProvider>()` or `context.read<AuthProvider>()`.

---

## Project Structure

```
lib/
├── main.dart                  # App entry, Supabase init, Provider setup
├── config/
│   └── supabase_config.dart   # Supabase URL and anon key
├── models/
│   └── models.dart            # UserProfile, Product, Conversation, Message, Review, ...
├── providers/
│   └── auth_provider.dart     # AuthProvider (ChangeNotifier)
├── services/
│   ├── auth_service.dart
│   ├── product_service.dart
│   ├── message_service.dart
│   ├── profile_service.dart
│   ├── storage_service.dart
│   ├── notification_service.dart
│   ├── preference_service.dart
│   ├── report_service.dart
│   └── review_service.dart
├── screens/                   # 35 UI screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── verify_screen.dart
│   ├── main_screen.dart       # Bottom nav container
│   ├── home_screen.dart
│   ├── search_screen.dart
│   ├── listing_detail_screen.dart
│   ├── sell_flow_screen.dart  # 9-step listing wizard
│   ├── messages_screen.dart
│   ├── profile_screen.dart
│   └── ...
├── theme/
│   └── app_theme.dart         # Colors, typography, component themes
├── widgets/
│   └── product_card.dart      # Reusable listing card
└── data/
    └── mock_data.dart         # Dev/test mock data
```

---

## Getting Started

### Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) ≥ 3.3.0
- Android Studio (or VS Code with Flutter extension)
- Android emulator or physical device
- A Supabase project (see [Supabase Setup](#supabase-setup))

### Installation

1. Clone the repository:
   ```bash
   git clone <repo-url>
   cd Campus-Swap
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Add your Supabase credentials to [lib/config/supabase_config.dart](lib/config/supabase_config.dart):
   ```dart
   const supabaseUrl = 'https://YOUR_PROJECT.supabase.co';
   const supabaseAnonKey = 'YOUR_ANON_KEY';
   ```

4. Run the app:
   ```bash
   flutter run
   ```

> For a more detailed local setup walkthrough, see [SETUP.md](SETUP.md).

---

## Supabase Setup

Campus Swap uses Supabase for everything backend-related. See [SUPABASE_SETUP.md](SUPABASE_SETUP.md) for the full SQL schema and step-by-step configuration, but here is a summary:

### Database Tables

| Table | Description |
|---|---|
| `profiles` | Extends `auth.users` with name, bio, campus location, ratings, verification badge |
| `products` | Listings with price, condition, category, image URLs, sold/draft flags |
| `saved_items` | User bookmarks (user_id + product_id) |
| `conversations` | Messaging threads (buyer + seller + product) with unread flags |
| `messages` | Individual chat messages within a conversation |
| `blocked_users` | Pairs of blocker/blocked user IDs |
| `reviews` | Star ratings and written feedback between users |

### Storage Buckets

- `products/` — Listing images, path: `{user_id}/{product_id}/`
- `avatars/` — Profile pictures, path: `{user_id}/`

### Auth

Email OTP provider must be enabled in your Supabase project dashboard under **Authentication → Providers → Email**.

### Realtime

Enable Realtime on the `messages` and `conversations` tables in your Supabase project under **Database → Replication**.

---

## Design System

The app uses a warm brown and gold palette designed to feel trustworthy and campus-friendly.

| Token | Hex | Usage |
|---|---|---|
| Espresso | `#4B3621` | Primary text, dark elements |
| Mocha | `#7E6D57` | Secondary text |
| Stone | `#9B8B7E` | Disabled / tertiary text |
| Gold | `#D4AF37` | Primary actions, active states |
| Gold Light | `#FFF8E1` | Subtle gold backgrounds |
| Cream | `#F7F2E7` | App background |
| Base | `#FFFFFF` | Cards and surfaces |
| Border | `#E8DCC8` | Dividers and input borders |
| Alert | `#E54C4C` | Errors, destructive actions |

**Condition badge colors:** New → Green · Like New → Blue · Good → Gold · Fair → Gray

**Fonts:** Manrope (headings, bold 18–24 px) · Inter (body, regular 12–14 px)

---

## Contributing

1. Fork the repository and create a feature branch.
2. Follow the existing service-provider-screen layering — keep business logic in services, not screens.
3. Run `flutter analyze` before opening a PR; the project uses `flutter_lints`.
4. Open a pull request with a clear description of what changed and why.
