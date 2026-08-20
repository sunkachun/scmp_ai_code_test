# SCMP Staff Management App

A production-style Flutter application demonstrating Clean Architecture, BLoC state management, declarative routing, and real API integration against [ReqRes](https://reqres.in).

## Tech Stack

- **Flutter** (Dart)
- **Clean Architecture** (feature-first: `domain` / `data` / `presentation`)
- **BLoC** (`flutter_bloc` + `equatable`) for state management
- **go_router** for declarative routing and route guards
- **get_it** for dependency injection
- **http** for REST communication
- **shared_preferences** for token persistence
- **cached_network_image** for avatar loading/caching
- **flutter_dotenv** for environment variables

## Key Features

- **Login authentication** with email/password validation
- **Custom error dialog** displaying the exact spec text `"Error: Invalid crdentials"`
- **Staff Directory** with scroll-triggered auto-pagination (no "Load More" button)
- **Login token** displayed at the top of the staff page
- **Avatar images** via `CachedNetworkImage` with solid/hollow circle placeholders
- **Error handling** with a friendly message and "Retry" button
- **Real API integration** configured through environment variables

## Setup Instructions

1. **Clone the repository**

   ```bash
   git clone <repository-url>
   cd scmp_ai_code_test
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Create the `.env` file**

   In the project root (same directory as `pubspec.yaml`), create a file named `.env`:

   ```dotenv
   API_KEY=your_api_key_here
   ```

   > `.env` is git-ignored and never committed.

4. **Obtain an API key**

   - Visit [app.reqres.in](https://app.reqres.in) and register for an account.
   - Generate an API key from your account dashboard.
   - Paste it into `.env` as the value for `API_KEY`.

5. **Run the app**

   ```bash
   flutter run
   ```

   Use the following test credentials to log in:

   - Email: `eve.holt@reqres.in`
   - Password: `cityslicka`

6. **Run tests**

   ```bash
   flutter test
   ```

7. **Run static analysis**

   ```bash
   flutter analyze
   ```

## Architecture Overview

The project follows **Clean Architecture** with a feature-first layout. Each feature is split into three independent layers with no cross-feature dependencies:

```text
lib/
├── core/          # Cross-cutting concerns (constants, network, router, theme)
├── di/            # get_it dependency injection registry & mock switch
├── features/
│   ├── auth/
│   │   ├── data/          # Models, data sources (Mock/Http), repository impl
│   │   ├── domain/        # Entities, repository interfaces
│   │   └── presentation/  # BLoC, events, states, pages, widgets
│   └── staff/
│       ├── data/
│       ├── domain/
│       └── presentation/
└── main.dart      # Entry point & global providers
```

- **Domain** layer holds plain entities and repository contracts.
- **Data** layer implements repositories and data sources (mock vs. HTTP, toggled via `useMock`).
- **Presentation** layer contains BLoCs and UI widgets.
- Repositories throw plain `Exception`s on failure, caught by BLoCs via `try-catch`.

## AI Development Workflow

This project was built incrementally using a phased AI-assisted workflow (Phase 0–4): domain layer, data layer, state management & routing, and defensive UX + real API integration.

See [`AGENTS.md`](AGENTS.md) for detailed operational guidance for AI coding agents.

## Security Note

The `.env` file is intended for **local development only**. It is git-ignored and must never be committed. API keys shipped in a client bundle are inherently exposed to end users — in production, route requests through a **backend proxy** that injects the key server-side.

## CI Status

[![CI](https://github.com/OWNER/REPO/actions/workflows/ci.yml/badge.svg)](https://github.com/OWNER/REPO/actions/workflows/ci.yml)

> Replace `OWNER/REPO` with your actual GitHub repository to activate the badge.
