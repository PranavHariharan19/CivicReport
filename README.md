# CivicReport

A Flutter-based community civic issue reporting platform. Citizens can report local urban problems (potholes, broken streetlights, illegal dumping, noise complaints, etc.), track resolution status, and interact with other community members. Administrators can manage complaints, update statuses, mark issues as resolved, and visualize reported issues on a heatmap.

Built for **Smart India Hackathon (SIH)**.

---

## Table of Contents

- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Features](#features)
- [Screens & Routes](#screens--routes)
- [Data Models](#data-models)
- [Backend (Supabase)](#backend-supabase)
- [Getting Started](#getting-started)
- [Current Status](#current-status)
- [Improvement Roadmap](#improvement-roadmap)

---

## Tech Stack

| Technology | Version | Purpose |
|---|---|---|
| Flutter | >=3.35.0 | Cross-platform UI framework |
| Dart | >=3.9.2 | Language |
| Supabase Flutter | ^2.12.0 | Backend (auth, PostgreSQL DB, storage) |
| Provider | ^6.1.1 | State management |
| Image Picker | ^1.2.0 | Camera/gallery image selection |
| Cupertino Icons | ^1.0.8 | iOS-style icons |

---

## Project Structure

```
lib/
  main.dart                          # App entry point, Provider setup, route definitions
  models.dart                        # Barrel file — re-exports all model classes
  models/
    user.dart                        # User data model
    comment.dart                     # Comment data model
    report.dart                      # Report data model (incl. computed status/priority colors)
  providers/
    complaints_provider.dart         # ChangeNotifier — Supabase data fetching & state
  services/
    auth_service.dart                # Supabase authentication (email, Google OAuth, password reset)
    storage_service.dart             # File picker + Supabase Storage upload
  pages/
    landing_page.dart                # Marketing page with hero, features, testimonials, CTA
    login_page.dart                  # Public / Admin login (mock auth)
    main_feed_page.dart              # Community feed with create-report dialog
    report_status_page.dart          # Full report detail view with admin controls
    profile_page.dart                # User profile with stats, settings tabs, logout
    user_reports_page.dart           # Individual user's report list
    admin_page.dart                  # Admin dashboard + filtered complaints list
    heatmap_page.dart                # Visual report heatmap with filters
  widgets/
    app_colors.dart                  # App-wide color constants and gradients
    report_card.dart                 # Reusable card: avatar, content, image, tags, votes, comments
    animations.dart                  # AnimatedFadeSlide, HoverButton, HoverableCard, RotatingTestimonials
```

---

## Features

### Implemented (with mock data)

- **Landing page** — Animated hero, feature cards, problem/solution comparison, stats, testimonials, app store CTAs
- **Dual login** — Separate entry points for public users and admins
- **Community feed** — Scrollable list of report cards with author info, timestamps, images, and tags
- **Create report** — Dialog with title, description, and tag selection
- **Upvote / downvote** — Toggle voting with live count updates
- **Comments** — Dialog with threaded comment list and input
- **Status tracking** — Color-coded chips: Open (orange), In Progress (blue), Resolved (green), Rejected (red)
- **Report detail page** — Full report view; tapping the status chip navigates here
- **Admin workflow** — Set to In-Progress, Mark as Resolved (with notes + proof photo), Reject
- **User profiles** — Avatar, join date, stats (reports/upvotes/comments), settings tabs, logout
- **Admin dashboard** — Stats overview (Total / Pending / In Progress / Resolved) with drill-down
- **Filtered complaints** — View complaints filtered by status
- **Reports heatmap** — Colored markers on a grid with legend and filter panel
- **Pull-to-refresh** — On feed and profile pages
- **Responsive layout** — Desktop / tablet / mobile breakpoints

### Partially Implemented (Supabase code exists but not wired to UI)

- Email/password authentication
- Google OAuth sign-in
- Real-time report stream via Supabase
- Report CRUD against Supabase `reports` table
- File upload to Supabase Storage (images, videos, avatars)

---

## Screens & Routes

| Route | Widget | Description |
|---|---|---|
| `/` | `LandingPage` | Marketing landing page |
| `/login` | `LoginPage(userType: 'public')` | Public login |
| `/admin-login` | `LoginPage(userType: 'admin')` | Admin login |
| `/feed` | `MainFeedPage` | Community report feed |
| `/admin` | `AdminDashboard` | Admin dashboard |
| `/heatmap` | `HeatmapPage` | Reports heatmap |

---

## Data Models

### User
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID |
| `username` | `String` | Display name |
| `email` | `String?` | Email address |
| `joinDate` | `DateTime` | Account creation date |
| `profileImageUrl` | `String?` | Avatar URL |
| `isAdmin` | `bool` | Admin flag |
| `reportsSubmitted` | `int` | Report count |
| `totalUpvotes` | `int` | Upvote count |
| `totalComments` | `int` | Comment count |

### Report
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID |
| `author` | `User` | Report author |
| `title` | `String` | Report title |
| `description` | `String` | Detailed description |
| `imageUrl` | `String?` | Evidence image |
| `tags` | `List<String>` | Categorisation tags |
| `upvotes` / `downvotes` | `int` | Vote counts |
| `status` | `String?` | open / in-progress / resolved / rejected |
| `priority` | `String?` | low / medium / high / urgent |
| `latitude` / `longitude` | `double` | GPS coordinates |
| `resolutionNotes` | `String?` | Admin resolution notes |
| `resolutionProofUrl` | `String?` | Proof image URL |

### Comment
| Field | Type | Description |
|---|---|---|
| `id` | `String` | Unique ID |
| `author` | `User` | Comment author |
| `text` | `String` | Comment body |
| `dateTime` | `DateTime` | Creation time |

---

## Backend (Supabase)

### Tables Expected

**`users`** — Auth and profile data linked to Supabase Auth.

**`reports`** — Civic issue reports with status, priority, location, and resolution metadata.

**`votes`** — Per-report upvote/downvote records.

**`comments`** — Per-report comment threads.

### Storage Buckets

| Bucket | Purpose |
|---|---|
| `images` | General images |
| `videos` | General videos |
| `avatars` | Profile pictures |
| `reports` | Report media files |

---

## Getting Started

### Prerequisites

- Flutter SDK >=3.35.0 ([install guide](https://docs.flutter.dev/get-started/install))
- Supabase project ([create one](https://supabase.com/dashboard))
- Dart SDK >=3.9.2

### Setup

```bash
# Clone the repository
git clone <repo-url>
cd sih

# Install dependencies
flutter pub get

# Configure Supabase
# Update the Supabase URL and anon key in the auth service or add them to your environment.
# By default the app runs in mock mode — no real backend required.

# Run the app
flutter run
```

The app currently runs in **prototype mode** with hardcoded mock data. To connect to a live Supabase instance, configure your project credentials and wire the existing Supabase service calls into the UI (see [auth_service.dart](lib/services/auth_service.dart) and [complaints_provider.dart](lib/providers/complaints_provider.dart)).

---

## Current Status

The project is a **functional prototype** built for SIH. All user-facing screens work with in-memory mock data. The Supabase integration layer is fully written but not yet connected to the UI flows.

### What Works
- All 8 screens with navigation
- Report creation, voting, commenting (local only)
- Admin status management (local only)
- Responsive landing page with animations

### What Needs Wiring
- Login page currently bypasses auth (tap "Proceed")
- Reports, votes, comments are stored in-memory, not persisted
- Supabase `ComplaintsProvider` methods exist but are not consumed by widgets
- Real map integration for the heatmap page

---

## Improvement Roadmap

1. **Wire real authentication** — Connect `AuthService` to the login page
2. **Persist data** — Use `ComplaintsProvider` to read/write reports via Supabase
3. **Real map** — Replace the mock heatmap with `flutter_map` or Google Maps
4. **Push notifications** — Add Firebase Cloud Messaging or Supabase Realtime for status updates
5. **Image upload** — Connect `StorageService` + `ImagePicker` to report creation
6. **Input validation** — Add validation to create-report dialog
7. **Error handling** — Consistent error/loading/empty states across all screens
8. **Tests** — Replace the outdated test with widget and unit tests
9. **.env configuration** — Externalise Supabase credentials
